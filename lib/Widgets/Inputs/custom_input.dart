import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final ValueChanged<String?> onChanged;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool password;
  final String hintText;
  final TextEditingController controller;

  const CustomTextField({
    super.key,
    required this.onChanged,
    this.keyboardType,
    required this.validator,
    required this.password,
    required this.hintText,
    required this.controller,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // color: Colors.white,
      child: TextFormField(
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: widget.hintText,
        ),
        obscureText: widget.password,
        keyboardType: widget.keyboardType,
        onChanged: widget.onChanged,
        validator: widget.validator,
      ),
    );
  }
}
