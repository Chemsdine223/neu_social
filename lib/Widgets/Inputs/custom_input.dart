import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final ValueChanged<String?>? onChanged;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool? password;
  final bool? readOnly;
  final String hintText;

  final Widget? icon;
  final TextEditingController controller;

  const CustomTextField({
    super.key,
    this.onChanged,
    this.keyboardType,
    this.validator,
    this.password,
    this.readOnly,
    required this.hintText,
    this.icon,
    required this.controller,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        readOnly: widget.readOnly ?? false,
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: widget.hintText,
          suffix: widget.icon,
        ),
        obscureText: widget.password ?? false,
        keyboardType: widget.keyboardType,
        onChanged: widget.onChanged,
        validator: widget.validator,
      ),
    );
  }
}
