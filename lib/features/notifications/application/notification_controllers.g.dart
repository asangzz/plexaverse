// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Live foreground pushes (FCM in prod, empty in the mock). keepAlive so the
/// FCM stream subscription stays put — a push must never be dropped in a
/// listener gap. [NotificationIngestor] bridges this into the Drift inbox +
/// the in-app banner; rebuilds (re-subscribes) when the repository is
/// invalidated on sign-out.

@ProviderFor(incomingNotifications)
final incomingNotificationsProvider = IncomingNotificationsProvider._();

/// Live foreground pushes (FCM in prod, empty in the mock). keepAlive so the
/// FCM stream subscription stays put — a push must never be dropped in a
/// listener gap. [NotificationIngestor] bridges this into the Drift inbox +
/// the in-app banner; rebuilds (re-subscribes) when the repository is
/// invalidated on sign-out.

final class IncomingNotificationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<AppNotification>,
          AppNotification,
          Stream<AppNotification>
        >
    with $FutureModifier<AppNotification>, $StreamProvider<AppNotification> {
  /// Live foreground pushes (FCM in prod, empty in the mock). keepAlive so the
  /// FCM stream subscription stays put — a push must never be dropped in a
  /// listener gap. [NotificationIngestor] bridges this into the Drift inbox +
  /// the in-app banner; rebuilds (re-subscribes) when the repository is
  /// invalidated on sign-out.
  IncomingNotificationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'incomingNotificationsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$incomingNotificationsHash();

  @$internal
  @override
  $StreamProviderElement<AppNotification> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<AppNotification> create(Ref ref) {
    return incomingNotifications(ref);
  }
}

String _$incomingNotificationsHash() =>
    r'75062867e08e873fb4e58825e2cd5f91ac1fdbad';

/// Bridges a live [AppNotification] (from FCM foreground, or the dev
/// "simulate" action) into both product surfaces:
///   1. persists it to the Drift inbox (so the drawer + badge update), and
///   2. raises the transient in-app banner via the core overlay controller.
///
/// keepAlive so a push that arrives on any screen is handled. The core
/// [InAppNotification] model is presentation-only, so we map onto it here;
/// the deep-link route rides along for tap-to-navigate.

@ProviderFor(NotificationIngestor)
final notificationIngestorProvider = NotificationIngestorProvider._();

/// Bridges a live [AppNotification] (from FCM foreground, or the dev
/// "simulate" action) into both product surfaces:
///   1. persists it to the Drift inbox (so the drawer + badge update), and
///   2. raises the transient in-app banner via the core overlay controller.
///
/// keepAlive so a push that arrives on any screen is handled. The core
/// [InAppNotification] model is presentation-only, so we map onto it here;
/// the deep-link route rides along for tap-to-navigate.
final class NotificationIngestorProvider
    extends $NotifierProvider<NotificationIngestor, void> {
  /// Bridges a live [AppNotification] (from FCM foreground, or the dev
  /// "simulate" action) into both product surfaces:
  ///   1. persists it to the Drift inbox (so the drawer + badge update), and
  ///   2. raises the transient in-app banner via the core overlay controller.
  ///
  /// keepAlive so a push that arrives on any screen is handled. The core
  /// [InAppNotification] model is presentation-only, so we map onto it here;
  /// the deep-link route rides along for tap-to-navigate.
  NotificationIngestorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationIngestorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationIngestorHash();

  @$internal
  @override
  NotificationIngestor create() => NotificationIngestor();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$notificationIngestorHash() =>
    r'7d50e41c9df80c91a11c5d4393444286c883b172';

/// Bridges a live [AppNotification] (from FCM foreground, or the dev
/// "simulate" action) into both product surfaces:
///   1. persists it to the Drift inbox (so the drawer + badge update), and
///   2. raises the transient in-app banner via the core overlay controller.
///
/// keepAlive so a push that arrives on any screen is handled. The core
/// [InAppNotification] model is presentation-only, so we map onto it here;
/// the deep-link route rides along for tap-to-navigate.

abstract class _$NotificationIngestor extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
