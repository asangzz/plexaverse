/// Sealed failure hierarchy (§6). Repositories catch wire-level exceptions
/// once at the boundary and translate them into per-feature sealed result
/// types (e.g. `SignInResult`) or a single feature `Unavailable` exception;
/// consumers switch exhaustively so a new variant is a compile error at
/// every call site.
///
/// [Failure] is carried on `DioException.error` by [ErrorInterceptor]
/// (the single mapping point), so a repository reads `e.error` — never a
/// raw status code — when branching.
///
/// NOTE: fpdart's `Either<Failure, T>` is the documented intent, but the
/// codebase deliberately does NOT use `Either` — the real convention is the
/// sealed-result pattern described above.
sealed class Failure {
  const Failure({this.message, this.errorCode});

  /// Human-readable message safe to show the user, supplied by the backend
  /// rejection envelope (`{data, error, meta}` → `error.message`).
  final String? message;

  /// Stable string from the backend, drives client-side localisation and
  /// branching.
  final String? errorCode;
}

final class NetworkFailure extends Failure {
  const NetworkFailure({super.message, super.errorCode});
}

final class ServerFailure extends Failure {
  const ServerFailure({super.message, super.errorCode, this.statusCode});
  final int? statusCode;
}

/// 4xx that isn't 401/403/404/422 — a client-side problem the backend
/// rejected (e.g. 405 method not allowed, 410 gone, 415 unsupported media).
/// Kept distinct from [ServerFailure] so retry policies can ignore these.
final class ClientFailure extends Failure {
  const ClientFailure({super.message, super.errorCode, this.statusCode});
  final int? statusCode;
}

final class AuthFailure extends Failure {
  const AuthFailure({super.message, super.errorCode});
}

final class ValidationFailure extends Failure {
  const ValidationFailure({
    super.message,
    super.errorCode,
    this.fieldErrors = const <String, String>{},
  });
  final Map<String, String> fieldErrors;
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure({super.message, super.errorCode});
}

final class UnknownFailure extends Failure {
  const UnknownFailure({super.message, super.errorCode});
}
