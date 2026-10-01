import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shakemywidget/flutter_shakemywidget.dart';

class InputField extends StatefulWidget {
  final TextEditingController controller;
  final String? title;
  final String? hintText;
  final IconData? icon;
  final TextInputType? type;
  final String? Function(String?)? validator;
  final bool isPassword;
  final bool enabled;
  final bool curved;
  final Color? color;
  final TextStyle? titleStyle;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final TextStyle? errorStyle;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final double verticalPadding;
  final TextCapitalization textCapitalization;
  final Widget? suffixIcon;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final int? maxLines;
  final int? minLines;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final bool autofocus;
  final FocusNode? focusNode;
  final int shakeCount;
  final double shakeOffset;
  final Duration shakeDuration;

  const InputField({
    super.key,
    required this.controller,
    this.title,
    this.hintText,
    this.icon,
    this.type,
    this.validator,
    this.isPassword = false,
    this.enabled = true,
    this.curved = false,
    this.color,
    this.titleStyle,
    this.hintStyle,
    this.textStyle,
    this.errorStyle,
    this.autofillHints,
    this.inputFormatters,
    this.verticalPadding = 0,
    this.textCapitalization = TextCapitalization.none,
    this.suffixIcon,
    this.borderRadius,
    this.contentPadding,
    this.maxLines = 1,
    this.minLines,
    this.textInputAction,
    this.onChanged,
    this.onFieldSubmitted,
    this.autofocus = false,
    this.focusNode,
    this.shakeCount = 3,
    this.shakeOffset = 8,
    this.shakeDuration = const Duration(milliseconds: 400),
  });

  @override
  State<InputField> createState() => InputFieldState();
}

class InputFieldState extends State<InputField> {
  final _shakeKey = GlobalKey<ShakeWidgetState>();
  final _fieldKey = GlobalKey<FormFieldState<String>>();
  String? _errorText;
  bool _isObscured = true;

  String? validate(String? value, {bool shake = false}) {
    final error = widget.validator?.call(value);
    setState(() => _errorText = error);
    if (shake && error != null && !MediaQuery.disableAnimationsOf(context)) {
      _shakeKey.currentState?.shake();
    }
    return error;
  }

  String? validateAndShake(String? value) => validate(value, shake: true);

  void reset() {
    _fieldKey.currentState?.reset();
    widget.controller.clear();
    setState(() {
      _errorText = null;
      _isObscured = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final defaultTitleStyle =
        theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600) ??
        const TextStyle(fontWeight: FontWeight.w600, fontSize: 13);
    final defaultTextStyle =
        theme.textTheme.bodyMedium ?? const TextStyle(fontSize: 15);
    final defaultErrorStyle =
        theme.textTheme.bodySmall?.copyWith(color: colors.error) ??
        TextStyle(color: colors.error, fontSize: 12);
    final resolvedBorderRadius =
        widget.borderRadius ?? BorderRadius.circular(widget.curved ? 30 : 12);
    Widget? resolvedSuffix;
    if (widget.isPassword) {
      final passwordToggle = IconButton(
        tooltip: _isObscured ? 'Show password' : 'Hide password',
        icon: Icon(_isObscured ? Icons.visibility_off : Icons.visibility),
        onPressed: () => setState(() => _isObscured = !_isObscured),
      );
      if (widget.suffixIcon != null) {
        resolvedSuffix = Row(
          mainAxisSize: MainAxisSize.min,
          children: [widget.suffixIcon!, passwordToggle],
        );
      } else {
        resolvedSuffix = passwordToggle;
      }
    } else {
      resolvedSuffix = widget.suffixIcon;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 6),
            child: Text(
              widget.title!,
              style: widget.titleStyle ?? defaultTitleStyle,
            ),
          ),
        ShakeMe(
          key: _shakeKey,
          shakeCount: widget.shakeCount,
          shakeOffset: widget.shakeOffset,
          shakeDuration: widget.shakeDuration,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: widget.verticalPadding),
            decoration: BoxDecoration(
              color: widget.color ?? colors.surfaceContainerHighest,
              borderRadius: resolvedBorderRadius,
              border: Border.all(
                color: _errorText == null ? Colors.transparent : colors.error,
              ),
            ),
            child: TextFormField(
              key: _fieldKey,
              controller: widget.controller,
              validator: validateAndShake,
              errorBuilder: (context, error) => const SizedBox.shrink(),
              focusNode: widget.focusNode,
              autofocus: widget.autofocus,
              textAlignVertical: TextAlignVertical.center,
              enabled: widget.enabled,
              maxLines: widget.isPassword ? 1 : widget.maxLines,
              minLines: widget.isPassword ? 1 : widget.minLines,
              textInputAction: widget.textInputAction,
              textCapitalization: widget.textCapitalization,
              inputFormatters: widget.inputFormatters,
              autofillHints: widget.autofillHints,
              onTapOutside: (_) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
                _fieldKey.currentState?.validate();
              },
              onChanged: (value) {
                validate(value);
                widget.onChanged?.call(value);
              },
              onFieldSubmitted: widget.onFieldSubmitted,
              style: widget.textStyle ?? defaultTextStyle,
              keyboardType: widget.type,
              obscureText: widget.isPassword && _isObscured,
              enableSuggestions: !widget.isPassword,
              autocorrect: !widget.isPassword,
              decoration: InputDecoration(
                isDense: true,
                contentPadding:
                    widget.contentPadding ??
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                hintText: widget.hintText,
                hintStyle: widget.hintStyle,
                suffixIcon: resolvedSuffix,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 36,
                  minHeight: 48,
                ),
                prefixIcon: widget.icon == null
                    ? null
                    : Padding(
                        padding: const EdgeInsets.only(left: 12, right: 4),
                        child: Icon(widget.icon, size: 20),
                      ),
              ),
            ),
          ),
        ),
        if (_errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 6, top: 5),
            child: Semantics(
              liveRegion: true,
              child: Text(
                _errorText!,
                style: widget.errorStyle ?? defaultErrorStyle,
              ),
            ),
          ),
      ],
    );
  }
}
