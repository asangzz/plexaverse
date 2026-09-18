import 'package:flutter/material.dart';

import '../../../../core/ui/zave/zave_kit.dart';

/// How strong the typed password is. Unchanged from the pre-alignment widget —
/// [computeStrength] is behaviour, and this restyle is presentation only.
enum PasswordStrength { empty, tooShort, weak, good, strong }

extension PasswordStrengthX on PasswordStrength {
  double get fraction => switch (this) {
    PasswordStrength.empty => 0.0,
    PasswordStrength.tooShort => 0.33,
    PasswordStrength.weak => 0.50,
    PasswordStrength.good => 0.75,
    PasswordStrength.strong => 1.0,
  };

  /// The status colour.
  ///
  /// **Zave has no red**, so the two failing steps are [ZaveColors.amber]
  /// rather than the old `PlexaversePalette.error`. The passing steps are the
  /// palette's two greens: [ZaveColors.mint] is green tuned to stay legible on
  /// a dark surface, so it carries "good", and [ZaveColors.green] — the token
  /// that means done — carries "strong".
  Color get color => switch (this) {
    PasswordStrength.empty => ZaveColors.rule,
    PasswordStrength.tooShort => ZaveColors.amber,
    PasswordStrength.weak => ZaveColors.amber,
    PasswordStrength.good => ZaveColors.mint,
    PasswordStrength.strong => ZaveColors.green,
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
  final bool hasUpper = password.contains(RegExp(r'[A-Z]'));
  final bool hasLower = password.contains(RegExp(r'[a-z]'));
  final bool hasDigit = password.contains(RegExp(r'[0-9]'));
  final bool hasSpecial = password.contains(RegExp(r'[^A-Za-z0-9]'));
  final int complexity =
      (hasUpper ? 1 : 0) +
      (hasLower ? 1 : 0) +
      (hasDigit ? 1 : 0) +
      (hasSpecial ? 1 : 0);
  if (password.length >= 10 && complexity >= 3) return PasswordStrength.strong;
  if (complexity >= 2) return PasswordStrength.good;
  return PasswordStrength.weak;
}

/// The strength meter under the create-account password field.
///
/// A four-logical-pixel track ([ZaveSpace.xs] — Zave pins no meter height, and
/// this is the nearest token to the web's 3px progress rail) with a full-pill
/// fill and the word for the current step on the right.
class PasswordStrengthBar extends StatelessWidget {
  const PasswordStrengthBar({required this.password, super.key});

  final String password;

  @override
  Widget build(BuildContext context) {
    final PasswordStrength strength = computeStrength(password);
    if (strength == PasswordStrength.empty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: ZaveSpace.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ClipRRect(
            borderRadius: ZaveRadius.pillBr,
            child: Stack(
              children: <Widget>[
                Container(height: ZaveSpace.xs, color: ZaveColors.rule),
                FractionallySizedBox(
                  widthFactor: strength.fraction,
                  child: AnimatedContainer(
                    duration: ZaveMotion.fast,
                    curve: ZaveMotion.curve,
                    height: ZaveSpace.xs,
                    color: strength.color,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: ZaveSpace.xs),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              strength.label,
              style: ZaveType.caption.copyWith(color: strength.color),
            ),
          ),
        ],
      ),
    );
  }
}
