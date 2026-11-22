// The buyer's GST State — the app's half of the web's `lib/billing-state.ts`
// (owner, 22 Nov 2026; GST memo Q1).
//
// WHY IT IS ASKED. Plexaverse sells an online service to unregistered buyers,
// so every tax invoice must name the buyer's State (the CGST Rules 46(f)
// proviso; CBIC Circular 242/36/2024-GST asks for it "before making any
// supplies"). That State is also the place of supply: Maharashtra is CGST +
// SGST, any other State or UT is IGST. The server does that arithmetic; the
// app only asks, and saves what the buyer chose.
//
// WHERE IT IS ASKED. In onboarding, as its own step BEFORE the plan step
// (which can take a payment); in Settings → Billing, where it can be seen and
// changed; and inline before a payment for an account that has none
// (`checkout`). Only ever of a buyer paying in rupees — someone abroad has no
// GST State and is never asked.
//
// WHAT IT NEVER DOES. Block a payment. The server takes a payment without a
// State (older app builds cannot send one): that invoice falls back to the
// supplier's State and is flagged for the admin. So an unreadable State is
// never a reason to stop someone paying.
//
// The server's region may PRE-SELECT the answer (`suggestedStateCode`); it is
// never the record. Only the buyer's own tap saves it.

/// Where a declaration was made — stored with it as evidence. The wire values
/// are the server's (`billing_state_source`); anything else is a 400.
enum BillingStateSource {
  onboarding('onboarding'),
  settings('settings'),
  checkout('checkout');

  const BillingStateSource(this.wire);

  final String wire;

  static BillingStateSource? parse(Object? v) {
    for (final BillingStateSource s in values) {
      if (s.wire == v) return s;
    }
    return null;
  }
}

/// Every State and Union Territory a buyer may declare, by GST code — the
/// web's `GST_STATES` without 97 "Other Territory" (India's offshore areas,
/// for suppliers there). There is no "Outside India": a buyer abroad pays in
/// dollars and is never asked.
const Map<String, String> kGstStates = <String, String>{
  '01': 'Jammu and Kashmir',
  '02': 'Himachal Pradesh',
  '03': 'Punjab',
  '04': 'Chandigarh',
  '05': 'Uttarakhand',
  '06': 'Haryana',
  '07': 'Delhi',
  '08': 'Rajasthan',
  '09': 'Uttar Pradesh',
  '10': 'Bihar',
  '11': 'Sikkim',
  '12': 'Arunachal Pradesh',
  '13': 'Nagaland',
  '14': 'Manipur',
  '15': 'Mizoram',
  '16': 'Tripura',
  '17': 'Meghalaya',
  '18': 'Assam',
  '19': 'West Bengal',
  '20': 'Jharkhand',
  '21': 'Odisha',
  '22': 'Chhattisgarh',
  '23': 'Madhya Pradesh',
  '24': 'Gujarat',
  '26': 'Dadra and Nagar Haveli and Daman and Diu',
  '27': 'Maharashtra',
  '29': 'Karnataka',
  '30': 'Goa',
  '31': 'Lakshadweep',
  '32': 'Kerala',
  '33': 'Tamil Nadu',
  '34': 'Puducherry',
  '35': 'Andaman and Nicobar Islands',
  '36': 'Telangana',
  '37': 'Andhra Pradesh',
  '38': 'Ladakh',
};

/// One entry of the picker's list.
typedef BillingStateOption = ({String code, String name});

/// The picker's list: every State and UT, by name — the web's
/// `BILLING_STATE_OPTIONS`.
final List<BillingStateOption> kBillingStateOptions =
    List<BillingStateOption>.unmodifiable(
      <BillingStateOption>[
        for (final MapEntry<String, String> e in kGstStates.entries)
          (code: e.key, name: e.value),
      ]..sort(
        (BillingStateOption a, BillingStateOption b) =>
            a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      ),
    );

/// A declarable GST State code: exactly one of [kGstStates]. This is what the
/// picker may SUBMIT — an empty choice, or a code that is not a State, is
/// never sent.
bool isBillingStateCode(String? code) =>
    code != null && kGstStates.containsKey(code);

/// `29` → `Karnataka`; null for anything that is not a declarable code.
String? billingStateName(String? code) =>
    code == null ? null : kGstStates[code];

