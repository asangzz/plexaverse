import 'dart:async';

import 'package:flutter/foundation.dart';

import '../domain/plexa_repository.dart';
import '../domain/chat_bubble.dart';
import '../domain/plexa_day.dart';

/// Where the conversation is.
enum PlexaPhase { loading, intro, working, done, empty }

/// The day, as a conversation.
///
/// A port of the thread logic in the web's
/// `components/automate/PlexaDayChat.tsx`. A [ChangeNotifier] rather than a
/// Riverpod notifier because this IS a conversation: it owns a cursor, a set
/// of skips and a generation counter, it is created when the sheet opens and
/// thrown away when it closes, and none of that wants to outlive the sheet or
/// be rebuilt under it.
///
/// ## What Plexa can and cannot do, which shapes everything here
///
/// This app holds `openid profile email w_member_social` on a personal
/// account. That is enough to publish a share and nothing else: commenting on
/// someone's post is Partner-Program-only, and there is no invitations API at
/// any scope. So Plexa cannot post a comment or send a request. It can write
/// them, hand them over one at a time, and keep the count.
///
/// The opening line says so, once. A chat that implies automation and then
/// hands you a clipboard on the third turn is a bait-and-switch, and this is a
/// surface meant to be opened every day for a thousand days.
///
/// ## One tap = opened + counted
///
/// "Open and comment" opens LinkedIn and marks the item at the same moment.
/// That is already this product's definition of done for the Top Voices lane —
/// `TopVoiceShown.actedAt` is documented as stamped when the user opens the
/// post to comment, "the closest thing to proof of the action we have".
/// Asking a second time would add a turn per item, ten times a day, to collect
/// an answer nothing can verify.
class PlexaChatController extends ChangeNotifier {
  PlexaChatController(this._repository, {this.onLaneCredited});

  final PlexaRepository _repository;

  /// Fired once per lane, after the server has accepted that lane's roadmap
  /// step — the hook the sheet hangs a roadmap re-read on.
  ///
  /// Injected rather than reached through a `Ref`, for the same reason
  /// [openAndCount] takes its `openUrl`: this is a plain [ChangeNotifier] with
  /// no provider scope of its own, and the roadmap lives in another slice.
  /// Without this the write is invisible — the server knows the step is done
  /// and the roadmap behind the sheet goes on showing it undone until
  /// something unrelated happens to refetch, which is how a user ends up
  /// redoing a day's work on the engagement screens.
  final VoidCallback? onLaneCredited;

  final List<ChatBubble> bubbles = <ChatBubble>[];
  bool isBotTyping = false;

  PlexaPhase phase = PlexaPhase.loading;
  PlexaDay day = const PlexaDay();
  int cursor = 0;
  int currentDay = 1;

  /// Today's roadmap step id per lane, resolved by the caller from the same
  /// roadmap table the dashboard renders. Empty when today's day has no such
  /// step — a company-brand user has no connection step at all, and a Season 2
  /// user is past the table's end. An absent entry means "nothing to credit",
  /// which is a real state, not a failure.
  Map<PlexaLane, int> _laneSteps = const <PlexaLane, int>{};

  /// Lanes already credited this session, so a wrap-around that re-clears the
  /// last item cannot fire a second write. The server is idempotent too; this
  /// just keeps the chat from making a pointless round trip.
  final Set<PlexaLane> _credited = <PlexaLane>{};

  /// How many times each item has been skipped this session.
  final Map<String, int> _skips = <String, int>{};

  /// Skipped twice — stop offering it, so the wrap-around terminates.
  final Set<String> _parked = <String>{};

  /// Conversation generation.
  ///
  /// Closing the sheet mid-sequence abandons the script, and every timer still
  /// parked between lines would otherwise wake up and pour itself into the
  /// next thread. Bumping this invalidates them.
  int _gen = 0;
  bool _alive = true;

  /// Which item's lines are allowed to land.
  ///
  /// A turn is one item's two bubbles. Skip is reachable WHILE those bubbles
  /// are still being typed — the dock only hides behind "Plexa is typing…"
  /// after a frame — so without this, tapping Skip mid-sequence leaves the
  /// abandoned item's draft to arrive underneath the next item's headline,
  /// and the thread reads as Plexa quoting the wrong post.
  int _turn = 0;

  bool _isCurrent(int gen, [int? turn]) =>
      _alive && _gen == gen && (turn == null || turn == _turn);

  @override
  void dispose() {
    _alive = false;
    _gen++;
    super.dispose();
  }

  DayItem? get currentItem =>
      cursor >= 0 && cursor < day.items.length ? day.items[cursor] : null;

