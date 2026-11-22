// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pricing_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Localised plan prices — and, on this screen, the region every card's
/// offer and checkout country are decided from.
///
/// NO `?country=`: the server reads the edge's country, exactly as for the
/// onboarding plan step and Settings' way back ([autopayRestartOffer]). The
/// region now picks the payment instrument, not only a displayed price — India
/// gets UPI AutoPay and a free month, everywhere else the international pass —
/// and the phone's locale is a LANGUAGE setting: "English (United States)" is
/// an ordinary choice in India, and reading it here sold an Indian user the
/// international pass and skipped their free month, while onboarding and
/// Settings offered the same person UPI AutoPay.

@ProviderFor(planPricing)
final planPricingProvider = PlanPricingProvider._();

/// Localised plan prices — and, on this screen, the region every card's
/// offer and checkout country are decided from.
///
/// NO `?country=`: the server reads the edge's country, exactly as for the
/// onboarding plan step and Settings' way back ([autopayRestartOffer]). The
/// region now picks the payment instrument, not only a displayed price — India
/// gets UPI AutoPay and a free month, everywhere else the international pass —
/// and the phone's locale is a LANGUAGE setting: "English (United States)" is
/// an ordinary choice in India, and reading it here sold an Indian user the
/// international pass and skipped their free month, while onboarding and
/// Settings offered the same person UPI AutoPay.

final class PlanPricingProvider
    extends
        $FunctionalProvider<
          AsyncValue<PlanPricing>,
          PlanPricing,
          FutureOr<PlanPricing>
        >
    with $FutureModifier<PlanPricing>, $FutureProvider<PlanPricing> {
  /// Localised plan prices — and, on this screen, the region every card's
  /// offer and checkout country are decided from.
  ///
  /// NO `?country=`: the server reads the edge's country, exactly as for the
  /// onboarding plan step and Settings' way back ([autopayRestartOffer]). The
  /// region now picks the payment instrument, not only a displayed price — India
  /// gets UPI AutoPay and a free month, everywhere else the international pass —
  /// and the phone's locale is a LANGUAGE setting: "English (United States)" is
  /// an ordinary choice in India, and reading it here sold an Indian user the
  /// international pass and skipped their free month, while onboarding and
  /// Settings offered the same person UPI AutoPay.
  PlanPricingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'planPricingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$planPricingHash();

  @$internal
  @override
  $FutureProviderElement<PlanPricing> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PlanPricing> create(Ref ref) {
    return planPricing(ref);
  }
}

String _$planPricingHash() => r'c7e24a362e337d8f19df6a32d1a9120486dd3173';

/// Which plans this account may buy.
///
/// Its own provider rather than a field on [planPricing] so a slow or failed
/// preferences read delays the GATE, not the prices. Null while loading and
/// null on failure both mean "show everything", which is the web's own
/// behaviour before `brandType` arrives.

@ProviderFor(pricingBrandType)
final pricingBrandTypeProvider = PricingBrandTypeProvider._();

/// Which plans this account may buy.
///
/// Its own provider rather than a field on [planPricing] so a slow or failed
/// preferences read delays the GATE, not the prices. Null while loading and
/// null on failure both mean "show everything", which is the web's own
/// behaviour before `brandType` arrives.

final class PricingBrandTypeProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  /// Which plans this account may buy.
  ///
  /// Its own provider rather than a field on [planPricing] so a slow or failed
  /// preferences read delays the GATE, not the prices. Null while loading and
  /// null on failure both mean "show everything", which is the web's own
  /// behaviour before `brandType` arrives.
  PricingBrandTypeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pricingBrandTypeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pricingBrandTypeHash();

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    return pricingBrandType(ref);
  }
}

String _$pricingBrandTypeHash() => r'b8f1d113fbee8a7160eb8d03653ffe15a8278d10';

/// What every plan includes, per AI feature.
///
/// Never errors: a failed read falls back to [AllowanceTable.fallback], the
/// static list that mirrors the web's defaults. The block exists to say what a
/// plan buys, and a user deciding whether to pay should not see that sentence
/// replaced by a retry button. An empty live answer falls back too — a plan
/// that includes nothing is never the truth.

@ProviderFor(planAllowances)
final planAllowancesProvider = PlanAllowancesProvider._();

/// What every plan includes, per AI feature.
///
/// Never errors: a failed read falls back to [AllowanceTable.fallback], the
/// static list that mirrors the web's defaults. The block exists to say what a
/// plan buys, and a user deciding whether to pay should not see that sentence
/// replaced by a retry button. An empty live answer falls back too — a plan
/// that includes nothing is never the truth.

