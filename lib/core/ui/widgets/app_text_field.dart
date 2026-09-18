import 'package:flutter/material.dart';

import '../app_icons.dart';

/// A labelled text field with an optional obscure-toggle for passwords and
/// an optional prefix icon. Decoration (fill, border, radius, focus ring)
/// comes from the global `InputDecorationTheme` in `AppTheme`.
///
/// Ported from `lib/presentation/common/widgets/app_text_field.dart`;
/// behaviour unchanged, the obscure-toggle glyphs swapped to [AppIcons] so
/// the field draws from the single icon vocabulary.
class AppTextField extends StatefulWidget {
  const AppTextField({
    required this.label,
    this.hint,
    this.errorText,
    this.controller,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.onEditingComplete,
    this.prefixIcon,
    this.maxLines = 1,
    super.key,
  });

  final String label;
  final String? hint;
  final String? errorText;
  final TextEditingController? controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final IconData? prefixIcon;
  final int maxLines;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.isPassword && _obscure,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      onChanged: widget.onChanged,
      onEditingComplete: widget.onEditingComplete,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        errorText: widget.errorText,
        prefixIcon:
            widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(_obscure ? AppIcons.eyeSlash : AppIcons.eye),
                onPressed: () => setState(() => _obscure = !_obscure),
              )
            : null,
      ),
    );
  }
}
