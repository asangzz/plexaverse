// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Pulls the server inbox into the cache. Watched by
/// [notificationInboxProvider], so it runs when the inbox is first read.
///
/// A failure is deliberately NOT surfaced as an error state: the cached page
/// below is still worth showing, and an offline user staring at an error
/// where their notifications used to be is worse than slightly stale ones.

@ProviderFor(notificationSync)
final notificationSyncProvider = NotificationSyncProvider._();

/// Pulls the server inbox into the cache. Watched by
/// [notificationInboxProvider], so it runs when the inbox is first read.
///
/// A failure is deliberately NOT surfaced as an error state: the cached page
/// below is still worth showing, and an offline user staring at an error
/// where their notifications used to be is worse than slightly stale ones.

final class NotificationSyncProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Pulls the server inbox into the cache. Watched by
  /// [notificationInboxProvider], so it runs when the inbox is first read.
  ///
  /// A failure is deliberately NOT surfaced as an error state: the cached page
  /// below is still worth showing, and an offline user staring at an error
  /// where their notifications used to be is worse than slightly stale ones.
  NotificationSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationSyncProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationSyncHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return notificationSync(ref);
  }
}

String _$notificationSyncHash() => r'135940297b19d1aacb6dd944913b8ef60324210b';

/// Marking read, on the server AND in the cache.
///
/// The drawer used to call the DAO directly, so a notification read on the
/// phone stayed unread everywhere else and came back unread on the next
/// sync — read state belongs to the account, not the device.

@ProviderFor(NotificationReads)
final notificationReadsProvider = NotificationReadsProvider._();

/// Marking read, on the server AND in the cache.
///
/// The drawer used to call the DAO directly, so a notification read on the
/// phone stayed unread everywhere else and came back unread on the next
/// sync — read state belongs to the account, not the device.
final class NotificationReadsProvider
    extends $NotifierProvider<NotificationReads, void> {
  /// Marking read, on the server AND in the cache.
  ///
  /// The drawer used to call the DAO directly, so a notification read on the
  /// phone stayed unread everywhere else and came back unread on the next
  /// sync — read state belongs to the account, not the device.
  NotificationReadsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationReadsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationReadsHash();

  @$internal
  @override
  NotificationReads create() => NotificationReads();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$notificationReadsHash() => r'eb65912388c463d5a9b140108d1892e36ed40993';

/// Marking read, on the server AND in the cache.
///
/// The drawer used to call the DAO directly, so a notification read on the
/// phone stayed unread everywhere else and came back unread on the next
/// sync — read state belongs to the account, not the device.

abstract class _$NotificationReads extends $Notifier<void> {
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
