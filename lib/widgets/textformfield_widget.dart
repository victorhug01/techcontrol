import 'package:flutter/material.dart';
import 'package:techcontrol/app/theme.dart';

class TextFormFieldWidget extends StatefulWidget {
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final bool? enable;
  final String? labelText;
  final Widget? iconPrefix;
  final IconButton? iconSuffix;
  final bool obscure;
  final bool autofocus;
  final String? Function(String?)? validator;
  final TextInputType inputType;
  final TextEditingController controller;
  final InputBorder inputBorderType;
  final double sizeInputBorder;
  final Color? colorBorderInput;
  final double? paddingLeftInput;
  final bool? filled;
  final Color? fillColor;

  const TextFormFieldWidget({
    super.key,
    required this.controller,
    this.labelText,
    this.validator,
    required this.inputType,
    required this.obscure,
    this.iconPrefix,
    this.iconSuffix,
    required this.autofocus,
    required this.inputBorderType,
    required this.sizeInputBorder,
    this.colorBorderInput,
    this.paddingLeftInput,
    this.enable,
    this.onChanged,
    this.hintText,
    this.filled,
    this.fillColor, 
  });

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  @override
  Widget build(BuildContext context) {
    final borderSideStyle = widget.inputBorderType.copyWith(
      borderSide: BorderSide(
        color: widget.colorBorderInput ?? AppTheme.lightTheme.colorScheme.secondary,
        width: widget.sizeInputBorder,
      ),
    );
    return TextFormField(
      cursorColor: AppTheme.lightTheme.colorScheme.secondary,
      onChanged: widget.onChanged ?? (String? value) {},
      enabled: widget.enable ?? true,
      autofocus: widget.autofocus,
      keyboardType: widget.inputType,
      obscureText: widget.obscure,
      controller: widget.controller,
      style: TextStyle(
        color: AppTheme.lightTheme.colorScheme.surface
      ),
      decoration: InputDecoration(
        fillColor: widget.fillColor,
        filled: widget.filled ?? false,
        hintText: widget.hintText,
        prefixIcon: widget.iconPrefix,
        suffixIcon: widget.iconSuffix,
        labelText: widget.labelText,
        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: widget.paddingLeftInput ?? 20.0),
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
        enabledBorder: borderSideStyle,
        focusedBorder: borderSideStyle,
        border: borderSideStyle,
        errorStyle: const TextStyle(height: 1.1),
        helperText: ' ',
      ),
      validator: widget.validator,
    );
  }
}