import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/auth_repository_providers.dart';
import '../domain/auth_repository.dart';

part 'google_link_controller.g.dart';

/// Whether this account can sign in with Google, and the two actions that
/// change that.
///
/// This exists because sign-in deliberately refuses to link Google to an
/// account that has a password: both register routes mark an address verified
/// without ever mailing it, so the server cannot tell the account's owner from
/// someone who pre-registered their address. Refusing is right, but a refusal
/// with no way forward is a dead end — this is the way forward. The user signs
/// in with their password first, which is the proof that was missing, and then
/// links deliberately from Settings.
///
/// The state is `GoogleLinkStatus?` where **null means unknown**, not
/// unlinked. A failed read must not render a "Link Google" button to someone
/// who already linked it.
@riverpod
class GoogleLinkController extends _$GoogleLinkController {
  @override
  Future<GoogleLinkStatus?> build() =>
      ref.watch(authRepositoryProvider).googleLinkStatus();

  /// Runs the browser hand-off, then refreshes.
  ///
  /// Returns the outcome rather than throwing so the caller can stay silent on
  /// a cancel and speak only on a real refusal — backing out of the browser
  /// sheet is a decision, not an error.
  Future<GoogleLinkResult> link() =>
      _run(() => ref.read(authRepositoryProvider).linkGoogle());

  Future<GoogleLinkResult> unlink() =>
      _run(() => ref.read(authRepositoryProvider).unlinkGoogle());

  Future<GoogleLinkResult> _run(
    Future<GoogleLinkResult> Function() action,
  ) async {
    final GoogleLinkResult result = await action();
    // Only a real change is worth a refetch. Re-reading after a cancel would
    // flash the section's skeleton for nothing.
    if (result is GoogleLinkSucceeded) {
      state = const AsyncLoading<GoogleLinkStatus?>();
      state = await AsyncValue.guard(
        () => ref.read(authRepositoryProvider).googleLinkStatus(),
      );
    }
    return result;
  }
}
