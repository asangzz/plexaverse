// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(accountSnapshot)
final accountSnapshotProvider = AccountSnapshotProvider._();

final class AccountSnapshotProvider
    extends
        $FunctionalProvider<
          AsyncValue<AccountSnapshot>,
          AccountSnapshot,
          FutureOr<AccountSnapshot>
        >
    with $FutureModifier<AccountSnapshot>, $FutureProvider<AccountSnapshot> {
  AccountSnapshotProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountSnapshotProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountSnapshotHash();

  @$internal
  @override
  $FutureProviderElement<AccountSnapshot> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AccountSnapshot> create(Ref ref) {
    return accountSnapshot(ref);
  }
}

String _$accountSnapshotHash() => r'5dc09e0077586d1610c78e73935937e6ce3da95f';

/// The XP balance shown beside the plan.

@ProviderFor(xpSummary)
final xpSummaryProvider = XpSummaryProvider._();

/// The XP balance shown beside the plan.

final class XpSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<XpSummary>,
          XpSummary,
          FutureOr<XpSummary>
        >
    with $FutureModifier<XpSummary>, $FutureProvider<XpSummary> {
  /// The XP balance shown beside the plan.
  XpSummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'xpSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$xpSummaryHash();

  @$internal
  @override
  $FutureProviderElement<XpSummary> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<XpSummary> create(Ref ref) {
    return xpSummary(ref);
  }
}

String _$xpSummaryHash() => r'77593d50714f4056b9b62b7191109e019c48fff4';

/// Connected LinkedIn profiles, plus the connect hand-off.

@ProviderFor(LinkedinAccountsController)
final linkedinAccountsControllerProvider =
    LinkedinAccountsControllerProvider._();

/// Connected LinkedIn profiles, plus the connect hand-off.
final class LinkedinAccountsControllerProvider
    extends
        $AsyncNotifierProvider<
          LinkedinAccountsController,
          List<LinkedinAccount>
        > {
  /// Connected LinkedIn profiles, plus the connect hand-off.
  LinkedinAccountsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'linkedinAccountsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$linkedinAccountsControllerHash();

  @$internal
  @override
  LinkedinAccountsController create() => LinkedinAccountsController();
}

String _$linkedinAccountsControllerHash() =>
    r'f18995ec3da8c77cc66276b5e8baaf530f261d7d';

/// Connected LinkedIn profiles, plus the connect hand-off.

abstract class _$LinkedinAccountsController
    extends $AsyncNotifier<List<LinkedinAccount>> {
  FutureOr<List<LinkedinAccount>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<LinkedinAccount>>, List<LinkedinAccount>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<LinkedinAccount>>,
                List<LinkedinAccount>
              >,
              AsyncValue<List<LinkedinAccount>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// The personal LinkedIn account, or null.
///
/// The web treats a row with no `appType` as personal — older rows predate the
/// column — and this must match, or a long-standing user's only account
/// silently disappears from the page.

@ProviderFor(personalLinkedinAccount)
final personalLinkedinAccountProvider = PersonalLinkedinAccountProvider._();

/// The personal LinkedIn account, or null.
///
/// The web treats a row with no `appType` as personal — older rows predate the
/// column — and this must match, or a long-standing user's only account
/// silently disappears from the page.

final class PersonalLinkedinAccountProvider
    extends
        $FunctionalProvider<
          LinkedinAccount?,
          LinkedinAccount?,
          LinkedinAccount?
        >
    with $Provider<LinkedinAccount?> {
  /// The personal LinkedIn account, or null.
  ///
  /// The web treats a row with no `appType` as personal — older rows predate the
  /// column — and this must match, or a long-standing user's only account
  /// silently disappears from the page.
  PersonalLinkedinAccountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'personalLinkedinAccountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$personalLinkedinAccountHash();

  @$internal
  @override
  $ProviderElement<LinkedinAccount?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LinkedinAccount? create(Ref ref) {
    return personalLinkedinAccount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LinkedinAccount? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LinkedinAccount?>(value),
    );
  }
}

String _$personalLinkedinAccountHash() =>
    r'e8641530f236952e627281da692a8b46329373b9';

/// The company LinkedIn account, or null.

