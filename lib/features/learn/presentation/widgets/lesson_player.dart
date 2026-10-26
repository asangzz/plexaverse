import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/platform/link_opening.dart';
import '../../../../core/ui/app_icons.dart';
import '../../../../core/ui/zave/zave_kit.dart';
import '../../application/learn_controllers.dart';
import '../../domain/learn_unit.dart';
import 'exercise_views.dart';
import 'level_node.dart';

/// One level, climbed.
///
/// ## The whole level is one page and one submission
///
/// Not a carousel. Every exercise of a level is visible at once and the
/// Check button grades all of them together, because the server grades them
/// together: a level is all-or-nothing, and a one-question-at-a-time flow
/// would imply each answer banks on its own when none of them do.
///
/// ## Nothing here decides whether an answer is right
///
/// Check enables on a purely mechanical rule — every box non-empty after
/// trimming — and the verdicts come back from the server. See the note on
/// [Verdict] in `exercise_views.dart` for why that line must not move.
class LessonPlayer extends ConsumerStatefulWidget {
  const LessonPlayer({
    required this.unit,
    required this.week,
    required this.day,
    required this.onClose,
    super.key,
  });

  final LearnUnit unit;
  final int week;
  final int day;
  final VoidCallback onClose;

  @override
  ConsumerState<LessonPlayer> createState() => _LessonPlayerState();
}

class _LessonPlayerState extends ConsumerState<LessonPlayer> {
  /// Which level is on screen.
  ///
  /// Starts at the server's `nextLevelIndex` rather than at whatever node was
  /// tapped: the path draws placeholder nodes before a ladder exists, so the
  /// tap can be ahead of where the user actually is. The real ladder is the
  /// authority.
  late int _index = widget.unit.nextLevelIndex.clamp(
    0,
    widget.unit.levels.isEmpty ? 0 : widget.unit.levels.length - 1,
  );

  /// Typed answers, by exercise id. Controllers so the text survives a
  /// rebuild — a verdict arriving must not wipe what the user wrote.
  final Map<String, TextEditingController> _controllers =
      <String, TextEditingController>{};

  /// Tapped answers, by exercise id.
  final Map<String, String> _picked = <String, String>{};