final class PlanAllowancesProvider
    extends
        $FunctionalProvider<
          AsyncValue<AllowanceTable>,
          AllowanceTable,
          FutureOr<AllowanceTable>
        >
    with $FutureModifier<AllowanceTable>, $FutureProvider<AllowanceTable> {
  /// What every plan includes, per AI feature.
  ///
  /// Never errors: a failed read falls back to [AllowanceTable.fallback], the
  /// static list that mirrors the web's defaults. The block exists to say what a
  /// plan buys, and a user deciding whether to pay should not see that sentence
  /// replaced by a retry button. An empty live answer falls back too — a plan
  /// that includes nothing is never the truth.
  PlanAllowancesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'planAllowancesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$planAllowancesHash();

  @$internal
  @override
  $FutureProviderElement<AllowanceTable> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AllowanceTable> create(Ref ref) {
    return planAllowances(ref);
  }
}

String _$planAllowancesHash() => r'7b62d894107c49c1f9f36471e9d259684e995b7f';

/// The referral code and its lifetime counters.

@ProviderFor(ReferralController)
final referralControllerProvider = ReferralControllerProvider._();

/// The referral code and its lifetime counters.
final class ReferralControllerProvider
    extends $AsyncNotifierProvider<ReferralController, ReferralSummary> {
  /// The referral code and its lifetime counters.
  ReferralControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'referralControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$referralControllerHash();

  @$internal
  @override
  ReferralController create() => ReferralController();
}

String _$referralControllerHash() =>
    r'07d5589d292bac67cefa971ea86feb2ce5a5410e';

/// The referral code and its lifetime counters.

