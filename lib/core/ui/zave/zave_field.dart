import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/zave/zave.dart';

/// A Zave text field.
///
/// **Focus brightens the border — it never draws a platform focus ring.** The
/// Material [InputDecorator] machinery is bypassed entirely (all borders set to
/// [InputBorder.none], the container drawn by hand) because its focus/error
/// treatments are not Zave's and cannot be fully suppressed by theming.
class ZaveField extends StatefulWidget {
  const ZaveField({
    this.controller,
    this.label,
    this.hint,
    this.helper,
    this.error,
    this.obscure = false,
    this.enabled = true,
    this.pill = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.autofillHints,
    this.prefix,
    this.suffix,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.autofocus = false,
    super.key,
  });

  final TextEditingController? controller;

  /// Rendered above the field as a `.kicker`. Zave has no floating label.
  final String? label;

  final String? hint;
  final String? helper;

  /// Non-null puts the field in its error state: the border turns amber and the
  /// message replaces [helper]. Amber, not red — red is not in this palette.
  final String? error;

  final bool obscure;
  final bool enabled;

  /// `.fieldPill` — the full-pill variant used for search and single-line entry.
  final bool pill;

  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final List<String>? autofillHints;
  final Widget? prefix;
  final Widget? suffix;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  State<ZaveField> createState() => _ZaveFieldState();
}

class _ZaveFieldState extends State<ZaveField> {
  late final FocusNode _node = widget.focusNode ?? FocusNode();
  bool _ownsNode = false;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _ownsNode = widget.focusNode == null;
    _node.addListener(_onFocus);
  }

  void _onFocus() {
    if (_node.hasFocus != _focused) {
      setState(() => _focused = _node.hasFocus);
    }
  }

  @override
  void dispose() {
    _node.removeListener(_onFocus);
    if (_ownsNode) _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasError = widget.error != null;

    final Color border = hasError
        ? ZaveColors.amber
        : (_focused ? ZaveGlass.inputBorderFocused : ZaveColors.rule);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (widget.label != null) ...<Widget>[
          Text(widget.label!.toUpperCase(), style: ZaveType.kicker),
          SizedBox(height: ZaveSpace.sm),
        ],
        AnimatedContainer(
          duration: ZaveMotion.fast,
          curve: ZaveMotion.curve,
          padding: widget.pill ? ZaveSpace.fieldPad : ZaveSpace.inputPad,
          decoration: BoxDecoration(
            color: ZaveGlass.controlFill,
            border: Border.all(color: border, width: 1),
            borderRadius: widget.pill
                ? ZaveRadius.pillBr
                : BorderRadius.circular(ZaveRadius.cardSm),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if (widget.prefix != null) ...<Widget>[
                IconTheme.merge(
                  data: const IconThemeData(color: ZaveColors.ink45, size: 20),
                  child: widget.prefix!,
                ),
                SizedBox(width: ZaveSpace.md),
              ],
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _node,
                  enabled: widget.enabled,
                  obscureText: widget.obscure,
                  maxLines: widget.obscure ? 1 : widget.maxLines,
                  minLines: widget.minLines,
                  maxLength: widget.maxLength,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  inputFormatters: widget.inputFormatters,
                  autofillHints: widget.autofillHints,
                  autofocus: widget.autofocus,
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted,
                  cursorColor: ZaveColors.white,
                  style: ZaveType.body.copyWith(color: ZaveColors.white),
                  decoration: InputDecoration(
                    isDense: true,
                    counterText: '',
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    hintText: widget.hint,
                    hintStyle: ZaveType.body.copyWith(color: ZaveColors.ink35),
                  ),
                ),
              ),
              if (widget.suffix != null) ...<Widget>[
                SizedBox(width: ZaveSpace.md),
                IconTheme.merge(
                  data: const IconThemeData(color: ZaveColors.ink45, size: 20),
                  child: widget.suffix!,
                ),
              ],
            ],
          ),
        ),
        if (hasError || widget.helper != null) ...<Widget>[
          SizedBox(height: ZaveSpace.sm),
          Text(
            widget.error ?? widget.helper!,
            style: ZaveType.caption.copyWith(
              color: hasError ? ZaveColors.amber : ZaveColors.ink50,
            ),
          ),
        ],
      ],
    );
  }
}
