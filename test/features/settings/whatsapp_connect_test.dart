import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:plexaverse/features/settings/application/settings_controllers.dart';
import 'package:plexaverse/features/settings/data/settings_repositories.dart';
import 'package:plexaverse/features/settings/domain/settings_repository.dart';

/// Connecting a WhatsApp number from the app.
///
/// Three of the four things that can go wrong are answers rather than faults —
/// wait, agree, retype — and each leaves the user somewhere different. A single
/// "that did not work" collapses them, which is the failure this pins.
class _Repo implements SettingsRepository {
  _Repo(this._state);

  WhatsAppConnection _state;
  Object? throwOnSend;
  Object? throwOnConfirm;
  int sends = 0;
  int confirms = 0;
  int fetches = 0;
  String? sawPhone;
  String? sawCountryCode;

  @override
  Future<WhatsAppConnection> fetchWhatsApp() async {
    fetches++;
    return _state;
  }

  @override
  Future<void> sendWhatsAppCode({
    required String phone,
    String? defaultCountryCode,
  }) async {
    sends++;
    sawPhone = phone;
    sawCountryCode = defaultCountryCode;
    if (throwOnSend != null) throw throwOnSend!;
    _state = _state.copyWith(awaitingCode: true, phoneMasked: '••••12');
  }

  @override
  Future<void> confirmWhatsAppCode(String code) async {
    confirms++;
    if (throwOnConfirm != null) throw throwOnConfirm!;
    _state = _state.copyWith(connected: true, awaitingCode: false);
  }

  @override
  Future<void> disconnectWhatsApp() async {
    // Mirrors the server: an opt-out outlives a disconnect.
    _state = WhatsAppConnection(available: true, optedOut: _state.optedOut);
  }

  @override
  Future<void> resumeWhatsApp() async {
    _state = _state.copyWith(optedOut: false);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} is not used here');
}

ProviderContainer _container(_Repo repo) {
  final ProviderContainer c = ProviderContainer(
    overrides: <Override>[settingsRepositoryProvider.overrideWithValue(repo)],
  );
  addTearDown(c.dispose);
  return c;
}