@ProviderFor(companyLinkedinAccount)
final companyLinkedinAccountProvider = CompanyLinkedinAccountProvider._();

/// The company LinkedIn account, or null.

final class CompanyLinkedinAccountProvider
    extends
        $FunctionalProvider<
          LinkedinAccount?,
          LinkedinAccount?,
          LinkedinAccount?
        >
    with $Provider<LinkedinAccount?> {
  /// The company LinkedIn account, or null.
  CompanyLinkedinAccountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'companyLinkedinAccountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$companyLinkedinAccountHash();

  @$internal
  @override
  $ProviderElement<LinkedinAccount?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LinkedinAccount? create(Ref ref) {
    return companyLinkedinAccount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LinkedinAccount? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LinkedinAccount?>(value),
    );
  }
}

String _$companyLinkedinAccountHash() =>
    r'63614ee85ae271f67ce1830e14fb250ad7e24de4';

/// Slack connection status + disconnect.

@ProviderFor(SlackController)
final slackControllerProvider = SlackControllerProvider._();

/// Slack connection status + disconnect.
final class SlackControllerProvider
    extends $AsyncNotifierProvider<SlackController, SlackConnection> {
  /// Slack connection status + disconnect.
  SlackControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'slackControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$slackControllerHash();

  @$internal
  @override
  SlackController create() => SlackController();
}

String _$slackControllerHash() => r'8e3355544761782e5a7c72dc6f6be5a3b8516c68';

/// Slack connection status + disconnect.

abstract class _$SlackController extends $AsyncNotifier<SlackConnection> {
  FutureOr<SlackConnection> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<SlackConnection>, SlackConnection>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SlackConnection>, SlackConnection>,
              AsyncValue<SlackConnection>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Google Calendar connection status + disconnect.

@ProviderFor(CalendarController)
final calendarControllerProvider = CalendarControllerProvider._();

/// Google Calendar connection status + disconnect.
final class CalendarControllerProvider
    extends $AsyncNotifierProvider<CalendarController, CalendarConnection> {
  /// Google Calendar connection status + disconnect.
  CalendarControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'calendarControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$calendarControllerHash();

  @$internal
  @override
  CalendarController create() => CalendarController();
}

String _$calendarControllerHash() =>
    r'85e186262dbcd68a9087257a02f8ffd3e38b3036';

/// Google Calendar connection status + disconnect.

abstract class _$CalendarController extends $AsyncNotifier<CalendarConnection> {
  FutureOr<CalendarConnection> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<CalendarConnection>, CalendarConnection>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<CalendarConnection>, CalendarConnection>,
              AsyncValue<CalendarConnection>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Localised plan pricing.
///
/// The country comes from the device's locale rather than an IP lookup: the
/// mobile pricing route takes `?country=` precisely so the client can answer
/// that question itself, and an IP guess on a phone is wrong as often as it is
/// right (roaming, VPN, carrier egress in another country).

@ProviderFor(geoPricing)
final geoPricingProvider = GeoPricingProvider._();

/// Localised plan pricing.
///
/// The country comes from the device's locale rather than an IP lookup: the
/// mobile pricing route takes `?country=` precisely so the client can answer
/// that question itself, and an IP guess on a phone is wrong as often as it is
/// right (roaming, VPN, carrier egress in another country).

final class GeoPricingProvider
    extends
        $FunctionalProvider<
          AsyncValue<GeoPricing>,
          GeoPricing,
          FutureOr<GeoPricing>
        >
    with $FutureModifier<GeoPricing>, $FutureProvider<GeoPricing> {
  /// Localised plan pricing.
  ///
  /// The country comes from the device's locale rather than an IP lookup: the
  /// mobile pricing route takes `?country=` precisely so the client can answer
  /// that question itself, and an IP guess on a phone is wrong as often as it is
  /// right (roaming, VPN, carrier egress in another country).
  GeoPricingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'geoPricingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$geoPricingHash();

  @$internal
  @override
  $FutureProviderElement<GeoPricing> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<GeoPricing> create(Ref ref) {
    return geoPricing(ref);
  }
}

String _$geoPricingHash() => r'cda07207517f1f57ce88f5dc5d7b4b31521f4b83';
