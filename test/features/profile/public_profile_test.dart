import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/core/config/env.dart';
import 'package:plexaverse/core/network/dio_client.dart';
import 'package:plexaverse/core/network/interceptors/error_interceptor.dart';
import 'package:plexaverse/core/platform/image_sharing.dart';
import 'package:plexaverse/core/platform/link_opening.dart';
import 'package:plexaverse/core/ui/zave/zave_kit.dart';
import 'package:plexaverse/features/profile/data/profile_repositories.dart';
import 'package:plexaverse/features/profile/domain/profile_handle.dart';
import 'package:plexaverse/features/profile/domain/public_profile.dart';
import 'package:plexaverse/features/profile/domain/public_profile_words.dart';
import 'package:plexaverse/features/profile/presentation/widgets/public_profile_section.dart';

/// The public profile in the app (owner, 24 Nov 2026): the handle, the
/// `public_profile` consent in the web's exact words, "View my page" and the
/// ATS CV — and the mobile routes they call.
void main() {
  group('the words', () {
    test('the consent is the web’s PURPOSE_LABELS.public_profile, verbatim', () {
      expect(
        kPublicProfileConsentText,
        'Publish my Plexaverse profile at plexaverse.com/<handle> for anyone '
        'on the internet: my name, photo, headline, about, skills, experience '
        'and education, how many people follow my page, and the posts and '
        'newsletter articles I publish on LinkedIn through Plexaverse.',
      );
      expect(kPublicProfilePurpose, 'public_profile');
    });
  });

  group('the handle', () {
    test('the shape rule, in the server’s sentences', () {
      expect(checkHandle('  @Asang-Borkar '), isA<HandleOk>());
      expect((checkHandle('Asang-Borkar') as HandleOk).handle, 'asang-borkar');
      expect(checkHandle(''), isA<HandleProblem>());
      expect(
        (checkHandle('ab') as HandleProblem).message,
        'A handle is 3 to 30 characters long.',
      );
      for (final String bad in <String>[
        '-asang',
        'asang-',
        'asang--borkar',
        'asang.borkar',
        'asang_borkar',
      ]) {
        expect(checkHandle(bad), isA<HandleProblem>(), reason: bad);
      }
      expect(
        (checkHandle('plexaverse-help') as HandleProblem).message,
        'That handle is reserved. Try another.',
      );
      expect(
        publicProfileUrl('asang-borkar'),
        'https://www.plexaverse.com/asang-borkar',
      );
    });
  });

  group('the wire', () {
    test('settings, availability, publish and unpublish', () async {
      final (ApiProfileRepository repo, _Canned wire) = _stack(
        200,
        _ok(<String, dynamic>{
          'handle': 'asang-borkar',
          'published': true,
          'url': 'https://www.plexaverse.com/asang-borkar',
          'suggestedHandle': null,
          'adultDeclared': true,
          'cvReady': true,
          'availability': <String, dynamic>{
            'handle': 'riya',
            'available': false,
            'problem': 'taken',
            'message': 'That handle is taken. Try another.',
          },
        }),
      );
      final PublicProfileSettings s = await repo.fetchSettings();
      expect(s.published, isTrue);
      expect(s.handle, 'asang-borkar');
      expect(s.cvReady, isTrue);

      final HandleAvailability a = await repo.checkHandle('riya');
      expect(a.available, isFalse);
      expect(a.message, 'That handle is taken. Try another.');
      expect(wire.seen[1].queryParameters, <String, dynamic>{'handle': 'riya'});

      await repo.publish(handle: 'asang-borkar', adult: true);
      expect(wire.seen[2].method, 'PUT');
      expect(wire.seen[2].path, '/profile');
      expect(wire.seen[2].data, <String, dynamic>{
        'published': true,
        'handle': 'asang-borkar',
        'adult': true,
      });

      await repo.unpublish();
      expect(wire.seen[3].data, <String, dynamic>{'published': false});
    });

    test('follow sends the handle; unfollow puts it in the query', () async {
      final (ApiProfileRepository repo, _Canned wire) = _stack(
        200,
        _ok(<String, dynamic>{'following': true, 'followers': 4}),
      );
      final FollowState f = await repo.follow('asha-rao');
      expect(f.following, isTrue);
      expect(f.followers, 4);
      expect(wire.seen[0].method, 'POST');
      expect(wire.seen[0].path, '/profile/follow');
      expect(wire.seen[0].data, <String, dynamic>{'handle': 'asha-rao'});
      await repo.unfollow('asha-rao');
      expect(wire.seen[1].method, 'DELETE');
      expect(wire.seen[1].queryParameters, <String, dynamic>{
        'handle': 'asha-rao',
      });
    });

    test('refusals by their code', () async {
      Future<Object> thrown(String code, int status) async {
        final (ApiProfileRepository repo, _) = _stack(
          status,
          _refusal(code, 'said: $code'),
        );
        try {
          await repo.publish(handle: 'x-y-z');
        } on Object catch (e) {
          return e;
        }
        fail('expected a refusal');
      }

      expect(await thrown('HANDLE_TAKEN', 409), isA<ProfileHandleTaken>());
      expect(await thrown('HANDLE_INVALID', 400), isA<ProfileHandleRefused>());
      expect(await thrown('ADULT_REQUIRED', 403), isA<ProfileAdultRequired>());
      expect(await thrown('NOT_FOUND', 404), isA<ProfileNotFound>());
      expect(await thrown('SELF_FOLLOW', 400), isA<ProfileSelfFollow>());
      expect(
        (await thrown('HANDLE_TAKEN', 409) as ProfileFailure).message,
        'said: HANDLE_TAKEN',
      );
    });

    test('the CV is the PDF itself, named by the server', () async {
      final (ApiProfileRepository repo, _Canned wire) = _stack(
        200,
        null,
        raw: utf8.encode('%PDF-1.4 the CV'),
        headers: <String, List<String>>{
          'content-type': <String>['application/pdf'],
          'content-disposition': <String>[
            'attachment; filename="Asang-Borkar-CV.pdf"',
          ],
        },
      );
      final CvFile cv = await repo.downloadCv();
      expect(wire.seen.single.path, '/profile/cv');
      expect(utf8.decode(cv.bytes), '%PDF-1.4 the CV');
      expect(cv.fileName, 'Asang-Borkar-CV.pdf');
    });

    test('nothing to put in a CV is CV_EMPTY, never an empty PDF', () async {
      final (ApiProfileRepository repo, _) = _stack(
        422,
        _refusal('CV_EMPTY', 'There is nothing to put in your CV yet.'),
      );
      await expectLater(
        repo.downloadCv(),
        throwsA(
          isA<ProfileCvEmpty>().having(
            (ProfileCvEmpty e) => e.message,
            'message',
            // The app's words (review, 24 Nov 2026): never the web's upload
            // "below", which the app does not have.
            kCvEmptyAppMessage,
          ),
        ),
      );
    });

    test('a file name with a path in it is not taken', () {
      expect(
        ApiProfileRepository.cvFileName('attachment; filename="../x.pdf"'),
        'CV.pdf',
      );
      expect(ApiProfileRepository.cvFileName(null), 'CV.pdf');
    });
  });

  group('Settings → Public profile', () {
    Future<(FakeProfileRepository, _Opener, _Sharing)> pump(
      WidgetTester tester, {
      String? handle,
      bool cvReady = true,
      FakeProfileRepository? fake,
    }) async {
      tester.view.physicalSize = const Size(1125, 4000);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      final FakeProfileRepository repo =
          fake ??
          FakeProfileRepository(
            latency: Duration.zero,
            handle: handle,
            cvReady: cvReady,
          );
      final _Opener opener = _Opener();
      final _Sharing sharing = _Sharing();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            envProvider.overrideWithValue(Env.mock),
            profileRepositoryProvider.overrideWithValue(repo),
            linkOpeningProvider.overrideWithValue(opener),
            imageSharingProvider.overrideWithValue(sharing),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(child: PublicProfileSection()),
            ),
          ),
        ),
      );
      await _settle(tester);
      return (repo, opener, sharing);
    }

    testWidgets('the suggestion is only pre-filled; the box starts off; Save '
        'publishes only after the tick', (WidgetTester tester) async {
      final (FakeProfileRepository repo, _, _) = await pump(tester);
      expect(find.text(kPublicProfileConsentText), findsOneWidget);
      expect(find.text('priya-sharma'), findsOneWidget);
      final Finder publish = find.byWidgetPredicate(
        (Widget w) =>
            w is ZaveSwitch && w.semanticLabel == kPublicProfileToggleLabel,
      );
      expect(tester.widget<ZaveSwitch>(publish).value, isFalse);
      final Finder save = find.widgetWithText(ZaveButton, 'Save');
      expect(tester.widget<ZaveButton>(save).onPressed, isNull);

      await tester.tap(publish);
      await _settle(tester);
      await tester.tap(save);
      await _settle(tester);
      expect(repo.writes, <String>['publish:priya-sharma']);
      expect(find.text('Your page is live.'), findsOneWidget);
      expect(find.text('View my page'), findsOneWidget);
    });

    testWidgets('a taken handle is said, and cannot be saved', (
      WidgetTester tester,
    ) async {
      final (FakeProfileRepository repo, _, _) = await pump(tester);
      await tester.enterText(find.byType(TextField), 'asha-rao');
      await _settle(tester, ms: 600);
      expect(find.text('That handle is taken. Try another.'), findsOneWidget);
      await tester.tap(
        find.byWidgetPredicate(
          (Widget w) =>
              w is ZaveSwitch && w.semanticLabel == kPublicProfileToggleLabel,
        ),
      );
      await _settle(tester);
      expect(
        tester
            .widget<ZaveButton>(find.widgetWithText(ZaveButton, 'Save'))
            .onPressed,
        isNull,
      );
      expect(repo.writes, isEmpty);
    });

    // Review of 24 Nov 2026 (FL4): a refused Save re-reads the settings, and
    // the form used to re-seed on that re-read — the typed handle replaced by
    // the suggestion and the box unticked, under a refusal about neither.
    testWidgets('a refused Save keeps what was typed and the tick, under the '
        'refusal', (WidgetTester tester) async {
      final _LosesTheRace race = _LosesTheRace();
      await pump(tester, fake: race);
      await tester.enterText(find.byType(TextField), 'asha-r');
      await _settle(tester, ms: 600);
      final Finder publish = find.byWidgetPredicate(
        (Widget w) =>
            w is ZaveSwitch && w.semanticLabel == kPublicProfileToggleLabel,
      );
      await tester.tap(publish);
      await _settle(tester);
      final int readsBefore = race.settingsReads;
      await tester.tap(find.widgetWithText(ZaveButton, 'Save'));
      await _settle(tester);
      expect(race.writes, <String>['publish:asha-r']);
      expect(race.settingsReads, greaterThan(readsBefore), reason: 're-read');
      expect(find.text('That handle is taken. Try another.'), findsOneWidget);
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        'asha-r',
      );
      expect(tester.widget<ZaveSwitch>(publish).value, isTrue);
    });

    testWidgets('a published page: View my page opens it; un-ticking and '
        'saving unpublishes', (WidgetTester tester) async {
      final (FakeProfileRepository repo, _Opener opener, _) = await pump(
        tester,
        handle: 'riya-kapoor',
      );
      await tester.tap(find.text('View my page'));
      await _settle(tester);
      expect(opener.opened, <String>['https://www.plexaverse.com/riya-kapoor']);

      await tester.tap(
        find.byWidgetPredicate(
          (Widget w) =>
              w is ZaveSwitch && w.semanticLabel == kPublicProfileToggleLabel,
        ),
      );
      await _settle(tester);
      await tester.tap(find.widgetWithText(ZaveButton, 'Save'));
      await _settle(tester);
      expect(repo.writes, <String>['unpublish']);
      expect(
        find.text('Your page is offline and your handle is freed.'),
        findsOneWidget,
      );
    });

    testWidgets('Download ATS CV hands the PDF to the share sheet', (
      WidgetTester tester,
    ) async {
      final (_, _, _Sharing sharing) = await pump(tester);
      expect(find.text(kCvDownloadLine), findsOneWidget);
      // The section's words grew in review (24 Nov 2026); scroll to the button.
      await tester.ensureVisible(find.text('Download ATS CV'));
      await tester.pump();
      await tester.tap(find.text('Download ATS CV'));
      await _settle(tester);
      expect(sharing.files.single.$1, 'Priya-Sharma-CV.pdf');
      expect(utf8.decode(sharing.files.single.$2).startsWith('%PDF-'), isTrue);
    });

    testWidgets('nothing to put in a CV is said instead of a button', (
      WidgetTester tester,
    ) async {
      await pump(tester, cvReady: false);
      expect(find.text('Download ATS CV'), findsNothing);
      expect(find.text(kCvEmptyAppMessage), findsOneWidget);
    });
  });
}