void main() {
  group('the model', () {
    test('no credentials on the server means nothing to offer', () {
      expect(const WhatsAppConnection().isUnavailable, isTrue);
      expect(const WhatsAppConnection(available: true).isUnavailable, isFalse);
    });

    test('connected is not the same as live', () {
      // A user who replied STOP is still connected — the number is verified —
      // and nothing will be sent to them. A card that reads `connected` alone
      // tells them messages are on when they are not.
      const WhatsAppConnection silenced = WhatsAppConnection(
        available: true,
        connected: true,
        optedOut: true,
      );
      expect(silenced.connected, isTrue);
      expect(silenced.isLive, isFalse);
      expect(silenced.copyWith(optedOut: false).isLive, isTrue);
    });

    test('reads the wire', () {
      final WhatsAppConnection c = WhatsAppConnection.fromJson(
        <String, dynamic>{
          'available': true,
          'connected': false,
          'phoneMasked': '••••99',
          'awaitingCode': true,
          'optedOut': false,
        },
      );
      expect(c.awaitingCode, isTrue);
      expect(c.phoneMasked, '••••99');
    });

    test('a field the server stops sending falls back, it does not throw', () {
      expect(
        () => WhatsAppConnection.fromJson(<String, dynamic>{}),
        returnsNormally,
      );
      expect(WhatsAppConnection.fromJson(<String, dynamic>{}).available, isFalse);
    });
  });

  group('sending a code', () {
    test('passes the number and the country code through', () async {
      final _Repo repo = _Repo(const WhatsAppConnection(available: true));
      final WhatsAppActions c = _container(
        repo,
      ).read(whatsAppActionsProvider.notifier);

      await c.sendCode('98765 43210', defaultCountryCode: '+91');

      expect(repo.sawPhone, '98765 43210');
      expect(repo.sawCountryCode, '+91');
    });

    test('learns awaitingCode from the server, not from having asked', () async {
      // A send that silently did nothing would otherwise leave the user
      // typing a code that was never issued.
      final _Repo repo = _Repo(const WhatsAppConnection(available: true));
      final ProviderContainer container = _container(repo);
      await container.read(whatsAppControllerProvider.future);

      await container.read(whatsAppActionsProvider.notifier).sendCode('9876543210');

      // The read is what performs the refetch — invalidate only marks the
      // provider stale. Asserting the count before reading would be asserting
      // on Riverpod's scheduling rather than on this behaviour.
      final WhatsAppConnection after = await container.read(
        whatsAppControllerProvider.future,
      );
      expect(repo.fetches, greaterThan(1));
      expect(after.awaitingCode, isTrue);
    });

    /// Each refusal becomes the sentence the row shows.
    ///
    /// Asserted on the ACTIONS state rather than on a throw, because that is
    /// what the row reads. The four are distinct answers — wait, agree,
    /// retype, fix the number — and a single "something went wrong" throws
    /// away the only part the user can act on.
    Future<String?> errorAfterSend(Object failure) async {
      final _Repo repo = _Repo(const WhatsAppConnection(available: true))
        ..throwOnSend = failure;
      final ProviderContainer container = _container(repo);
      await container.read(whatsAppActionsProvider.notifier).sendCode('9876543210');
      return container.read(whatsAppActionsProvider).error;
    }

    test('a cooldown says how long to wait', () async {
      expect(
        await errorAfterSend(const WhatsAppCooldown('Wait 45 seconds.')),
        'Wait 45 seconds.',
      );
    });

    test('missing consent says to agree first', () async {
      // The answer is the consent control, not a retry.
      expect(
        await errorAfterSend(const WhatsAppConsentRequired()),
        contains('Agree'),
      );
    });

    test('a rejected number carries the server’s sentence', () async {
      expect(
        await errorAfterSend(
          const WhatsAppRejected('That does not look like a phone number.'),
        ),
        contains('phone number'),
      );
    });

    test('an unrecognised failure still says something usable', () async {
      expect(await errorAfterSend(Exception('socket')), isNotNull);
    });

    test('a failed send leaves nothing in flight', () async {
      // The row disables four controls on `busy`. Leaving it true after a
      // refusal locks the user out of the retry the refusal is asking for.
      final _Repo repo = _Repo(const WhatsAppConnection(available: true))
        ..throwOnSend = const WhatsAppWrongCode();
      final ProviderContainer container = _container(repo);
      await container.read(whatsAppActionsProvider.notifier).sendCode('9876543210');
      expect(container.read(whatsAppActionsProvider).busy, isFalse);
    });

    test('a success clears a previous error', () async {
      final _Repo repo = _Repo(const WhatsAppConnection(available: true))
        ..throwOnSend = const WhatsAppCooldown('Wait.');
      final ProviderContainer container = _container(repo);
      final WhatsAppActions actions = container.read(
        whatsAppActionsProvider.notifier,
      );

      await actions.sendCode('9876543210');
      expect(container.read(whatsAppActionsProvider).error, isNotNull);

      repo.throwOnSend = null;
      await actions.sendCode('9876543210');
      expect(container.read(whatsAppActionsProvider).error, isNull);
    });
  });

  group('checking the code', () {
    test('a wrong code is its own failure and verifies nothing', () async {
      final _Repo repo = _Repo(
        const WhatsAppConnection(available: true, awaitingCode: true),
      )..throwOnConfirm = const WhatsAppWrongCode();
      final ProviderContainer container = _container(repo);
      await container.read(whatsAppControllerProvider.future);

      await container.read(whatsAppActionsProvider.notifier).confirmCode('000000');
      expect(
        container.read(whatsAppActionsProvider).error,
        contains('not right'),
      );
      final WhatsAppConnection after = await container.read(
        whatsAppControllerProvider.future,
      );
      expect(after.connected, isFalse);
    });

    test('the right code connects', () async {
      final _Repo repo = _Repo(
        const WhatsAppConnection(available: true, awaitingCode: true),
      );
      final ProviderContainer container = _container(repo);
      await container.read(whatsAppControllerProvider.future);

      await container.read(whatsAppActionsProvider.notifier).confirmCode('123456');

      final WhatsAppConnection after = await container.read(
        whatsAppControllerProvider.future,
      );
      expect(after.connected, isTrue);
      expect(after.awaitingCode, isFalse);
    });
  });

  group('disconnect and opt-out are different facts', () {
    // Against the REAL FakeSettingsRepository, not the double above. The rule
    // lives in the server route and is mirrored in the fake; a test driving a
    // double written in this file would only be checking the double, which is
    // exactly what the first version of this group did.
    late FakeSettingsRepository fake;

    setUp(() => fake = FakeSettingsRepository());

    test('the mock starts offerable and unconnected', () async {
      final WhatsAppConnection c = await fake.fetchWhatsApp();
      expect(c.available, isTrue);
      expect(c.connected, isFalse);
    });

    test('a short number is refused with a sentence', () async {
      await expectLater(
        fake.sendWhatsAppCode(phone: '12'),
        throwsA(isA<WhatsAppRejected>()),
      );
    });

    test('a wrong code does not connect; the right one does', () async {
      await fake.sendWhatsAppCode(phone: '9876543210');
      expect((await fake.fetchWhatsApp()).awaitingCode, isTrue);

      await expectLater(
        fake.confirmWhatsAppCode('000000'),
        throwsA(isA<WhatsAppWrongCode>()),
      );
      expect((await fake.fetchWhatsApp()).connected, isFalse);

      await fake.confirmWhatsAppCode('123456');
      expect((await fake.fetchWhatsApp()).connected, isTrue);
    });

    test('the masked number keeps the country code and the last four', () async {
      // Mirrors the server's maskPhone (+91 ••••• 3210). Bulleting everything
      // but the last two digits reads as a shape production never produces,
      // and a masked number its owner cannot recognise is not much use.
      await fake.sendWhatsAppCode(phone: '+919876543210');
      await fake.confirmWhatsAppCode('123456');

      final String? masked = (await fake.fetchWhatsApp()).phoneMasked;
      expect(masked, '+91 ••••• 3210');
    });

    test('disconnecting a plain connection clears it', () async {
      await fake.sendWhatsAppCode(phone: '9876543210');
      await fake.confirmWhatsAppCode('123456');

      await fake.disconnectWhatsApp();

      final WhatsAppConnection after = await fake.fetchWhatsApp();
      expect(after.connected, isFalse);
      expect(after.optedOut, isFalse);
    });

    test('disconnecting does NOT clear an opt-out', () async {
      // The one that matters. If a disconnect dropped the STOP flag, typing
      // the same number back in would silently re-enable messaging to someone
      // who asked us to stop — and they are not our user, so they cannot
      // undo it. The server keeps the row for this reason; the fake mirrors it.
      await fake.sendWhatsAppCode(phone: '9876543210');
      await fake.confirmWhatsAppCode('123456');
      await fake.optOutForTest();

      await fake.disconnectWhatsApp();

      final WhatsAppConnection after = await fake.fetchWhatsApp();
      expect(after.connected, isFalse);
      expect(after.optedOut, isTrue, reason: 'a STOP outlives a disconnect');
    });

    test('an opted-out number cannot be re-verified until resumed', () async {
      await fake.optOutForTest();

      await expectLater(
        fake.sendWhatsAppCode(phone: '9876543210'),
        throwsA(isA<WhatsAppRejected>()),
      );

      await fake.resumeWhatsApp();
      await fake.sendWhatsAppCode(phone: '9876543210');
      expect((await fake.fetchWhatsApp()).awaitingCode, isTrue);
    });
  });
}
