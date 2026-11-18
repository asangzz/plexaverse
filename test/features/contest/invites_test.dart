import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:plexaverse/core/network/dio_client.dart';
import 'package:plexaverse/core/network/interceptors/error_interceptor.dart';
import 'package:plexaverse/core/platform/image_picking.dart';
import 'package:plexaverse/core/router/zave_routes.dart';
import 'package:plexaverse/features/contest/application/invites_controllers.dart';
import 'package:plexaverse/features/contest/data/contest_repositories.dart';
import 'package:plexaverse/features/contest/domain/contest_repository.dart';
import 'package:plexaverse/features/contest/presentation/pages/contest_invites_page.dart';

/// Saturday's level: one screenshot of LinkedIn's Sent page, paid on upload.
///
/// Three things must hold, each of which the server alone would only catch
/// after a mobile upload of up to eight megabytes:
///   * the part goes up as `image/*` — anything else is refused as
///     INVALID_IMAGE, and Dio's own guess for a name it does not know is
///     `application/octet-stream`;
///   * a file over 8 MB is refused on the phone, before a byte is sent;
///   * the level's state is the PATH's node — there is no invites GET — plus
///     what this page's own upload answered.
void main() {
  setUp(FakeContestWorld.reset);

  group('the upload, through the real network stack', () {
    test(
      'the picked screenshot goes as `screenshot`, typed by its name',
      () async {
        for (final (String name, String type) in <(String, String)>[
          // What the picker writes after re-encoding — a JPEG.
          ('image_picker_7F3A2C.jpg', 'image/jpeg'),
          ('Screenshot 2026-11-14.png', 'image/png'),
          // A name that says nothing is still an image, never octet-stream.
          ('IMG_0042', 'image/jpeg'),
        ]) {
          final _Wire wire = _Wire(200, _ok(_result(80)));
          final ProviderContainer c = _container(
            repository: _api(wire),
            picker: _Picker(PickedImage(bytes: _bytes(1024), name: name)),
          );
          final InvitesActions actions = c.read(
            invitesActionsProvider.notifier,
          );
          await actions.choose();
          await actions.send(lastWeek: false);

          final FormData form = wire.seen.single.data as FormData;
          expect(form.files.single.key, 'screenshot');
          expect(form.files.single.value.filename, name);
          expect(
            form.files.single.value.contentType.toString(),
            type,
            reason: name,
          );
          expect(c.read(invitesActionsProvider).sent?.points, 80);
        }
      },
    );

    test('a screenshot over 8 MB is refused before a byte is sent', () async {
      final _Wire wire = _Wire(200, _ok(_result(80)));
      final ProviderContainer c = _container(
        repository: _api(wire),
        picker: _Picker(
          PickedImage(
            bytes: _bytes(kMaxInvitesScreenshotBytes + 1),
            name: 'big.png',
          ),
        ),
      );
      final InvitesActions actions = c.read(invitesActionsProvider.notifier);
      await actions.choose();
      expect(c.read(invitesActionsProvider).problem, kInvitesTooLargeLine);
      expect(c.read(invitesActionsProvider).screenshot, isNull);

      // Nothing chosen, so nothing goes — however the button is pressed.
      await actions.send(lastWeek: false);
      expect(wire.seen, isEmpty);
    });

    test('exactly 8 MB is the server’s own limit, and is sent', () async {
      final _Wire wire = _Wire(200, _ok(_result(80)));
      final ProviderContainer c = _container(
        repository: _api(wire),
        picker: _Picker(
          PickedImage(
            bytes: _bytes(kMaxInvitesScreenshotBytes),
            name: 'edge.jpg',
          ),
        ),
      );
      final InvitesActions actions = c.read(invitesActionsProvider.notifier);
      await actions.choose();
      await actions.send(lastWeek: false);
      expect(wire.seen, hasLength(1));
    });

    test('a dismissed picker says nothing and keeps what was chosen', () async {
      final _Picker picker = _Picker(
        PickedImage(bytes: _bytes(10), name: 'a.jpg'),
      );
      final ProviderContainer c = _container(
        repository: _Repo(),
        picker: picker,
      );
      final InvitesActions actions = c.read(invitesActionsProvider.notifier);
      await actions.choose();
      picker.next = const ImagePickCancelled();
      await actions.choose();
      expect(c.read(invitesActionsProvider).problem, isNull);
      expect(c.read(invitesActionsProvider).screenshot?.name, 'a.jpg');
    });

    test(
      'a refusal keeps the screenshot and says the server’s sentence',
      () async {
        final _Wire wire = _Wire(503, <String, dynamic>{
          'data': null,
          'error': <String, dynamic>{
            'code': 'STORAGE_UNAVAILABLE',
            'message': 'Screenshots cannot be stored right now.',
          },
          'meta': <String, dynamic>{'version': 'v1'},
        });
        final ProviderContainer c = _container(
          repository: _api(wire),
          picker: _Picker(PickedImage(bytes: _bytes(10), name: 'a.jpg')),
        );
        final InvitesActions actions = c.read(invitesActionsProvider.notifier);
        await actions.choose();
        await actions.send(lastWeek: false);
        final InvitesUpload upload = c.read(invitesActionsProvider);
        expect(upload.error, 'Screenshots cannot be stored right now.');
        expect(upload.screenshot?.name, 'a.jpg');
        expect(upload.sent, isNull);
        expect(upload.busy, isFalse);
      },
    );
  });

  group('the rule, in real numbers', () {
    test('a fake costs what it paid and the same again', () {
      expect(
        invitesFakeRule(80),
        'We check every screenshot. A fake one loses these 80 XP and the same '
        'again as a penalty (−160 XP in all).',
      );
      // Paused scoring paid nothing, so there is no number to promise.
      expect(
        invitesFakeRule(0),
        'We check every screenshot. A fake one loses the XP it earned and the '
        'same again as a penalty.',
      );
    });

    test('last week’s is the one not drawn on a Saturday', () {
      expect(invitesLevelOf(_path(_saturday(PathNodeState.today))), isNotNull);
      expect(
        invitesLevelOf(_path(_saturday(PathNodeState.today)))!.lastWeek,
        isFalse,
      );
      expect(invitesLevelOf(_path(_lastWeekSunday()))!.lastWeek, isTrue);
      expect(invitesLevelOf(const ContestPath()), isNull);
    });
  });

  group('the page', () {
    testWidgets('today: choose, see the rules, send — and the XP shows at '
        'once, then the standing is re-read', (WidgetTester tester) async {
      final _Repo repo = _Repo(path: _path(_saturday(PathNodeState.today)));
      await _pump(
        tester,
        repo,
        _Picker(PickedImage(bytes: _png, name: 'sent.png')),
      );

      expect(find.text('SATURDAY · WEEKLY INVITES'), findsOneWidget);
      expect(find.text('Send this week’s invitations'), findsOneWidget);
      expect(
        find.text('Upload a screenshot of your sent invitations'),
        findsOneWidget,
      );
      expect(find.text(kInvitesPrivacyLine), findsOneWidget);
      expect(find.text(invitesFakeRule(80)), findsOneWidget);

      // Nothing to send yet.
      await tester.ensureVisible(find.text('Send screenshot'));
      await tester.tap(find.text('Send screenshot'));
      await tester.pump();
      expect(repo.uploads, isEmpty);

      await tester.ensureVisible(find.text('Choose a screenshot'));
      await tester.tap(find.text('Choose a screenshot'));
      await tester.pump();
      expect(find.byType(Image), findsOneWidget);

      final int reads = repo.pathReads;
      await tester.ensureVisible(find.text('Send screenshot'));
      await tester.tap(find.text('Send screenshot'));
      await tester.pump();
      await tester.pump();

      expect(repo.uploads, <String>['sent.png']);
      // What THIS upload paid, from its own answer — not the node's promise.
      expect(find.text('Screenshot sent · XP in'), findsOneWidget);
      expect(find.text('+75 XP'), findsOneWidget);
      expect(find.text(invitesFakeRule(75)), findsOneWidget);
      expect(repo.pathReads, greaterThan(reads));
      expect(tester.takeException(), isNull);
    });

    testWidgets('locked behind an earlier level: which one, and the way back', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        _Repo(
          path: _path(
            _saturday(
              PathNodeState.locked,
              detail: 'Unlocks after Post 5 valuable comments',
            ),
          ),
        ),
      );
      expect(
        find.text(
          'Unlocks after Post 5 valuable comments. Levels open one after '
          'another — finish or skip it first.',
        ),
        findsOneWidget,
      );
      expect(find.text('Send screenshot'), findsNothing);
    });

    testWidgets('a Saturday still ahead is not a gate', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        _Repo(
          path: _path(_saturday(PathNodeState.locked), todayIsSaturday: false),
        ),
      );
      expect(
        find.text(
          'The upload opens on Saturday. You can send invites any day before '
          'then.',
        ),
        findsOneWidget,
      );
      expect(find.text('Not open yet'), findsNothing);
    });

    testWidgets('found fake: removed, with the reason and what it cost', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        _Repo(
          path: _path(
            _saturday(
              PathNodeState.revoked,
              detail: 'Removed: Not a Sent page — −160 XP',
              points: 0,
            ),
          ),
        ),
      );
      expect(find.text('Screenshot removed'), findsOneWidget);
      expect(find.text('Removed: Not a Sent page — −160 XP'), findsOneWidget);
      expect(find.text('Send screenshot'), findsNothing);
    });

    testWidgets('done: the XP is in, and the rule is said again', (
      WidgetTester tester,
    ) async {
      await _pump(tester, _Repo(path: _path(_saturday(PathNodeState.done))));
      expect(find.text('Screenshot sent · XP in'), findsOneWidget);
      expect(find.text(invitesFakeRule(80)), findsOneWidget);
      expect(find.text('Choose a screenshot'), findsNothing);
    });

    testWidgets('the old review flow: waiting, and a rejected one sent again', (
      WidgetTester tester,
    ) async {
      await _pump(tester, _Repo(path: _path(_lastWeekSunday())));
      expect(find.text('LAST WEEK · WEEKLY INVITES'), findsOneWidget);
      expect(find.text('Last week’s invitations'), findsOneWidget);
      expect(find.text('Not approved'), findsOneWidget);
      expect(find.text('Rejected: The names are cut off'), findsOneWidget);
      expect(find.text('Send a new screenshot'), findsOneWidget);
    });

    testWidgets('closed: the week’s upload is over', (
      WidgetTester tester,
    ) async {
      await _pump(tester, _Repo(path: _path(_saturday(PathNodeState.missed))));
      expect(
        find.text(
          'This week’s upload has closed. The next one opens on Saturday.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('not an entrant: no upload at all', (
      WidgetTester tester,
    ) async {
      await _pump(
        tester,
        _Repo(path: const ContestPath(status: ContestPathStatus.notJoined)),
      );
      expect(
        find.text(
          'This task is for contest entrants. Join on the contest page; it is '
          'free.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('the mock flavor’s Wednesday renders at the narrowest phone', (
      WidgetTester tester,
    ) async {
      await _pump(tester, FakeContestRepository(latency: Duration.zero));
      expect(find.text('Send this week’s invitations'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}

// ── Fixtures ────────────────────────────────────────────────────────────────

Uint8List _bytes(int n) => Uint8List(n);

/// A real 1×1 PNG, so the preview decodes.
final Uint8List _png = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
);

PathNode _invitesNode(
  String day,
  PathNodeState state, {
  String? detail,
  int points = 80,
}) => PathNode(
  id: '$day:weekly_invites',
  kind: PathNodeKind.weeklyInvites,
  state: state,
  title: 'Weekly invites',
  points: points,
  href: state == PathNodeState.locked ? null : '/contest/invites',
  detail: detail,
);

/// The week's Saturday, holding the invites level.
PathDay _saturday(PathNodeState state, {String? detail, int points = 80}) =>
    PathDay(
      dayNumber: 14,
      dayKey: '2026-11-14',
      weekday: 6,
      isToday: true,
      nodes: <PathNode>[
        _invitesNode('2026-11-14', state, detail: detail, points: points),
      ],
    );

/// A Sunday re-sending last week's rejected legacy screenshot.
PathDay _lastWeekSunday() => PathDay(
  dayNumber: 15,
  dayKey: '2026-11-15',
  weekday: 0,
  isToday: true,
  nodes: <PathNode>[
    _invitesNode(
      '2026-11-15',
      PathNodeState.rejected,
      detail: 'Rejected: The names are cut off',
    ),
  ],
);

ContestPath _path(PathDay day, {bool todayIsSaturday = true}) => ContestPath(
  status: ContestPathStatus.running,
  dayNumber: day.dayNumber,
  weekNumber: 2,
  days: <PathDay>[
    if (!todayIsSaturday)
      const PathDay(
        dayNumber: 11,
        dayKey: '2026-11-11',
        weekday: 3,
        isToday: true,
      ),
    day.copyWith(isToday: todayIsSaturday),
  ],
);

Map<String, dynamic> _result(int points) => <String, dynamic>{
  'result': <String, dynamic>{
    'taskId': 'task-1',
    'status': 'done',
    'pointsApplied': points,
    'replaced': false,
  },
};

Map<String, dynamic> _ok(Object? data) => <String, dynamic>{
  'data': data,
  'error': null,
  'meta': <String, dynamic>{'version': 'v1'},
};

/// Answers every request with one canned envelope, and keeps what was sent.
class _Wire implements HttpClientAdapter {
  _Wire(this.status, this.body);

  final int status;
  final Object? body;
  final List<RequestOptions> seen = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    seen.add(options);
    return ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: <String, List<String>>{
        Headers.contentTypeHeader: <String>[Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

ApiContestRepository _api(_Wire wire) {
  final Dio dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
    ..httpClientAdapter = wire
    ..interceptors.add(ErrorInterceptor());
  return ApiContestRepository(DioClient(dio));
}

class _Picker implements ImagePickingService {
  _Picker(this.next);

  ImagePickResult next;

  @override
  Future<ImagePickResult> pick(ImageSourceKind source) async => next;

  @override
  Future<List<PickedImage>> pickMany({required int limit}) async =>
      const <PickedImage>[];
}

/// The mock flavor's contest, with the path this test draws and a record of
/// what reached the server.
class _Repo extends FakeContestRepository {
  _Repo({this.path = const ContestPath()}) : super(latency: Duration.zero);

  final ContestPath path;
  final List<String> uploads = <String>[];
  int pathReads = 0;

  @override
  Future<ContestPath> fetchPath() async {
    pathReads++;
    return path;
  }

  @override
  Future<InvitesSubmitResult> submitInvites(
    Uint8List bytes,
    String filename,
  ) async {
    uploads.add(filename);
    return const InvitesSubmitResult(taskId: 'task-1', pointsApplied: 75);
  }
}

ProviderContainer _container({
  required ContestRepository repository,
  required ImagePickingService picker,
}) {
  final ProviderContainer c = ProviderContainer(
    overrides: <Override>[
      contestRepositoryProvider.overrideWithValue(repository),
      imagePickingProvider.overrideWithValue(picker),
    ],
  );
  addTearDown(c.dispose);
  // Auto-dispose: held open for the length of the test, as the page does.
  c.listen(invitesActionsProvider, (_, _) {});
  return c;
}

Future<void> _pump(
  WidgetTester tester,
  ContestRepository repository, [
  ImagePickingService? picker,
]) async {
  tester.view.physicalSize = const Size(375, 667) * 3;
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(path: '/', builder: (_, _) => const ContestInvitesPage()),
      GoRoute(path: ZaveRoutes.contest, builder: (_, _) => const Text('path')),
      GoRoute(
        path: ZaveRoutes.connections,
        builder: (_, _) => const Text('connections'),
      ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        contestRepositoryProvider.overrideWithValue(repository),
        if (picker != null) imagePickingProvider.overrideWithValue(picker),
      ],
      child: MaterialApp.router(routerConfig: router),
    ),
  );
  await tester.pump();
  await tester.pump();
}
