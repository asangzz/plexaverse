import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/ui/zave/zave_kit.dart';

/// The collapsible referral-code input on the create-account form.
///
/// Mobile-only by necessity: the web takes the code from the `?ref=` query
/// parameter on `/login` and never shows a field, which a phone app opened from
/// the store has no way to receive. The affordance therefore has no web
/// counterpart to match — only Zave's grammar to obey, which it does by being a
/// full-pill ghost button that expands into an ordinary [ZaveField].
///
/// Behaviour is unchanged from the pre-alignment widget; only the skin moved.
class ReferralCodeField extends StatefulWidget {
  const ReferralCodeField({
    required this.controller,
    this.errorText,
    this.onChanged,
    this.autoExpand = false,
    super.key,
  });

  final TextEditingController controller;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final bool autoExpand;

  @override
  State<ReferralCodeField> createState() => _ReferralCodeFieldState();
}

class _ReferralCodeFieldState extends State<ReferralCodeField>
    with SingleTickerProviderStateMixin {
  late bool _expanded = widget.autoExpand;

  late final AnimationController _anim = AnimationController(
    vsync: this,
    duration: ZaveMotion.fast,
    value: _expanded ? 1 : 0,
  );

  late final Animation<double> _curve = CurvedAnimation(
    parent: _anim,
    curve: ZaveMotion.curve,
  );

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  void _expand() {
    if (_expanded) return;
    setState(() => _expanded = true);
    _anim.forward();
  }

  /// Uppercases as the user types. The old field used
  /// `textCapitalization: characters`, which only hints the soft keyboard —
  /// a hardware keyboard or a paste slipped lower case through, and the codes
  /// are compared case-sensitively server-side.
  static final TextInputFormatter _upperCase = TextInputFormatter.withFunction(
    (TextEditingValue _, TextEditingValue next) =>
        next.copyWith(text: next.text.toUpperCase()),
  );

  @override
  Widget build(BuildContext context) {
    final String code = widget.controller.text;
    final bool valid = code.length >= 4 && widget.errorText == null;
    final bool invalid = code.isNotEmpty && widget.errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (!_expanded)
          ZaveButton(
            label: 'Have a referral code?',
            onPressed: _expand,
            icon: const Icon(Icons.card_giftcard_outlined),
          ),
        SizeTransition(
          sizeFactor: _curve,
          child: FadeTransition(
            opacity: _curve,
            child: ZaveField(
              controller: widget.controller,
              label: 'Referral code (optional)',
              hint: 'e.g. FRIEND2024',
              error: widget.errorText,
              onChanged: widget.onChanged,
              inputFormatters: <TextInputFormatter>[_upperCase],
              prefix: const Icon(Icons.card_giftcard_outlined),
              suffix: valid
                  // Green is "done" in Zave; amber carries the failure,
                  // because the palette has no red.
                  ? const Icon(
                      Icons.check_circle_outline,
                      color: ZaveColors.green,
                    )
                  : invalid
                  ? const Icon(Icons.error_outline, color: ZaveColors.amber)
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