  // ── Speaking ──────────────────────────────────────────────────────────────

  /// Resolves false when the conversation moved on mid-line.
  ///
  /// [turn] pins the line to the item it belongs to; omit it for lines that
  /// belong to the conversation rather than to an item (the opener, the two
  /// endings), which no skip should be able to cancel.
  Future<bool> _sendBot(String text, {Duration? delay, int? turn}) async {
    final int gen = _gen;
    isBotTyping = true;
    notifyListeners();

    await Future<void>.delayed(delay ?? ChatTiming.bot);
    if (!_isCurrent(gen, turn)) return false;

    isBotTyping = false;
    bubbles.add(ChatBubble(role: ChatRole.bot, text: text));
    notifyListeners();
    return true;
  }

  Future<bool> _sendBotSequence(List<String> lines, {int? turn}) async {
    for (int i = 0; i < lines.length; i++) {
      final bool ok = await _sendBot(
        lines[i],
        delay: i == 0 ? ChatTiming.sequenceFirst : ChatTiming.sequenceNext,
        turn: turn,
      );
      if (!ok) return false;
    }
    return true;
  }

  void _echoUser(
    String text, {
    String? badge,
    ChatBadgeTone tone = ChatBadgeTone.ok,
  }) {
    bubbles.add(
      ChatBubble(
        role: ChatRole.user,
        text: text,
        badge: badge,
        badgeTone: tone,
      ),
    );
    notifyListeners();
  }

  // ── Opening ───────────────────────────────────────────────────────────────