  @override
  void dispose() {
    for (final TextEditingController c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  LearnLevel? get _level => _index >= 0 && _index < widget.unit.levels.length
      ? widget.unit.levels[_index]
      : null;

  TextEditingController _controllerFor(String id) =>
      _controllers.putIfAbsent(id, TextEditingController.new);

  String _answerFor(Exercise e) => e.isChoice || e.isGap
      ? (_picked[e.id] ?? '')
      : (_controllers[e.id]?.text ?? '');

  /// The only local judgement allowed: is there something in every box.
  bool get _canCheck {
    final LearnLevel? level = _level;
    if (level == null) return false;
    final List<Exercise> items = level.renderable;
    if (items.isEmpty) return false;
    return items.every((Exercise e) => _answerFor(e).trim().isNotEmpty);
  }

  void _resetAnswers() {
    _picked.clear();
    for (final TextEditingController c in _controllers.values) {
      c.clear();
    }
  }

  Future<void> _check() async {
    final LearnLevel? level = _level;
    if (level == null) return;
    final LearnActions actions = ref.read(
      learnActionsProvider(widget.week, widget.day).notifier,
    );
    await actions.submit(
      unitId: widget.unit.id,
      levelIndex: level.index,
      answers: level.renderable
          .map(
            (Exercise e) =>
                LevelAnswer(exerciseId: e.id, value: _answerFor(e).trim()),
          )
          .toList(),
    );
    if (mounted) setState(() {});
  }

  void _advance() {
    final LearnActions actions = ref.read(
      learnActionsProvider(widget.week, widget.day).notifier,
    );
    actions.clearResults();
    _resetAnswers();
    if (_index + 1 >= widget.unit.levels.length) {
      widget.onClose();
      return;
    }
    setState(() => _index += 1);
  }

  @override
  Widget build(BuildContext context) {
    final LearnLevel? level = _level;
    if (level == null) {
      return const ZaveEmptyState(
        title: 'Nothing to climb here',
        body: 'This day has no levels yet.',
      );
    }

    final LearnBusy busy = ref.watch(
      learnActionsProvider(widget.week, widget.day),
    );
    final Map<String, ExerciseResult> verdicts = <String, ExerciseResult>{
      for (final ExerciseResult r in busy.results) r.exerciseId: r,
    };
    final bool graded = verdicts.isNotEmpty;
    final bool passed = level.isComplete;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _Header(level: level, total: widget.unit.levels.length),
        SizedBox(height: ZaveSpace.lg),

        if (level.teach case final TeachBlock teach) ...<Widget>[
          _TeachCard(teach: teach),
          SizedBox(height: ZaveSpace.xl),
        ],

        if (level.kind.isAction)
          _ActionLevel(
            unit: widget.unit,
            level: level,
            week: widget.week,
            day: widget.day,
            onDone: _advance,
          )
        else ...<Widget>[
          for (final Exercise e in level.renderable) ...<Widget>[
            ExerciseView(
              exercise: e,
              value: _answerFor(e),
              controller: e.isChoice || e.isGap ? null : _controllerFor(e.id),
              verdict: verdicts[e.id],
              onChanged: (String v) => setState(() {
                if (e.isChoice || e.isGap) _picked[e.id] = v;
              }),
            ),
            SizedBox(height: ZaveSpace.xl),
          ],

          if (busy.error case final String message) ...<Widget>[
            Text(
              message,
              style: ZaveType.caption.copyWith(color: ZaveColors.amber),
            ),
            SizedBox(height: ZaveSpace.md),
          ],

          if (passed)
            ZaveButton.primary(
              label: _index + 1 >= widget.unit.levels.length
                  ? 'Finish'
                  : 'Continue',
              expand: true,
              trailing: const Icon(AppIcons.forward),
              onPressed: _advance,
            )
          else if (graded)
            // Wrong answers bank nothing, so the level is still open and the
            // honest label is "try again", not "continue".
            ZaveButton.primary(
              label: 'Try again',
              expand: true,
              onPressed: () {
                ref
                    .read(
                      learnActionsProvider(widget.week, widget.day).notifier,
                    )
                    .clearResults();
                setState(_resetAnswers);
              },
            )
          else
            ZaveButton.primary(
              label: 'Check',
              expand: true,
              busy: busy.work == LearnWork.submitting,
              onPressed: _canCheck && !busy.isBusy ? _check : null,
            ),
        ],
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.level, required this.total});

  final LearnLevel level;
  final int total;

  @override
  Widget build(BuildContext context) => Row(
    children: <Widget>[
      Icon(iconForLevel(level.kind), size: 18, color: ZaveColors.violet),
      SizedBox(width: ZaveSpace.sm),
      Expanded(child: Text(level.title, style: ZaveType.h3)),
      Text('${level.index + 1} of $total', style: ZaveType.caption),
    ],
  );
}

/// The rule, before any question is asked.
class _TeachCard extends StatelessWidget {
  const _TeachCard({required this.teach});

  final TeachBlock teach;

  @override
  Widget build(BuildContext context) => ZaveCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (teach.kind case final String kind when kind.isNotEmpty) ...<Widget>[
          Text(kind.replaceAll('_', ' ').toUpperCase(), style: ZaveType.kicker),
          SizedBox(height: ZaveSpace.md),
        ],
        Text(teach.rule, style: ZaveType.h3),
        SizedBox(height: ZaveSpace.sm),
        Text(teach.why, style: ZaveType.bodyMuted),
        SizedBox(height: ZaveSpace.lg),
        _BeforeAfter(label: 'WEAK', body: teach.before, tint: ZaveColors.ink45),
        SizedBox(height: ZaveSpace.sm),
        _BeforeAfter(
          label: 'STRONG',
          body: teach.after,
          tint: ZaveColors.green,
        ),
      ],
    ),
  );
}

class _BeforeAfter extends StatelessWidget {
  const _BeforeAfter({
    required this.label,
    required this.body,
    required this.tint,
  });

  final String label;
  final String body;
  final Color tint;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: ZaveSpace.rowPad,
    decoration: ZaveSurface.row,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: ZaveType.kicker.copyWith(color: tint)),
        SizedBox(height: ZaveSpace.xs),
        Text(body, style: ZaveType.body),
      ],
    ),
  );
}

/// The three levels finished by doing rather than answering.
///
/// They share a shape — an explanation, one control, and a done state — but
/// almost nothing else, so each is its own branch rather than a parameterised
/// card that would have to apologise for all three.
class _ActionLevel extends ConsumerStatefulWidget {
  const _ActionLevel({
    required this.unit,
    required this.level,
    required this.week,
    required this.day,
    required this.onDone,
  });

