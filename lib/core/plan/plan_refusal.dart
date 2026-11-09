import 'package:dio/dio.dart' show DioException;
import 'package:intl/intl.dart';

import '../network/failure.dart';

/// Why the plan said no.
enum PlanRefusalKind {
  /// No subscription and no 30-day pass. The remedy is a plan; retrying the
  /// same request can never work.
  needsPlan,

  /// The plan covers this feature, but its daily or monthly allowance is used
  /// up. The remedy is waiting until [PlanRefusal.resetsAt].
  limitReached,
}

/// A refusal from the plan gate, parsed out of the mobile envelope.
///
/// ## Why this exists
///
/// AI features used to be paid for in wallet XP, and every slice grew its own
/// "insufficient XP" branch around a 402 `INSUFFICIENT_XP`. Wallet XP is
/// retired (10 Nov 2026): the plan pays, with per-feature limits. The server
/// now refuses in exactly two ways, both HTTP 402:
///
///   • `INSUFFICIENT_XP` with `details.reason == 'NOT_ENTITLED'` — no plan.
///     The code name is kept only so old builds still stop and show a
///     message; it means "needs a plan", never "needs XP".
///   • `LIMIT_REACHED` with `details { key, limit, period, used, resetsAt }`.
///
/// One parser here means each slice asks one question ("was this the plan?")
/// instead of re-reading the raw body, and none of them can drift back into
/// calling either case "XP".
class PlanRefusal {
  const PlanRefusal({
    required this.kind,
    required this.message,
    this.upgradeUrl,
    this.key,
    this.limit,
    this.period,
    this.used,
    this.resetsAt,
  });

  /// Wire code for "no plan". Name kept for old builds — see the class doc.
  static const String notEntitledCode = 'INSUFFICIENT_XP';

  /// Wire code for "this feature's allowance is used up".
  static const String limitReachedCode = 'LIMIT_REACHED';

  final PlanRefusalKind kind;

  /// Safe to show. The server's own copy when it sent one: it names the
  /// feature, which nothing on this side can do as well.
  final String message;

  /// `details.upgradeUrl` on a no-plan refusal. The app routes to its own
  /// pricing page instead; kept so a caller can tell the two apart in logs.
  final String? upgradeUrl;

  /// The allowance key (e.g. `ai_generate_post`) on a limit refusal.
  final String? key;
  final int? limit;

  /// `'day'` or `'month'`, counted on India time by the server.
  final String? period;
  final int? used;

  /// When the allowance comes back, as an absolute instant (UTC from the
  /// wire). Shown in the device's local time: the server counts days on
  /// India time, but the user reads a clock where they are.
  final DateTime? resetsAt;

  bool get needsPlan => kind == PlanRefusalKind.needsPlan;
  bool get isLimit => kind == PlanRefusalKind.limitReached;

  /// Reads a refusal out of any error a repository might catch: a
  /// [DioException] (whose response still carries the raw envelope), or a
  /// raw envelope map. Anything else, or any other error code, is null.
  static PlanRefusal? fromError(Object? error) {
    if (error is PlanRefusal) return error;
    if (error is DioException) return fromDioException(error);
    if (error is Map) return fromEnvelope(error);
    return null;
  }

  /// The [DioException] path. The interceptor maps a 402 to a
  /// [ClientFailure] and drops `details`, so the details are read from the
  /// response body; the [Failure]'s code is the fallback for a body some
  /// earlier layer has already unwrapped.
  static PlanRefusal? fromDioException(DioException e) {
    final PlanRefusal? fromBody = fromEnvelope(
      e.response?.data,
      status: e.response?.statusCode,
    );
    if (fromBody != null) return fromBody;
    final Object? inner = e.error;
    if (inner is Failure) {
      return _build(code: inner.errorCode, message: inner.message);
    }
    return null;
  }

  /// The envelope path: `{ data: null, error: { code, message, details } }`.
  ///
  /// A top-level `code` is accepted too, for a body that arrives already
  /// unwrapped to the inner error object.
  static PlanRefusal? fromEnvelope(Object? body, {int? status}) {
    if (body is! Map) return null;
    final Object? nested = body['error'];
    final Map<dynamic, dynamic> error = nested is Map ? nested : body;
    final Object? code = error['code'] ?? error['errorCode'];
    final Object? message = error['message'];
    final Object? details = error['details'];
    return _build(
      code: code is String ? code : null,
      message: message is String ? message : null,
      details: details is Map ? details : null,
    );
  }

  static PlanRefusal? _build({
    required String? code,
    required String? message,
    Map<dynamic, dynamic>? details,
  }) {
    final String? text = (message == null || message.trim().isEmpty)
        ? null
        : message.trim();
    switch (code) {
      case notEntitledCode:
        // Every INSUFFICIENT_XP is a plan refusal now, with or without
        // `reason`: wallet XP no longer exists, so there is nothing else it
        // could mean.
        final Object? url = details?['upgradeUrl'];
        return PlanRefusal(
          kind: PlanRefusalKind.needsPlan,
          message: text ?? 'This needs a Plexaverse plan.',
          upgradeUrl: url is String ? url : null,
        );
      case limitReachedCode:
        final Object? key = details?['key'];
        final Object? period = details?['period'];
        final Object? resets = details?['resetsAt'];
        return PlanRefusal(
          kind: PlanRefusalKind.limitReached,
          message: text ?? _defaultLimitMessage(period),
          key: key is String ? key : null,
          limit: _int(details?['limit']),
          period: period is String ? period : null,
          used: _int(details?['used']),
          resetsAt: resets is String ? DateTime.tryParse(resets) : null,
        );
      default:
        return null;
    }
  }

  static String _defaultLimitMessage(Object? period) => period == 'month'
      ? "You've used this month's limit for this."
      : "You've used today's limit for this.";

  static int? _int(Object? v) => v is num ? v.toInt() : null;

  /// "Back at 5:30 AM", "Back tomorrow at 5:30 AM" or "Back on 1 Dec" —
  /// null when the server sent no reset time.
  ///
  /// Relative to [now] in the device's zone, so the same instant reads
  /// correctly wherever the user is. [now] is injectable for tests.
  String? backAtLabel({DateTime? now}) {
    final DateTime? at = resetsAt;
    if (at == null) return null;
    final DateTime local = at.toLocal();
    final DateTime today = _day(now?.toLocal() ?? DateTime.now());
    // Rounded hours, not `inDays`: across a DST change two midnights are
    // 23 or 25 hours apart, and `inDays` would call tomorrow "today".
    final int days = (_day(local).difference(today).inHours / 24).round();
    final String time = DateFormat('h:mm a').format(local);
    if (days <= 0) return 'Back at $time';
    if (days == 1) return 'Back tomorrow at $time';
    return 'Back on ${DateFormat('d MMM').format(local)}';
  }

  static DateTime _day(DateTime t) => DateTime(t.year, t.month, t.day);

  /// One line for surfaces that have room only for text (an inline error, a
  /// snackbar): the message, plus when a limit comes back.
  String displayMessage({DateTime? now}) {
    final String? back = isLimit ? backAtLabel(now: now) : null;
    if (back == null) return message;
    final String sep = RegExp(r'[.!?]$').hasMatch(message) ? ' ' : '. ';
    return '$message$sep$back.';
  }

  @override
  String toString() => 'PlanRefusal(${kind.name}, $key): $message';
}
