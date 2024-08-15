import 'package:flutter/material.dart';

import 'package:neu_social/Utils/size_config.dart';

class TextFieldCustom extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final FocusNode focusNode;
  final bool? password;
  final bool? autoFocus;

  const TextFieldCustom({
    super.key,
    required this.hintText,
    required this.controller,
    required this.validator,
    required this.focusNode,
    this.password,
    this.autoFocus,
  });

  @override
  State<TextFieldCustom> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<TextFieldCustom> {
  bool hasFocus = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      hasFocus = widget.focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: widget.validator,
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(6),
                vertical: getProportionateScreenHeight(2),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    width: hasFocus
                        ? getProportionateScreenWidth(1)
                        : getProportionateScreenWidth(.6),
                    color: state.hasError
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).disabledColor),
                // color: Colors.white,
              ),
              child: TextFormField(
                obscureText: widget.password ?? false,
                autofocus: false,
                controller: widget.controller,
                focusNode: widget.focusNode, // Set the focusNode here
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  contentPadding: const EdgeInsets.all(0),
                  border: InputBorder.none,
                ),
                onChanged: (value) => state.didChange(value),
              ),
            ),
            if (state.hasError)
              Text(
                state.errorText ?? "",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Theme.of(context).colorScheme.error),
              )
          ],
        );
      },
    );
  }
}
