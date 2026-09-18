import 'package:flutter/material.dart';
import 'package:plexaverse/core/theme/plexaverse_colors.dart';
import 'package:plexaverse/core/theme/app_text_theme.dart';

enum PasswordStrength { empty, tooShort, weak, good, strong }

extension PasswordStrengthX on PasswordStrength {
  double get fraction => switch (this) {
        PasswordStrength.empty => 0.0,
        PasswordStrength.tooShort => 0.33,
        PasswordStrength.weak => 0.50,
        PasswordStrength.good => 0.75,
        PasswordStrength.strong => 1.0,
      };

  Color get color => switch (this) {
        PasswordStrength.empty => Colors.transparent,
        PasswordStrength.tooShort => PlexaversePalette.error,
        PasswordStrength.weak => PlexaversePalette.warning,
        PasswordStrength.good => PlexaversePalette.warning,
        PasswordStrength.strong => PlexaversePalette.success,
      };

  String get label => switch (this) {
        PasswordStrength.empty => '',
        PasswordStrength.tooShort => 'Too short',
        PasswordStrength.weak => 'Weak',
        PasswordStrength.good => 'Good',
        PasswordStrength.strong => 'Strong',
      };
}

PasswordStrength computeStrength(String password) {
  if (password.isEmpty) return PasswordStrength.empty;
  if (password.length < 8) return PasswordStrength.tooShort;
  final hasUpper = password.contains(RegExp(r'[A-Z]'));
  final hasLower = password.contains(RegExp(r'[a-z]'));
  final hasDigit = password.contains(RegExp(r'[0-9]'));
  final hasSpecial = password.contains(RegExp(r'[^A-Za-z0-9]'));
  final complexity = (hasUpper ? 1 : 0) +
      (hasLower ? 1 : 0) +
      (hasDigit ? 1 : 0) +
      (hasSpecial ? 1 : 0);
  if (password.length >= 10 && complexity >= 3) return PasswordStrength.strong;
  if (complexity >= 2) return PasswordStrength.good;
  return PasswordStrength.weak;
}

class PasswordStrengthBar extends StatelessWidget {
  final String password;
  final bool isDark;

  const PasswordStrengthBar({
    super.key,
    required this.password,
    this.isDark = true,
  });

  @override
  Widget build(BuildContext context) {
    final strength = computeStrength(password);
    if (strength == PasswordStrength.empty) return const SizedBox.shrink();

    final trackColor = isDark
        ? Colors.white.withValues(alpha: 0.10)
        : const Color(0x1A000000); // rgba(0,0,0,0.10)

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              Container(
                height: 4,
                decoration: BoxDecoration(
                  color: trackColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              FractionallySizedBox(
                widthFactor: strength.fraction,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 4,
                  decoration: BoxDecoration(
                    color: strength.color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                strength.label,
                key: ValueKey(strength),
                style:
                    AppTextTheme.labelSmall.copyWith(color: strength.color),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
