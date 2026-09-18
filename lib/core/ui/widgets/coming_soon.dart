import 'package:flutter/material.dart';

/// Standard snack for actions whose module hasn't landed yet. Keeps the stub
/// behaviour identical across screens. The caller supplies the localized
/// copy (the finalized Plexaverse l10n has no single generic "coming soon"
/// key — feature strings like `googleComingSoon` are passed in instead).
///
/// Ported from the ProHealth reference (`core/ui/widgets/coming_soon.dart`);
/// re-parameterised for the Plexaverse l10n key layout.
void showComingSoon(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