  Future<void> open({
    required int roadmapDay,
    Map<PlexaLane, int> laneSteps = const <PlexaLane, int>{},
  }) async {
    currentDay = roadmapDay;
    _laneSteps = laneSteps;
    final int gen = _gen;

    PlexaDay gathered;
    // Tracked separately from the day itself. A failed read and a day with
    // nothing in it both arrive here as an empty `PlexaDay`, and `ready`
    // cannot tell them apart — a default `PlexaReady` is all-false, which is
    // exactly what "nothing prepared" looks like. Branching on it sent the
    // user who had lost their connection an offer to spend XP.
    bool loadFailed = false;
    try {
      gathered = await _repository.fetchDay();
    } on Object {
      gathered = const PlexaDay();
      loadFailed = true;
    }
    if (!_isCurrent(gen)) return;

    day = gathered;

    if (gathered.items.isEmpty) {
      // Two different nothings, and they need different answers. A day with
      // no work PREPARED can be fixed by generating it; a day that failed to
      // load cannot be fixed from here at all.
      await _sendBotSequence(switch (gathered) {
        _ when loadFailed => <String>[
          'Day $roadmapDay. I couldn’t pull today’s list just now.',
          'Give it a minute and reopen me — nothing is lost.',
        ],
        // Nothing has been generated. Fixable, but it costs XP, so it is an
        // offer rather than something done on the way in.
        _ when gathered.ready.nothingPrepared => <String>[
          'Day $roadmapDay. Nothing is written yet for today.',
          'Open Comments or Connections and I’ll put today’s set together — '
              'that is where the XP is spent, so I will not do it behind '
              'your back.',
        ],
        // Prepared, and emptied. The third nothing, and the only happy one.
        _ => <String>[
          'Day $roadmapDay. Everything for today is already cleared.',
          'See you tomorrow.',
        ],
      });
      if (_isCurrent(gen)) {
        phase = PlexaPhase.empty;
        notifyListeners();
      }
      return;
    }

    final int already = gathered.clearedCount;
    final int remaining = gathered.items.length - already;
    final int nComments = gathered.inLane(PlexaLane.comments).length;
    final int nConns = gathered.inLane(PlexaLane.connections).length;

    final List<String> opener = <String>[
      'Day $roadmapDay. Here’s everything on your plate today.',
      // Pluralised, including the tail. A day with exactly one item read
      // "1 comments. I’ve written all of them." — and the first line a new
      // user ever sees from Plexa should not have a grammar mistake in it.
      '${<String?>[if (nComments > 0) '$nComments ${nComments == 1 ? 'comment' : 'comments'}', if (nConns > 0) '$nConns connection '
                '${nConns == 1 ? 'request' : 'requests'}'].whereType<String>().join(' and ')}. '
          'I’ve written ${gathered.items.length == 1 ? 'it' : 'all of them'}.',
      // Said once, at the top, and never again.
      'LinkedIn won’t let me post these for you — so I’ll hand them over one '
          'at a time, you tap through, and I’ll keep the count.',
      if (already > 0)
        'You’ve already cleared $already. Picking up at ${already + 1} of '
            '${gathered.items.length}.',
    ];

    final bool ok = await _sendBotSequence(opener);
    if (!ok || !_isCurrent(gen)) return;

    if (remaining == 0) {
      await _sendBot(
        'Actually — that’s all of them done. Nothing left for today.',
      );
      if (_isCurrent(gen)) {
        phase = PlexaPhase.done;
        notifyListeners();
      }
      return;
    }

    cursor = gathered.items.indexWhere(
      (DayItem i) => !gathered.session.isDone(i),
    );
    phase = PlexaPhase.working;
    notifyListeners();
    await _dealCurrent();
  }

  // ── Dealing one item ──────────────────────────────────────────────────────

  String? _spoken;

  Future<void> _dealCurrent() async {
    if (phase != PlexaPhase.working) return;
    final DayItem? item = currentItem;
    if (item == null || _spoken == item.id) return;
    _spoken = item.id;

    final List<DayItem> lane = day.inLane(item.lane);
    final int n = lane.indexWhere((DayItem i) => i.id == item.id) + 1;
    final int turn = _turn;

    await _sendBotSequence(<String>[
      '${item.lane.noun} $n of ${lane.length} — '
          '${item.context != null ? '${item.context}\n' : ''}${item.headline}',
      item.draft,
    ], turn: turn);
  }

  /// Moves the cursor, abandoning whatever is still being typed for the item
  /// being left behind.
  void _moveTo(int index) {
    _turn++;
    cursor = index;
    // A new turn means the abandoned sequence will never clear this, and the
    // dots would spin for ever under a fresh item.
    isBotTyping = false;
    notifyListeners();
  }

  // ── Advancing ─────────────────────────────────────────────────────────────

  /// The next thing to put in front of the user, or -1 when there is nothing.
  ///
  /// Searches FORWARD first and then WRAPS. Looking only forward meant a
  /// skipped item was never seen again: skip one, clear the rest, and the
  /// search from the end found nothing ahead of it and declared the day
  /// cleared with an item still open. "See you tomorrow" over unfinished work
  /// is the worst thing this surface can say — it is the one screen whose
  /// entire job is knowing what is left.
  ///
  /// [acted] is excluded explicitly rather than trusted to be in the session:
  /// the mark is optimistic and the wrap would otherwise hand back the item
  /// just completed.
  int _nextIndexAfter(int acted) {
    final List<int> open = <int>[];
    for (int i = 0; i < day.items.length; i++) {
      final DayItem it = day.items[i];
      if (i == acted) continue;
      if (day.session.isDone(it)) continue;
      if (_parked.contains(it.id)) continue;
      open.add(i);
    }
    if (open.isEmpty) return -1;
    return open.firstWhere((int i) => i > acted, orElse: () => open.first);
  }

  /// How the day ends. Only one of these two endings is ever honest.
  Future<void> _finish(int acted) async {
    final int left = day.items
        .asMap()
        .entries
        .where(
          (MapEntry<int, DayItem> e) =>
              e.key != acted && !day.session.isDone(e.value),
        )
        .length;

    await _sendBotSequence(
      left == 0
          ? <String>['That’s the whole day cleared.', 'See you tomorrow.']
          : <String>[
              'That’s everything except the $left you skipped.',
              'They’ll be here when you reopen me — nothing is lost, and the '
                  'day isn’t logged until they’re done.',
            ],
    );
    phase = PlexaPhase.done;
    notifyListeners();
  }

  Future<void> _advance(int from) async {
    final int next = _nextIndexAfter(from);
    final PlexaLane? lane = from >= 0 && from < day.items.length
        ? day.items[from].lane
        : null;

    // A lane is cleared when nothing in it is left. The target is what the day
    // could actually deal, not the roadmap's stated count: the roadmap asks
    // for twelve connection requests and the generator produces four, so a
    // chat reading the stated target would never let the user finish.
    if (lane != null) {
      final bool laneLeft = day.items.asMap().entries.any(
        (MapEntry<int, DayItem> e) =>
            e.value.lane == lane &&
            e.key != from &&
            !day.session.isDone(e.value),
      );
      if (!laneLeft) {
        // Credit BEFORE saying "logged", and let the line stand either way.
        // The write is what makes the roadmap agree with the chat; the user
        // being told so is the part that must not depend on the network.
        unawaited(_creditLane(lane));
        await _sendBot(
          lane == PlexaLane.comments
              ? 'That’s your comments done for today. Logged.'
              : 'Requests done. Logged.',
        );
      }
    }

    if (next == -1) {
      await _finish(from);
      return;
    }
    // Wrapping backwards is disorienting without a word for it — the user is
    // about to see something they already said no to.
    _moveTo(next);
    if (next < from) await _sendBot('Back to the one you skipped.');
    await _dealCurrent();
  }

  // ── The two actions ───────────────────────────────────────────────────────

  /// Opens LinkedIn and counts the item in the same tap.
  ///
  /// [openUrl] is injected rather than called directly so the controller stays
  /// free of Flutter's plugin layer and can be driven in a test. It answers
  /// whether LinkedIn actually came up.
  Future<void> openAndCount({
    required Future<bool> Function(String url) openUrl,
    required Future<void> Function(String text) copy,
  }) async {
    final DayItem? item = currentItem;
    if (item == null) return;
    final int from = cursor;

    // Clipboard first, then the hand-off: a browser that fails to open must
    // not also cost the user the text they were about to paste.
    await copy(item.draft);
    final bool opened = item.canOpen ? await openUrl(item.url) : false;

    // The echo says what happened, not what was attempted. On a phone a
    // hand-off CAN fail — no browser, a policy-restricted device, a malformed
    // url — and a line reading "Opened it" over a screen that never changed is
    // the one lie this surface cannot afford, on the one surface whose whole
    // job is keeping an honest count.
    //
    // It still counts either way. The draft is on the clipboard, the user
    // asked to act, and the lane's tally is the user's own record of that.
    _echoUser(
      opened ? 'Opened it' : 'Copied it',
      badge: opened ? 'copied' : 'linkedin didn’t open',
      tone: opened ? ChatBadgeTone.ok : ChatBadgeTone.warn,
    );

    // Optimistic, and the opposite of the rule the publish path follows.
    // Publishing must never claim something reached LinkedIn. Here the user is
    // telling US they acted and the server stores exactly that, so the only
    // failure is a tick that comes back.
    day = day.copyWith(session: day.session.withDone(item, done: true));
    notifyListeners();

    unawaited(_record(item));

    await _advance(from);
  }

  /// Credits today's roadmap step for a lane the user has just finished.
  ///
  /// Swallows its failure on purpose. The chat has already said the lane is
  /// done and the items themselves are recorded; the step is a derived mark
  /// the roadmap recomputes, and an error toast here would be a scary message
  /// about something the user cannot act on. The next open credits it again.
  Future<void> _creditLane(PlexaLane lane) async {
    final int? stepId = _laneSteps[lane];
    if (stepId == null || !_credited.add(lane)) return;
    try {
      await _repository.completeStep(levelId: currentDay, stepId: stepId);
    } on Object {
      _credited.remove(lane);
      return;
    }

    // Deliberately OUTSIDE the write's own catch, and guarded separately.
    // Telling the roadmap to re-read can fail on its own — this runs
    // unawaited, so the sheet (and the `Ref` the listener closes over) may
    // already be gone by the time the POST lands. Letting that land in the
    // branch above would retract `_credited` and re-POST a step the server
    // has already taken, to repair nothing: a stale roadmap is the smaller
    // wrong, and the next open fixes it.
    try {
      onLaneCredited?.call();
    } on Object {
      // Nothing to say and nothing to retry. The lane IS credited.
    }
  }

  /// Persists one clear, and puts the tick back if the write fails.
  ///
  /// Not awaited by the caller: the thread moves on immediately, which is the
  /// whole point of marking optimistically. A tick that stays after a failed
  /// write tells the user the day is recorded when it is not.
  Future<void> _record(DayItem item) async {
    try {
      final PlexaSession server = await _repository.setItemDone(
        lane: item.lane,
        itemId: item.id,
        topVoiceId: item.topVoiceId,
      );
      day = day.copyWith(session: server);
    } on Object {
      day = day.copyWith(session: day.session.withDone(item, done: false));
    }
    notifyListeners();
  }

  Future<void> skip() async {
    final DayItem? item = currentItem;
    if (item == null) return;
    _echoUser('Skip this one');

    // Offered once more, then parked. Without the park, wrapping back to
    // skipped items is a loop the user cannot leave except by closing the
    // sheet: skip everything once and Plexa deals the same ten again, for
    // ever. One second chance is the most a skip can be worth.
    final int seen = (_skips[item.id] ?? 0) + 1;
    _skips[item.id] = seen;
    if (seen >= 2) _parked.add(item.id);

    final int next = _nextIndexAfter(cursor);
    if (next == -1) {
      await _finish(-1);
      return;
    }
    final bool backwards = next < cursor;
    _moveTo(next);
    if (backwards) await _sendBot('Back to the one you skipped.');
    await _dealCurrent();
  }
}
