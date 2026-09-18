import 'package:flutter/material.dart';
import 'package:plexaverse/core/theme/plexaverse_colors.dart';
import 'package:plexaverse/core/theme/app_text_theme.dart';

/// Collapsible referral code input.
///
/// Shows a "+ Have a referral code?" link that expands into an outlined
/// TextField with a validity indicator.
class ReferralCodeField extends StatefulWidget {
  final TextEditingController controller;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final bool autoExpand;
  final bool isDark;

  const ReferralCodeField({
    super.key,
    required this.controller,
    this.errorText,
    this.onChanged,
    this.autoExpand = false,
    this.isDark = true,
  });

  @override
  State<ReferralCodeField> createState() => _ReferralCodeFieldState();
}

class _ReferralCodeFieldState extends State<ReferralCodeField>
    with SingleTickerProviderStateMixin {
  late bool _expanded;
  late AnimationController _animCtrl;
  late Animation<double> _sizeAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _expanded = widget.autoExpand;
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      value: _expanded ? 1.0 : 0.0,
    );
    _sizeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    if (_expanded) {
      _animCtrl.forward();
    } else {
      _animCtrl.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final code = widget.controller.text;
    final hasValidCode = code.length >= 4 && widget.errorText == null;
    final hasInvalidCode = code.isNotEmpty && widget.errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!_expanded)
          TextButton.icon(
            onPressed: _toggle,
            icon: const Icon(
              Icons.card_giftcard_outlined,
              size: 16,
              color: PlexaversePalette.primary,
            ),
            label: Text(
              'Have a referral code?',
              style: AppTextTheme.labelLarge.copyWith(
                color: PlexaversePalette.primary,
              ),
            ),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        SizeTransition(
          sizeFactor: _sizeAnim,
          child: FadeTransition(
            opacity: _fadeAnim,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: widget.controller,
                  onChanged: widget.onChanged,
                  textCapitalization: TextCapitalization.characters,
                  style: AppTextTheme.bodyLarge.copyWith(
                    color: widget.isDark ? PlexaversePalette.grey50 : PlexaversePalette.grey900,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Referral code (optional)',
                    floatingLabelBehavior: widget.isDark
                        ? null
                        : FloatingLabelBehavior.always,
                    hintText: widget.isDark ? null : 'e.g. FRIEND2024',
                    hintStyle: AppTextTheme.bodyLarge
                        .copyWith(color: PlexaversePalette.grey400),
                    prefixIcon:
                        const Icon(Icons.card_giftcard_outlined, size: 20),
                    prefixIconColor: PlexaversePalette.grey400,
                    suffixIcon: hasValidCode
                        ? const Icon(Icons.check_circle_outline,
                            color: PlexaversePalette.success)
                        : hasInvalidCode
                            ? const Icon(Icons.cancel_outlined,
                                color: PlexaversePalette.error)
                            : null,
                    errorText: widget.errorText,
                    filled: true,
                    fillColor: widget.isDark
                        ? Colors.white.withValues(alpha: 0.04)
                        : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: widget.isDark
                            ? Colors.white.withValues(alpha: 0.20)
                            : const Color(0x1F000000),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: widget.isDark
                            ? Colors.white.withValues(alpha: 0.20)
                            : const Color(0x1F000000),
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide:
                          BorderSide(color: PlexaversePalette.primary, width: 2),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide:
                          BorderSide(color: PlexaversePalette.error, width: 2),
                    ),
                    labelStyle: AppTextTheme.bodySmall.copyWith(
                      color: widget.isDark
                          ? PlexaversePalette.grey400
                          : PlexaversePalette.grey600,
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
