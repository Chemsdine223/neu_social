import 'package:flutter/material.dart';
import 'package:neu_social/Utils/size_config.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final FocusNode focusNode;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.validator,
    required this.focusNode,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
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
                // vertical: getProportionateScreenHeight(4),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  width: hasFocus
                      ? getProportionateScreenWidth(1)
                      : getProportionateScreenWidth(.5),
                  color: state.hasError
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).disabledColor,
                ),
                color: Theme.of(context).canvasColor,
              ),
              child: TextFormField(
                autofocus: true,
                controller: widget.controller,
                focusNode: widget.focusNode, // Set the focusNode here
                decoration: InputDecoration(
                    suffixIcon: const Icon(Icons.search),
                    contentPadding: EdgeInsets.only(
                      top: getProportionateScreenHeight(10),
                    ),
                    border: InputBorder.none,
                    hintText: widget.hintText),
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
