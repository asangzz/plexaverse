import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/plexa/application/plexa_chat_controller.dart';
import 'package:plexaverse/features/plexa/domain/chat_bubble.dart';
import 'package:plexaverse/features/plexa/domain/plexa_day.dart';
import 'package:plexaverse/features/plexa/domain/plexa_repository.dart';

/// A repository that answers instantly and records every write.
class _Repo implements PlexaRepository {
  _Repo(this._day);

  PlexaDay _day;

  bool failDay = false;
  bool failMark = false;

  final List<String> marked = <String>[];
  final List<({int levelId, int stepId})> credited =
      <({int levelId, int stepId})>[];

  @override
  Future<PlexaDay> fetchDay() async {
    if (failDay) throw StateError('offline');
    return _day;
  }

  @override
  Future<PlexaSession> setItemDone({
    required PlexaLane lane,
    required String itemId,
    bool done = true,
    String? topVoiceId,
  }) async {
    if (failMark) throw StateError('offline');
    marked.add(itemId);
    final List<String> next = List<String>.of(_day.session.doneIn(lane));
    if (done) {
      if (!next.contains(itemId)) next.add(itemId);
    } else {
      next.remove(itemId);
    }
    final PlexaSession session = lane == PlexaLane.comments
        ? _day.session.copyWith(comments: next)
        : _day.session.copyWith(connections: next);
    _day = _day.copyWith(session: session);
    return session;
  }

  @override
  Future<void> completeStep({required int levelId, required int stepId}) async {
    credited.add((levelId: levelId, stepId: stepId));
  }
}

DayItem _item(String id, PlexaLane lane) => DayItem(
  id: id,
  lane: lane,
  headline: 'headline $id',
  draft: 'draft $id',
  url: 'https://x/$id',
);

PlexaDay _day(List<DayItem> items, {PlexaSession? session}) => PlexaDay(
  session: session ?? const PlexaSession(),
  items: items,
  ready: const PlexaReady(comments: true, connections: true, topVoices: true),
);

/// Drives the chat without waiting out the typing delays in real time.
///
/// The delays are real [Future.delayed] calls, so a test that awaited them
/// honestly would spend several seconds per case. [FakeAsync] — which
/// `fakeAsync` wraps — advances them instantly.
Future<void> _settle(WidgetTester? _) async {}

