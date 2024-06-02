import 'package:flutter/material.dart';

class DescriptionField extends StatelessWidget {
  final TextEditingController descriptionController;
  final String? Function(String?)? validator;
  final ValueChanged<String?>? onChanged;
  final FocusNode focusNode;
  final String? hint;
  const DescriptionField({
    super.key,
    required this.descriptionController,
    this.validator,
    this.onChanged,
    required this.focusNode,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        focusNode: focusNode,
        onChanged: onChanged,
        minLines: 1,
        maxLines: 12,
        validator: validator,
        decoration: InputDecoration(
          errorStyle: const TextStyle(height: 0),
          hintText: hint ?? "Enter your communities description",
          border: InputBorder.none,
        ),
        controller: descriptionController,
      ),
    );
  }
}
