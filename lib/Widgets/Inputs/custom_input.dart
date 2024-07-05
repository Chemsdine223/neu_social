import 'package:blur/blur.dart';
import 'package:flutter/material.dart';

import 'package:neu_social/Utils/size_config.dart';

class CustomTextField extends StatefulWidget {
  final ValueChanged<String?>? onChanged;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool? password;
  final bool? readOnly;
  final bool? autoFocus;
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
    this.autoFocus,
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
    return Stack(
      children: [
        Blur(
          blur: 2,
          blurColor: Theme.of(context).scaffoldBackgroundColor,
          child: Container(
            height: getProportionateScreenHeight(56),
            // color: Colors.red,
          ),
        ),
        SizedBox(
          child: TextFormField(
            autofocus: widget.autoFocus ?? false,
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
        ),
      ],
    );
  }
}
