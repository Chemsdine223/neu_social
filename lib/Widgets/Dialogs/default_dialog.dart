import 'package:flutter/material.dart';

import 'package:neu_social/Utils/size_config.dart';

class DefaultDialog extends StatefulWidget {
  final String message;
  const DefaultDialog({
    super.key,
    required this.message,
  });

  @override
  State<DefaultDialog> createState() => _DefaultDialogState();
}

class _DefaultDialogState extends State<DefaultDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      title: Text(
        'Neu Social',
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
      ),
      content: SizedBox(
        // color: Colors.white,
        height: getProportionateScreenHeight(200),
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(70)),
            Text(
              widget.message,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  // fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