/// The question, everywhere it is asked — the web's `BILLING_STATE_QUESTION`.
const String kBillingStateQuestion = 'Which State are you in?';

/// Why it is asked, in one sentence (the owner's wording) — the web's
/// `BILLING_STATE_REASON`.
const String kBillingStateReason = 'It is printed on your GST invoices.';

/// What a changed State does to documents already issued — the web's
/// Settings line.
const String kBillingStateChangeNote =
    'Changing it applies to invoices issued from now on; invoices already '
    'issued keep the State they were issued with.';

/// What a save that failed without a sentence of the server's says.
const String kBillingStateSaveFailed =
    'We could not save your State. Try again.';

/// Should this buyer be asked? Only a buyer in India with no State on record.
///
/// Deliberately looser than the web's `billingStateNeeded`, which also asks
/// when the code on record is not one of ITS list: there the list and the
/// server are one deploy. Here a server newer than this build could hold a
/// code this list lacks, and re-asking a buyer who has answered, on every
/// payment, would be the worse failure. Any State on record counts.
bool billingStateNeeded({required bool isIndia, required String? stateCode}) =>
    isIndia && (stateCode == null || stateCode.trim().isEmpty);

/// `GET /user/billing-state` — what is on record, and where the request is
/// from.
class BillingState {
  const BillingState({
    this.stateCode,
    this.stateName,
    this.declaredAt,
    this.source,
    this.isIndia = false,
    this.suggestedStateCode,
  });

  /// Lenient on purpose: a field this build cannot read is left out rather
  /// than failing the read, because an unreadable State only ever means "do
  /// not ask" — never "do not let them pay".
  factory BillingState.fromJson(Map<String, dynamic> json) {
    final String? code = _text(json['stateCode']);
    final String? suggested = _text(json['suggestedStateCode']);
    final Object? declared = json['declaredAt'];
    return BillingState(
      stateCode: code,
      // The server's name first: it may know a code this build does not.
      stateName: _text(json['stateName']) ?? billingStateName(code),
      declaredAt: declared is String ? DateTime.tryParse(declared) : null,
      source: BillingStateSource.parse(json['source']),
      isIndia: json['isIndia'] == true,
      // Only ever a pre-selection, so only one this picker can show.
      suggestedStateCode: isBillingStateCode(suggested) ? suggested : null,
    );
  }

  /// The declared GST State code, or null when none was declared.
  final String? stateCode;
  final String? stateName;
  final DateTime? declaredAt;
  final BillingStateSource? source;

  /// Where the request comes from, as the server's edge says — the same
  /// country `/geo/pricing` reads when the app sends none. Settings shows the
  /// State to an India account; the payment paths decide from the offer's
  /// own region instead, which is the one the plan is priced in.
  final bool isIndia;

  /// The State the edge's region points at, to PRE-SELECT the picker. Never
  /// saved on its own.
  final String? suggestedStateCode;

  /// A State is on record.
  bool get declared => !billingStateNeeded(isIndia: true, stateCode: stateCode);

  /// What the picker starts on: the State on record, else the edge's
  /// suggestion, else nothing.
  String? get preset =>
      isBillingStateCode(stateCode) ? stateCode : suggestedStateCode;
}

/// `PUT /user/billing-state` — the declaration the server saved.
class SavedBillingState {
  const SavedBillingState({
    required this.stateCode,
    required this.stateName,
    this.declaredAt,
    this.source,
  });

  /// THROWS on a body with no State: a save the server did not confirm is
  /// not one, and the caller says so rather than moving on.
  factory SavedBillingState.fromJson(Map<String, dynamic> json) {
    final String? code = _text(json['stateCode']);
    if (code == null) {
      throw StateError('user/billing-state returned no State');
    }
    final Object? declared = json['declaredAt'];
    return SavedBillingState(
      stateCode: code,
      stateName: _text(json['stateName']) ?? billingStateName(code) ?? code,
      declaredAt: declared is String ? DateTime.tryParse(declared) : null,
      source: BillingStateSource.parse(json['source']),
    );
  }

  final String stateCode;
  final String stateName;
  final DateTime? declaredAt;
  final BillingStateSource? source;
}

String? _text(Object? v) {
  if (v is! String) return null;
  final String t = v.trim();
  return t.isEmpty ? null : t;
}
