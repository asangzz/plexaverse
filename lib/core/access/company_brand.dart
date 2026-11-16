import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The company brand is closed to new signups and whole for everyone on it.
///
/// A port of the web's `lib/company-brand.ts`; read it before changing this.
/// Accounts already running a company brand keep every feature they had, so
/// closing it is a VISIBILITY change, not a capability one — a hidden question
/// is not a dead feature, and the company path in onboarding stays intact.
///
/// It is not what keeps anyone out, either: the server drops a `brandType:
/// 'company'` write from an account that is not already one
/// (`user-preferences.service.ts`). This only stops the app asking a question
/// the server would ignore the answer to.
///
/// Reopening it is this one line, on both platforms.
const bool kCompanyBrandOpen = false;

/// [kCompanyBrandOpen], as a provider so a test can reopen it and walk the
/// company path, which no account can reach while it is closed.
final Provider<bool> companyBrandOpenProvider = Provider<bool>(
  (Ref ref) => kCompanyBrandOpen,
);
