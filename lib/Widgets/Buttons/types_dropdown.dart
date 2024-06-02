import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import 'package:neu_social/Utils/size_config.dart';

class CustomDropdownButton extends StatelessWidget {
  final List<String> items;
  final String? selectedItem;
  final ValueChanged<String?>? onChanged;

  const CustomDropdownButton({
    super.key,
    required this.items,
    this.selectedItem,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Row(
          children: [
            Expanded(
              child: Text(
                'Select a type',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).disabledColor,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        items: items
            .map((String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        value: selectedItem,
        onChanged: onChanged,
        buttonStyleData: ButtonStyleData(
          height: getProportionateScreenHeight(50.0),
          width: getProportionateScreenWidth(160),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(.5, .8),
                blurRadius: 2,
              )
            ],
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).canvasColor,
          ),
        ),
        iconStyleData: IconStyleData(
          icon: Icon(
            Icons.arrow_drop_down_rounded,
            color: Theme.of(context).disabledColor,
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Theme.of(context).canvasColor,
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
        ),
      ),
    );
  }
}
