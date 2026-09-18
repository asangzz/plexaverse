/// Masks an email's local part for display — `maggie@example.com` →
/// `m••••e@example.com`. Short local parts degrade gracefully; non-email
/// input is returned unchanged.
///
/// Used where we echo the address a code/link was sent to without exposing
/// the full identifier in plaintext UI.
String maskEmail(String email) {
  final at = email.indexOf('@');
  if (at <= 0) return email;
  final local = email.substring(0, at);
  final domain = email.substring(at);
  if (local.length <= 2) return '${local[0]}••••$domain';
  return '${local[0]}••••${local[local.length - 1]}$domain';
}