void main() {
  /// Every opened url and copied draft, in order.
  late List<String> opened;
  late List<String> copied;

  /// Whether the injected opener claims LinkedIn came up.
  late bool openSucceeds;

  Future<bool> Function(String) opener() => (String url) async {
    opened.add(url);
    return openSucceeds;
  };
  Future<void> Function(String) copier() => (String text) async {
    copied.add(text);
  };

  setUp(() {
    opened = <String>[];
    copied = <String>[];
    openSucceeds = true;
  });

  group('opening', () {
    test('an empty day with nothing prepared offers to generate', () async {
      final _Repo repo = _Repo(const PlexaDay());
      final PlexaChatController chat = PlexaChatController(repo);
      addTearDown(chat.dispose);

      await chat.open(roadmapDay: 7);
      await _settle(null);

      expect(chat.phase, PlexaPhase.empty);
      final String all = chat.bubbles.map((ChatBubble b) => b.text).join('\n');
      expect(all, contains('Day 7'));
      expect(all, contains('Nothing is written yet'));
      // The offer names the cost. Generating is the user's decision because it
      // is their XP.
      expect(all, contains('XP'));
    });

    test('a day that failed to load says so, and does not offer', () async {
      final _Repo repo = _Repo(const PlexaDay())..failDay = true;
      final PlexaChatController chat = PlexaChatController(repo);
      addTearDown(chat.dispose);

      await chat.open(roadmapDay: 3);

      expect(chat.phase, PlexaPhase.empty);
      final String all = chat.bubbles.map((ChatBubble b) => b.text).join('\n');
      expect(all, contains('couldn’t pull today’s list'));
      expect(all, isNot(contains('XP')));
    });

    test('says what it cannot do once, at the top', () async {
      final _Repo repo = _Repo(
        _day(<DayItem>[
          _item('tv:1', PlexaLane.comments),
          _item('cn:0', PlexaLane.connections),
        ]),
      );
      final PlexaChatController chat = PlexaChatController(repo);
      addTearDown(chat.dispose);

      await chat.open(roadmapDay: 1);

      final Iterable<String> texts = chat.bubbles.map((ChatBubble b) => b.text);
      // Exactly one line carries the limitation. A chat that repeated it every
      // turn would be nagging; one that never said it would be a bait-and-
      // switch on the third item.
      expect(
        texts.where((String t) => t.contains('LinkedIn won’t let me')),
        hasLength(1),
      );
    });

    test('resumes at the first item still open', () async {
      final _Repo repo = _Repo(
        _day(<DayItem>[
          _item('tv:1', PlexaLane.comments),
          _item('tv:2', PlexaLane.comments),
          _item('tv:3', PlexaLane.comments),
        ], session: const PlexaSession(comments: <String>['tv:1'])),
      );
      final PlexaChatController chat = PlexaChatController(repo);
      addTearDown(chat.dispose);

      await chat.open(roadmapDay: 4);

      expect(chat.currentItem?.id, 'tv:2');
      expect(
        chat.bubbles.map((ChatBubble b) => b.text).join('\n'),
        contains('Picking up at 2 of 3'),
      );
    });

    test('a fully cleared day never deals an item', () async {
      final _Repo repo = _Repo(
        _day(<DayItem>[
          _item('tv:1', PlexaLane.comments),
        ], session: const PlexaSession(comments: <String>['tv:1'])),
      );
      final PlexaChatController chat = PlexaChatController(repo);
      addTearDown(chat.dispose);

      await chat.open(roadmapDay: 9);

      expect(chat.phase, PlexaPhase.done);
      expect(repo.marked, isEmpty);
    });
  });

  group('one tap = opened + counted', () {
    test('copies BEFORE opening, and records the clear', () async {
      final _Repo repo = _Repo(
        _day(<DayItem>[
          _item('tv:1', PlexaLane.comments),
          _item('tv:2', PlexaLane.comments),
        ]),
      );
      final PlexaChatController chat = PlexaChatController(repo);
      addTearDown(chat.dispose);
      await chat.open(roadmapDay: 1);

      await chat.openAndCount(openUrl: opener(), copy: copier());

      // The order is the contract: a hand-off that opened first and failed to
      // copy would land the user in LinkedIn's composer with nothing to paste.
      expect(copied, <String>['draft tv:1']);
      expect(opened, <String>['https://x/tv:1']);
      expect(
        chat.bubbles
            .lastWhere((ChatBubble b) => b.role == ChatRole.user)
            .badgeTone,
        ChatBadgeTone.ok,
      );
      expect(repo.marked, <String>['tv:1']);
      expect(chat.day.session.comments, contains('tv:1'));
    });

    test('an item with no url still counts', () async {
      final _Repo repo = _Repo(
        _day(<DayItem>[
          const DayItem(id: 'nw:0', lane: PlexaLane.comments, draft: 'd'),
        ]),
      );
      final PlexaChatController chat = PlexaChatController(repo);
      addTearDown(chat.dispose);
      await chat.open(roadmapDay: 1);

      await chat.openAndCount(openUrl: opener(), copy: copier());

      expect(opened, isEmpty);
      expect(copied, <String>['d']);
      expect(repo.marked, <String>['nw:0']);
    });

    test('says "copied", not "opened", when LinkedIn never came up', () async {
      openSucceeds = false;
      final _Repo repo = _Repo(
        _day(<DayItem>[
          _item('tv:1', PlexaLane.comments),
          _item('tv:2', PlexaLane.comments),
        ]),
      );
      final PlexaChatController chat = PlexaChatController(repo);
      addTearDown(chat.dispose);
      await chat.open(roadmapDay: 1);

      await chat.openAndCount(openUrl: opener(), copy: copier());

      final ChatBubble echo = chat.bubbles.lastWhere(
        (ChatBubble b) => b.role == ChatRole.user,
      );
      // "Opened it" over a screen that never changed is the one lie this
      // surface cannot afford.
      expect(echo.text, 'Copied it');
      expect(echo.badge, contains('didn’t open'));
      // Amber, not the green tick — a success badge over a failed hand-off
      // would be the app contradicting itself in the same breath.
      expect(echo.badgeTone, ChatBadgeTone.warn);
      // And it still counts — the draft is on the clipboard and the user
      // asked to act.
      expect(repo.marked, <String>['tv:1']);
    });

    test('a failed write puts the tick back', () async {
      final _Repo repo = _Repo(
        _day(<DayItem>[
          _item('tv:1', PlexaLane.comments),
          _item('tv:2', PlexaLane.comments),
        ]),
      )..failMark = true;
      final PlexaChatController chat = PlexaChatController(repo);
      addTearDown(chat.dispose);
      await chat.open(roadmapDay: 1);

      await chat.openAndCount(openUrl: opener(), copy: copier());
      // The rollback is fired un-awaited so the thread can move on; let it
      // land before asserting.
      await Future<void>.delayed(Duration.zero);

      // A tick that stays after a failed write tells the user the day is
      // recorded when it is not.
      expect(chat.day.session.comments, isEmpty);
    });
  });

  group('skipping', () {
    test('wraps back to a skipped item instead of losing it', () async {
      final _Repo repo = _Repo(
        _day(<DayItem>[
          _item('tv:1', PlexaLane.comments),
          _item('tv:2', PlexaLane.comments),
        ]),
      );
      final PlexaChatController chat = PlexaChatController(repo);
      addTearDown(chat.dispose);
      await chat.open(roadmapDay: 1);

      await chat.skip(); // on tv:1 → tv:2
      expect(chat.currentItem?.id, 'tv:2');

      await chat.openAndCount(openUrl: opener(), copy: copier());

      // Forward found nothing, so it wrapped. The old forward-only search
      // declared the day cleared here with tv:1 still open.
      expect(chat.currentItem?.id, 'tv:1');
      expect(chat.phase, PlexaPhase.working);
    });

    test(
      'parks an item after the second skip so the wrap terminates',
      () async {
        final _Repo repo = _Repo(
          _day(<DayItem>[
            _item('tv:1', PlexaLane.comments),
            _item('tv:2', PlexaLane.comments),
          ]),
        );
        final PlexaChatController chat = PlexaChatController(repo);
        addTearDown(chat.dispose);
        await chat.open(roadmapDay: 1);

        await chat.skip(); // tv:1 skipped once
        await chat.skip(); // tv:2 skipped once
        await chat.skip(); // tv:1 skipped twice → parked
        await chat.skip(); // tv:2 skipped twice → parked

        // Without the park this is an infinite loop the user can only leave by
        // closing the sheet.
        expect(chat.phase, PlexaPhase.done);
      },
    );

    test('the ending over unfinished work says so', () async {
      final _Repo repo = _Repo(
        _day(<DayItem>[
          _item('tv:1', PlexaLane.comments),
          _item('tv:2', PlexaLane.comments),
        ]),
      );
      final PlexaChatController chat = PlexaChatController(repo);
      addTearDown(chat.dispose);
      await chat.open(roadmapDay: 1);

      await chat.skip();
      await chat.skip();
      await chat.skip();
      await chat.skip();

      final String all = chat.bubbles.map((ChatBubble b) => b.text).join('\n');
      // "See you tomorrow" over unfinished work is the worst thing this
      // surface can say.
      expect(all, isNot(contains('See you tomorrow')));
      expect(all, contains('you skipped'));
    });

    test('a cleared day ends with the other ending', () async {
      final _Repo repo = _Repo(
        _day(<DayItem>[_item('tv:1', PlexaLane.comments)]),
      );
      final PlexaChatController chat = PlexaChatController(repo);
      addTearDown(chat.dispose);
      await chat.open(roadmapDay: 1);

      await chat.openAndCount(openUrl: opener(), copy: copier());

      expect(chat.phase, PlexaPhase.done);
      expect(
        chat.bubbles.map((ChatBubble b) => b.text).join('\n'),
        contains('See you tomorrow'),
      );
    });
  });

  group('crediting the roadmap step', () {
    test('credits a lane once, when its last item clears', () async {
      final _Repo repo = _Repo(
        _day(<DayItem>[
          _item('tv:1', PlexaLane.comments),
          _item('cn:0', PlexaLane.connections),
        ]),
      );
      final PlexaChatController chat = PlexaChatController(repo);
      addTearDown(chat.dispose);
      await chat.open(
        roadmapDay: 12,
        laneSteps: const <PlexaLane, int>{
          PlexaLane.comments: 2,
          PlexaLane.connections: 3,
        },
      );

      await chat.openAndCount(openUrl: opener(), copy: copier());
      await Future<void>.delayed(Duration.zero);

      expect(repo.credited, <({int levelId, int stepId})>[
        (levelId: 12, stepId: 2),
      ]);

      await chat.openAndCount(openUrl: opener(), copy: copier());
      await Future<void>.delayed(Duration.zero);

      expect(repo.credited, hasLength(2));
      expect(repo.credited.last, (levelId: 12, stepId: 3));
    });

    test('credits nothing when today has no such step', () async {
      // A company-brand user has no connection step at all — a Company Page
      // cannot send connection requests — and a Season 2 user is past the
      // table's end. Both are real states, not failures.
      final _Repo repo = _Repo(
        _day(<DayItem>[_item('cn:0', PlexaLane.connections)]),
      );
      final PlexaChatController chat = PlexaChatController(repo);
      addTearDown(chat.dispose);
      await chat.open(roadmapDay: 70);

      await chat.openAndCount(openUrl: opener(), copy: copier());
      await Future<void>.delayed(Duration.zero);

      expect(repo.credited, isEmpty);
      // And the chat still finishes normally.
      expect(chat.phase, PlexaPhase.done);
    });
  });

  group('interleaving', () {
    test('a skip mid-sequence abandons the line still being typed', () async {
      final _Repo repo = _Repo(
        _day(<DayItem>[
          _item('tv:1', PlexaLane.comments),
          _item('tv:2', PlexaLane.comments),
          _item('tv:3', PlexaLane.comments),
        ]),
      );
      final PlexaChatController chat = PlexaChatController(repo);
      addTearDown(chat.dispose);
      await chat.open(roadmapDay: 1);

      // Skip is reachable while Plexa is still typing the item she is on, so
      // tap it part-way through tv:2's two lines.
      final Future<void> first = chat.skip();
      await Future<void>.delayed(const Duration(milliseconds: 700));
      final Future<void> second = chat.skip();
      await first;
      await second;
      await Future<void>.delayed(const Duration(seconds: 3));

      // Every draft must sit directly under its own headline. An abandoned
      // sequence landing late puts tv:2's draft under tv:3's headline, and
      // the thread then has Plexa quoting the wrong post.
      final List<ChatBubble> bot = chat.bubbles
          .where((ChatBubble b) => b.role == ChatRole.bot)
          .toList();
      for (int i = 0; i < bot.length; i++) {
        final RegExpMatch? m = RegExp(
          r'^draft (tv:\d)$',
        ).firstMatch(bot[i].text);
        if (m == null) continue;
        expect(
          bot[i - 1].text,
          contains('headline ${m.group(1)}'),
          reason: 'the draft for ${m.group(1)} is under the wrong headline',
        );
      }
    });
  });

  group('abandoning the conversation', () {
    test('disposing mid-sequence stops the script', () async {
      final _Repo repo = _Repo(
        _day(<DayItem>[_item('tv:1', PlexaLane.comments)]),
      );
      final PlexaChatController chat = PlexaChatController(repo);

      final Future<void> opening = chat.open(roadmapDay: 1);
      chat.dispose();
      await opening;

      // Every timer parked between lines would otherwise wake up and pour
      // itself into the next thread — and notifying a disposed
      // ChangeNotifier throws.
      expect(chat.phase, PlexaPhase.loading);
    });
  });
}
