import 'package:flutter/material.dart';
import 'package:neu_social/Widgets/Buttons/custom_button.dart';

class TestingScreen extends StatefulWidget {
  const TestingScreen({super.key});

  @override
  State<TestingScreen> createState() => _TestingScreenState();
}

class _TestingScreenState extends State<TestingScreen> {
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                controller: controller,
                hintText: 'Hint',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field cannot be empty';
                  }
                  return null;
                },
              ),
              CustomButton(
                color: Colors.red,
                radius: 12,
                height: 40,
                onTap: () {
                  // print('Hello');
                  if (formKey.currentState!.validate()) {
                    print('valid');
                  } else {
                    print('not valid');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.validator,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormField<String>(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: widget.validator,
          // onSaved: (value)=> customName = value,
          builder: (state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: widget.controller,
                        decoration:
                            const InputDecoration(hintText: "Custom Name"),
                        onChanged: (value) => state.didChange(value),
                      ),
                    ),
                    if (state.isValid) const Icon(Icons.check),
                    if (state.hasError)
                      const Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                  ],
                ),
                if (state.hasError)
                  Text(
                    state.errorText ?? "",
                    style: const TextStyle(color: Colors.red),
                  )
              ],
            );
          },
        ),
      ],
    );
  }
}
