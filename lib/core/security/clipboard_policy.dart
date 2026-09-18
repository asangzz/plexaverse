import 'package:flutter/services.dart';

/// Centralised clipboard policy (RULINGS §12 hardening). Widgets call into
/// this rather than touch `Clipboard` directly so the policy can be tightened
/// in one place.
///
/// Sensitive fields (password / token entry on the auth page) suppress the
/// clipboard entirely. For non-sensitive content the standard platform
/// behaviour is fine.
class ClipboardPolicy {
  const ClipboardPolicy._();

  /// Permitted copy for non-sensitive content (e.g. a referral code the user
  /// wants to share). Goes through this method so future logging / scrubbing
  /// rules apply uniformly.
  static Future<void> copyNonSensitive(String text) {
    return Clipboard.setData(ClipboardData(text: text));
  }

  /// Reads from the clipboard for a non-sensitive context (e.g. pasting a
  /// referral code into the sign-up field). Sensitive fields must not call
  /// this — they configure the underlying `TextField` to disable paste.
  static Future<String?> readNonSensitive() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    return data?.text;
  }

  /// Clears the system clipboard. Called by the AuthController on sign-out and
  /// on idle-timeout so any sensitive value that landed there earlier in
  /// the session doesn't outlive the user (§12).
  ///
  /// Both platforms accept an empty-string write as a clear.
  static Future<void> clear() {
    return Clipboard.setData(const ClipboardData(text: ''));
  }

  /// `TextInputFormatter` that strips any text inserted at once when its
  /// length differs from the previous selection by more than a single
  /// character — the heuristic that distinguishes a paste from a keystroke.
  /// Wire into `inputFormatters:` on a sensitive `TextField` to defang
  /// paste even if the OS context menu manages to display.
  static TextInputFormatter get blockPasteFormatter => _BlockPasteFormatter();
}

class _BlockPasteFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final added = newValue.text.length - oldValue.text.length;
    if (added > 1) return oldValue;
    return newValue;
  }
}