  final LearnUnit unit;
  final LearnLevel level;
  final int week;
  final int day;
  final VoidCallback onDone;

  @override
  ConsumerState<_ActionLevel> createState() => _ActionLevelState();
}

class _ActionLevelState extends ConsumerState<_ActionLevel>
    with WidgetsBindingObserver {
  /// When the app went to the background, so a resume can tell a trip to
  /// ChatGPT apart from a notification shade being pulled down.
  DateTime? _leftAt;

  @override
  void initState() {
    super.initState();
    if (widget.level.kind == LevelKind.visual) {
      WidgetsBinding.instance.addObserver(this);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// The mobile answer to the web's window-focus re-check.
  ///
  /// Scoped hard on purpose. Android and iOS deliver `resumed` for the
  /// notification shade, an app-switcher peek and every permission dialog —
  /// re-checking on all of them would turn an idle screen into a poller
  /// against a 60/min bucket. So: only on the visual level, only after a real
  /// absence, and never while something is already in flight.
  ///
  /// The manual button below stays the primary path. If this proves noisy it
  /// can be deleted and the level is still perfectly usable.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _leftAt = DateTime.now();
      return;
    }
    if (state != AppLifecycleState.resumed) return;
    final DateTime? left = _leftAt;
    _leftAt = null;
    if (left == null) return;
    if (DateTime.now().difference(left) < const Duration(seconds: 3)) return;
    if (widget.level.isComplete) return;
    if (ref.read(learnActionsProvider(widget.week, widget.day)).isBusy) return;
    _checkVisual();
  }

  LearnActions get _actions =>
      ref.read(learnActionsProvider(widget.week, widget.day).notifier);

  Future<void> _checkVisual() => _actions.checkVisual(widget.unit.id);

  Future<void> _openChatGpt() async {
    // externalApplication, so the OS hands this to the installed ChatGPT app
    // or the system browser where the session already lives. An in-app
    // WebView would land the user in a signed-out chat with no connector and
    // no way to tell why the level will not complete.
    final LinkOpenResult result = await ref
        .read(linkOpeningProvider)
        .open(_posterPrompt());
    if (!mounted) return;
    if (result is LinkOpenFailed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open ChatGPT on this device.')),
      );
    }
  }

  /// The hand-off carries an INSTRUCTION, not the post.
  ///
  /// The web's `lib/chatgpt-handoff.ts` spells out why the detail must not
  /// ride in the URL: the real prompt is several thousand characters and gets
  /// truncated, it is all the user's own material and a URL lands in history,
  /// and it goes stale the moment it is built. ChatGPT reads the day itself
  /// through the connector.
  String _posterPrompt() {
    final String ask = Uri.encodeComponent(
      'Make the poster image for my Plexaverse post for '
      '${widget.unit.title} (week ${widget.unit.weekNumber}, '
      'day ${widget.unit.dayIndex + 1}). The post is already written — '
      'read it from the planner and design the image for it. '
      'Do not rewrite the post.',
    );
    return 'https://chatgpt.com/?q=$ask';
  }

  @override
  Widget build(BuildContext context) {
    final LearnBusy busy = ref.watch(
      learnActionsProvider(widget.week, widget.day),
    );
    final bool done = widget.level.isComplete;

    return switch (widget.level.kind) {
      LevelKind.draft => _draft(busy, done),
      LevelKind.visual => _visual(busy, done),
      _ => _review(busy, done),
    };
  }

  Widget _draft(LearnBusy busy, bool done) {
    if (done && (widget.unit.postContent?.isNotEmpty ?? false)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _Written(label: 'YOUR POST', body: widget.unit.postContent!),
          SizedBox(height: ZaveSpace.xl),
          _continue(),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Your opening, your account of what happened and your closing ask '
          'are all written. This puts them together into the post — in your '
          'voice, using your words.',
          style: ZaveType.bodyMuted,
        ),
        SizedBox(height: ZaveSpace.lg),
        if (busy.error case final String message) ...<Widget>[
          Text(
            message,
            style: ZaveType.caption.copyWith(color: ZaveColors.amber),
          ),
          SizedBox(height: ZaveSpace.md),
        ],
        ZaveButton.primary(
          label: busy.isDrafting ? 'Writing your post…' : 'Write my post',
          expand: true,
          busy: busy.isDrafting,
          // Enablement comes from the LEVEL, not from a local flag. A 120s
          // call on a phone will routinely time out while the server
          // finishes and bills; a local flag would re-offer the button and
          // sell the user a second post.
          onPressed: busy.isBusy || done
              ? null
              : () => _actions.draft(widget.unit.id),
        ),
        if (busy.isDrafting) ...<Widget>[
          SizedBox(height: ZaveSpace.md),
          Text(
            'This takes about half a minute. Keep this screen open.',
            textAlign: TextAlign.center,
            style: ZaveType.caption.copyWith(color: ZaveColors.ink35),
          ),
        ],
      ],
    );
  }

  Widget _visual(LearnBusy busy, bool done) {
    if (done) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (widget.unit.imageUrl case final String url when url.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(ZaveRadius.cardSm),
              child: AspectRatio(aspectRatio: 1, child: ZaveImage(source: url)),
            ),
          SizedBox(height: ZaveSpace.xl),
          _continue(),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'The poster is made in ChatGPT, on your own quota, and written back '
          'through the Plexaverse connector. Open ChatGPT, ask for it, then '
          'come back and check.',
          style: ZaveType.bodyMuted,
        ),
        SizedBox(height: ZaveSpace.md),
        // Said plainly rather than discovered. Without the connector this
        // level cannot complete, and because a day is locked until the one
        // before it is finished, that stalls the whole week. A user who
        // cannot connect it needs to know now, not on Thursday.
        Container(
          width: double.infinity,
          padding: ZaveSpace.rowPad,
          decoration: ZaveSurface.row,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Icon(AppIcons.info, size: 16, color: ZaveColors.amber),
              SizedBox(width: ZaveSpace.sm),
              Expanded(
                child: Text(
                  'The connector is set up in Plexaverse on the web. Without '
                  'it ChatGPT cannot write the poster back, and this level '
                  'will not complete.',
                  style: ZaveType.caption.copyWith(color: ZaveColors.ink62),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: ZaveSpace.lg),
        if (busy.error case final String message) ...<Widget>[
          Text(
            message,
            style: ZaveType.caption.copyWith(color: ZaveColors.amber),
          ),
          SizedBox(height: ZaveSpace.md),
        ],
        ZaveButton.primary(
          label: 'Open ChatGPT',
          icon: const Icon(AppIcons.openExternal),
          expand: true,
          onPressed: busy.isBusy ? null : _openChatGpt,
        ),
        SizedBox(height: ZaveSpace.md),
        ZaveButton(
          label: "I've made it — check now",
          expand: true,
          busy: busy.work == LearnWork.checkingVisual,
          onPressed: busy.isBusy ? null : _checkVisual,
        ),
      ],
    );
  }

  Widget _review(LearnBusy busy, bool done) {
    if (done) return _continue();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (widget.unit.postContent case final String body
            when body.isNotEmpty) ...<Widget>[
          _Written(label: 'WHAT YOU MADE', body: body),
          SizedBox(height: ZaveSpace.xl),
        ],
        Text(
          'Read it once more. The words are yours — you wrote them climbing '
          'this day.',
          style: ZaveType.bodyMuted,
        ),
        SizedBox(height: ZaveSpace.lg),
        if (busy.error case final String message) ...<Widget>[
          Text(
            message,
            style: ZaveType.caption.copyWith(color: ZaveColors.amber),
          ),
          SizedBox(height: ZaveSpace.md),
        ],
        ZaveButton.primary(
          label: "I've read it",
          expand: true,
          busy: busy.work == LearnWork.reviewing,
          onPressed: busy.isBusy ? null : () => _actions.review(widget.unit.id),
        ),
      ],
    );
  }

  Widget _continue() => ZaveButton.primary(
    label: 'Continue',
    expand: true,
    trailing: const Icon(AppIcons.forward),
    onPressed: widget.onDone,
  );
}

/// A finished piece of writing, read-only.
class _Written extends StatelessWidget {
  const _Written({required this.label, required this.body});

  final String label;
  final String body;

  @override
  Widget build(BuildContext context) => ZaveCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: ZaveType.kicker),
        SizedBox(height: ZaveSpace.md),
        Text(body, style: ZaveType.body),
      ],
    ),
  );
}