Future<void> _settle(WidgetTester tester, {int ms = 300}) async {
  for (int i = 0; i < ms ~/ 50; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

class _Canned implements HttpClientAdapter {
  _Canned(this.status, this.body, {this.raw, this.headers});

  final int status;
  final Object? body;
  final List<int>? raw;
  final Map<String, List<String>>? headers;
  final List<RequestOptions> seen = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    seen.add(options);
    final List<int>? bytes = raw;
    if (bytes != null) {
      return ResponseBody.fromBytes(
        bytes,
        status,
        headers: headers ?? <String, List<String>>{},
      );
    }
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

(ApiProfileRepository, _Canned) _stack(
  int status,
  Object? body, {
  List<int>? raw,
  Map<String, List<String>>? headers,
}) {
  final _Canned adapter = _Canned(status, body, raw: raw, headers: headers);
  final Dio dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
    ..httpClientAdapter = adapter
    ..interceptors.add(ErrorInterceptor());
  return (ApiProfileRepository(DioClient(dio)), adapter);
}

Map<String, dynamic> _refusal(String code, String message) => <String, dynamic>{
  'data': null,
  'error': <String, dynamic>{'code': code, 'message': message},
  'meta': <String, dynamic>{'version': 'v1'},
};

Map<String, dynamic> _ok(Object? data) => <String, dynamic>{
  'data': data,
  'error': null,
  'meta': <String, dynamic>{'version': 'v1'},
};

class _Opener implements LinkOpeningService {
  final List<String> opened = <String>[];

  @override
  Future<LinkOpenResult> open(String url) async {
    opened.add(url);
    return const LinkOpened();
  }
}

class _Sharing implements ImageSharingService {
  final List<(String, Uint8List)> files = <(String, Uint8List)>[];

  @override
  Future<ShareResult> shareBytesFile({
    required Uint8List bytes,
    required String fileName,
    String? text,
  }) async {
    files.add((fileName, bytes));
    return const ShareSucceeded();
  }

  @override
  Future<ShareResult> shareTextFile({
    required String contents,
    required String fileName,
    String? text,
  }) => throw UnimplementedError();

  @override
  Future<ShareResult> shareImageUrl({
    required String url,
    required String fileName,
    String? text,
  }) => throw UnimplementedError();

  @override
  Future<ShareResult> shareWidgetPng({
    required GlobalKey boundaryKey,
    required String fileName,
    required double targetWidth,
    String? text,
  }) => throw UnimplementedError();
}

/// Availability said the handle was free; someone took it before the Save
/// landed (409 HANDLE_TAKEN), as the server answers a lost race.
class _LosesTheRace extends FakeProfileRepository {
  _LosesTheRace() : super(latency: Duration.zero);

  int settingsReads = 0;

  @override
  Future<PublicProfileSettings> fetchSettings() {
    settingsReads++;
    return super.fetchSettings();
  }

  @override
  Future<PublicProfileSettings> publish({
    required String handle,
    bool adult = false,
  }) async {
    writes.add('publish:$handle');
    throw const ProfileHandleTaken();
  }
}
