import 'package:flutter/material.dart';

import 'package:neu_social/Theme/colors/color_palettes.dart';

class DescriptionField extends StatelessWidget {
  final TextEditingController descriptionController;
  final String? Function(String?)? validator;
  final ValueChanged<String?>? onChanged;
  final FocusNode focusNode;
  const DescriptionField({
    super.key,
    required this.descriptionController,
    this.validator,
    this.onChanged,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: ColorPalettes().lightsurfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        focusNode: focusNode,
        onChanged: onChanged,
        minLines: 1,
        maxLines: 12,
        validator: validator,
        decoration: const InputDecoration(
          errorStyle: TextStyle(height: 0),
          hintText: "Enter your communities description",
          border: InputBorder.none,
        ),
        controller: descriptionController,
      ),
    );
  }
}
