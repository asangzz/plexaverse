import 'package:flutter/material.dart';
import 'package:plexaverse/core/theme/plexaverse_colors.dart';
import 'package:plexaverse/core/theme/app_text_theme.dart';

class FormErrorBanner extends StatelessWidget {
  final String message;
  final bool isDark;

  const FormErrorBanner({
    super.key,
    required this.message,
    this.isDark = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: PlexaversePalette.error.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: const BorderSide(color: PlexaversePalette.error, width: 3),
          right: BorderSide(color: PlexaversePalette.error.withValues(alpha: 0.20)),
          top: BorderSide(color: PlexaversePalette.error.withValues(alpha: 0.20)),
          bottom: BorderSide(color: PlexaversePalette.error.withValues(alpha: 0.20)),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: PlexaversePalette.error, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: AppTextTheme.bodyMedium.copyWith(
                color: isDark ? PlexaversePalette.grey50 : PlexaversePalette.grey900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
