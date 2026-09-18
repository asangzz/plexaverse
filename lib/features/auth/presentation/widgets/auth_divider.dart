import 'package:flutter/material.dart';
import 'package:plexaverse/core/theme/plexaverse_colors.dart';
import 'package:plexaverse/core/theme/app_text_theme.dart';

class AuthDivider extends StatelessWidget {
  final String label;
  final bool isDark;

  const AuthDivider({
    super.key,
    this.label = 'or continue with email',
    this.isDark = true,
  });

  @override
  Widget build(BuildContext context) {
    final lineColor = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : const Color(0x1F000000); // black/12 %

    return Row(
      children: [
        Expanded(child: Container(height: 1, color: lineColor)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label,
            style: AppTextTheme.labelSmall.copyWith(
              color: isDark ? PlexaversePalette.grey600 : PlexaversePalette.grey400,
            ),
          ),
        ),
        Expanded(child: Container(height: 1, color: lineColor)),
      ],
    );
  }
}