abstract class _$ReferralController extends $AsyncNotifier<ReferralSummary> {
  FutureOr<ReferralSummary> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ReferralSummary>, ReferralSummary>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ReferralSummary>, ReferralSummary>,
              AsyncValue<ReferralSummary>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// `GET /payment/config` — this user's UPI AutoPay offer (TOKEN_AUTOPAY_SPEC
/// §4.1). Its own provider so a failed read is a retry on the plan cards
/// only, never a fallback to the pass: the server may owe this person a free
/// month.

@ProviderFor(pricingPaymentConfig)
final pricingPaymentConfigProvider = PricingPaymentConfigProvider._();

/// `GET /payment/config` — this user's UPI AutoPay offer (TOKEN_AUTOPAY_SPEC
/// §4.1). Its own provider so a failed read is a retry on the plan cards
/// only, never a fallback to the pass: the server may owe this person a free
/// month.

final class PricingPaymentConfigProvider
    extends
        $FunctionalProvider<
          AsyncValue<PaymentConfig>,
          PaymentConfig,
          FutureOr<PaymentConfig>
        >
    with $FutureModifier<PaymentConfig>, $FutureProvider<PaymentConfig> {
  /// `GET /payment/config` — this user's UPI AutoPay offer (TOKEN_AUTOPAY_SPEC
  /// §4.1). Its own provider so a failed read is a retry on the plan cards
  /// only, never a fallback to the pass: the server may owe this person a free
  /// month.
  PricingPaymentConfigProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pricingPaymentConfigProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pricingPaymentConfigHash();

  @$internal
  @override
  $FutureProviderElement<PaymentConfig> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PaymentConfig> create(Ref ref) {
    return pricingPaymentConfig(ref);
  }
}

String _$pricingPaymentConfigHash() =>
    r'a80bc439343a64b74d8a2302c74ee19d56ede2cd';

/// `GET /autopay/status` — the account's UPI AutoPay mandate: the next
/// payment, how long the plan runs, and whether Stop autopay applies. Read by
/// Settings → Billing, and by Pricing so a live mandate is never sold a
/// second plan.

@ProviderFor(autopayStatus)
final autopayStatusProvider = AutopayStatusProvider._();

/// `GET /autopay/status` — the account's UPI AutoPay mandate: the next
/// payment, how long the plan runs, and whether Stop autopay applies. Read by
/// Settings → Billing, and by Pricing so a live mandate is never sold a
/// second plan.

final class AutopayStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<AutopayStatus>,
          AutopayStatus,
          FutureOr<AutopayStatus>
        >
    with $FutureModifier<AutopayStatus>, $FutureProvider<AutopayStatus> {
  /// `GET /autopay/status` — the account's UPI AutoPay mandate: the next
  /// payment, how long the plan runs, and whether Stop autopay applies. Read by
  /// Settings → Billing, and by Pricing so a live mandate is never sold a
  /// second plan.
  AutopayStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'autopayStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$autopayStatusHash();

  @$internal
  @override
  $FutureProviderElement<AutopayStatus> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AutopayStatus> create(Ref ref) {
    return autopayStatus(ref);
  }
}

String _$autopayStatusHash() => r'38e22bc11d9f8f3a72d121ac7851c8213b783bac';

/// `GET /billing/invoices` — the user's GST tax invoices, credit notes and
/// refund vouchers (TOKEN_AUTOPAY_SPEC.md §5.9), for Settings → Billing. Its
/// own provider so a failed read is a retry on the list only.

@ProviderFor(taxDocuments)
final taxDocumentsProvider = TaxDocumentsProvider._();

/// `GET /billing/invoices` — the user's GST tax invoices, credit notes and
/// refund vouchers (TOKEN_AUTOPAY_SPEC.md §5.9), for Settings → Billing. Its
/// own provider so a failed read is a retry on the list only.

final class TaxDocumentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TaxDocument>>,
          List<TaxDocument>,
          FutureOr<List<TaxDocument>>
        >
    with
        $FutureModifier<List<TaxDocument>>,
        $FutureProvider<List<TaxDocument>> {
  /// `GET /billing/invoices` — the user's GST tax invoices, credit notes and
  /// refund vouchers (TOKEN_AUTOPAY_SPEC.md §5.9), for Settings → Billing. Its
  /// own provider so a failed read is a retry on the list only.
  TaxDocumentsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taxDocumentsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taxDocumentsHash();

  @$internal
  @override
  $FutureProviderElement<List<TaxDocument>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<TaxDocument>> create(Ref ref) {
    return taxDocuments(ref);
  }
}

String _$taxDocumentsHash() => r'3f25b44762b1c25a56e2579ff54162dafe67915a';

/// One document's printable page, fetched with the bearer token. Disposed
/// with the sheet that shows it: a tax document is read when it is opened,
/// never kept in memory behind the list.

@ProviderFor(taxDocumentHtml)
final taxDocumentHtmlProvider = TaxDocumentHtmlFamily._();

/// One document's printable page, fetched with the bearer token. Disposed
/// with the sheet that shows it: a tax document is read when it is opened,
/// never kept in memory behind the list.

final class TaxDocumentHtmlProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  /// One document's printable page, fetched with the bearer token. Disposed
  /// with the sheet that shows it: a tax document is read when it is opened,
  /// never kept in memory behind the list.
  TaxDocumentHtmlProvider._({
    required TaxDocumentHtmlFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'taxDocumentHtmlProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$taxDocumentHtmlHash();

  @override
  String toString() {
    return r'taxDocumentHtmlProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    final argument = this.argument as String;
    return taxDocumentHtml(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TaxDocumentHtmlProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$taxDocumentHtmlHash() => r'f491b2f3314d6868e200515eb32922a872d590c6';

/// One document's printable page, fetched with the bearer token. Disposed
/// with the sheet that shows it: a tax document is read when it is opened,
/// never kept in memory behind the list.

final class TaxDocumentHtmlFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<String>, String> {
  TaxDocumentHtmlFamily._()
    : super(
        retry: null,
        name: r'taxDocumentHtmlProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One document's printable page, fetched with the bearer token. Disposed
  /// with the sheet that shows it: a tax document is read when it is opened,
  /// never kept in memory behind the list.

  TaxDocumentHtmlProvider call(String id) =>
      TaxDocumentHtmlProvider._(argument: id, from: this);

  @override
  String toString() => r'taxDocumentHtmlProvider';
}

/// The way back once AutoPay is off (Settings → Billing): the personal offer
/// the server would register NOW, decided like the onboarding plan step's —
/// the region from the server's edge, not the device locale. Null when what
/// is offered is not UPI AutoPay (the rail is dark, or not India). Throws
/// when it cannot be worked out, so the section shows a retry.

@ProviderFor(autopayRestartOffer)
final autopayRestartOfferProvider = AutopayRestartOfferProvider._();

/// The way back once AutoPay is off (Settings → Billing): the personal offer
/// the server would register NOW, decided like the onboarding plan step's —
/// the region from the server's edge, not the device locale. Null when what
/// is offered is not UPI AutoPay (the rail is dark, or not India). Throws
/// when it cannot be worked out, so the section shows a retry.

final class AutopayRestartOfferProvider
    extends
        $FunctionalProvider<
          AsyncValue<PlanOffer?>,
          PlanOffer?,
          FutureOr<PlanOffer?>
        >
    with $FutureModifier<PlanOffer?>, $FutureProvider<PlanOffer?> {
  /// The way back once AutoPay is off (Settings → Billing): the personal offer
  /// the server would register NOW, decided like the onboarding plan step's —
  /// the region from the server's edge, not the device locale. Null when what
  /// is offered is not UPI AutoPay (the rail is dark, or not India). Throws
  /// when it cannot be worked out, so the section shows a retry.
  AutopayRestartOfferProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'autopayRestartOfferProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$autopayRestartOfferHash();

  @$internal
  @override
  $FutureProviderElement<PlanOffer?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<PlanOffer?> create(Ref ref) {
    return autopayRestartOffer(ref);
  }
}

String _$autopayRestartOfferHash() =>
    r'2f4eac3eb87c2b44a682b8adc3c933a7cb5f5cff';

/// Buying a plan from the Pricing screen.
///
/// The create → sheet → verify sequence is [PlanCheckout]'s, shared with the
/// onboarding plan step; this dispatches on the [PlanOffer] (UPI AutoPay or
/// the 30-day pass), turns the outcome into the screen's message, and
/// refreshes what a new plan changes.
///
/// The state is the plan id whose checkout is open, so a second tap cannot
/// open a second sheet.

@ProviderFor(CheckoutController)
final checkoutControllerProvider = CheckoutControllerProvider._();

/// Buying a plan from the Pricing screen.
///
/// The create → sheet → verify sequence is [PlanCheckout]'s, shared with the
/// onboarding plan step; this dispatches on the [PlanOffer] (UPI AutoPay or
/// the 30-day pass), turns the outcome into the screen's message, and
/// refreshes what a new plan changes.
///
/// The state is the plan id whose checkout is open, so a second tap cannot
/// open a second sheet.
final class CheckoutControllerProvider
    extends $NotifierProvider<CheckoutController, String?> {
  /// Buying a plan from the Pricing screen.
  ///
  /// The create → sheet → verify sequence is [PlanCheckout]'s, shared with the
  /// onboarding plan step; this dispatches on the [PlanOffer] (UPI AutoPay or
  /// the 30-day pass), turns the outcome into the screen's message, and
  /// refreshes what a new plan changes.
  ///
  /// The state is the plan id whose checkout is open, so a second tap cannot
  /// open a second sheet.
  CheckoutControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'checkoutControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$checkoutControllerHash();

  @$internal
  @override
  CheckoutController create() => CheckoutController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$checkoutControllerHash() =>
    r'a5a470b13b30ce1d5b732fcec4b6e3425c90c43e';

/// Buying a plan from the Pricing screen.
///
/// The create → sheet → verify sequence is [PlanCheckout]'s, shared with the
/// onboarding plan step; this dispatches on the [PlanOffer] (UPI AutoPay or
/// the 30-day pass), turns the outcome into the screen's message, and
/// refreshes what a new plan changes.
///
/// The state is the plan id whose checkout is open, so a second tap cannot
/// open a second sheet.

abstract class _$CheckoutController extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Stop autopay, from Settings → Billing (TOKEN_AUTOPAY_SPEC.md D17).
///
/// The server stops the database first and then tells Razorpay; a success
/// always means nothing more will be debited. The state is the last result
/// (null before any stop); an error carries the server's sentence when it
/// sent one ([stopAutopayErrorMessage]).

@ProviderFor(StopAutopayController)
final stopAutopayControllerProvider = StopAutopayControllerProvider._();

/// Stop autopay, from Settings → Billing (TOKEN_AUTOPAY_SPEC.md D17).
///
/// The server stops the database first and then tells Razorpay; a success
/// always means nothing more will be debited. The state is the last result
/// (null before any stop); an error carries the server's sentence when it
/// sent one ([stopAutopayErrorMessage]).
final class StopAutopayControllerProvider
    extends $AsyncNotifierProvider<StopAutopayController, StopAutopayResult?> {
  /// Stop autopay, from Settings → Billing (TOKEN_AUTOPAY_SPEC.md D17).
  ///
  /// The server stops the database first and then tells Razorpay; a success
  /// always means nothing more will be debited. The state is the last result
  /// (null before any stop); an error carries the server's sentence when it
  /// sent one ([stopAutopayErrorMessage]).
  StopAutopayControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stopAutopayControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stopAutopayControllerHash();

  @$internal
  @override
  StopAutopayController create() => StopAutopayController();
}

String _$stopAutopayControllerHash() =>
    r'f943cfe95e85684f4ebddb233095934db69d5bd9';

/// Stop autopay, from Settings → Billing (TOKEN_AUTOPAY_SPEC.md D17).
///
/// The server stops the database first and then tells Razorpay; a success
/// always means nothing more will be debited. The state is the last result
/// (null before any stop); an error carries the server's sentence when it
/// sent one ([stopAutopayErrorMessage]).

abstract class _$StopAutopayController
    extends $AsyncNotifier<StopAutopayResult?> {
  FutureOr<StopAutopayResult?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<StopAutopayResult?>, StopAutopayResult?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<StopAutopayResult?>, StopAutopayResult?>,
              AsyncValue<StopAutopayResult?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
