import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neu_social/Constants/constants.dart';
import 'package:neu_social/Logic/navigation_cubit.dart';
import 'package:neu_social/Utils/size_config.dart';
import 'package:neu_social/Widgets/Buttons/custom_button.dart';
import 'package:neu_social/Widgets/Inputs/custom_input.dart';

class CreateCommunity extends StatefulWidget {
  const CreateCommunity({super.key});

  @override
  State<CreateCommunity> createState() => _CreateCommunityState();
}

class _CreateCommunityState extends State<CreateCommunity> {
  Set<String> selectedInterests = <String>{};
  final nameController = TextEditingController();

  String? selectedType;
  List<String> types = ["Private", "Event-based", "Invitation-based", "Paid"];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BottomSheetNavigationCubit, BottomSheetStatus>(
      listener: (context, state) {
        if (state == BottomSheetStatus.closed) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Container(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(12)),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height -
              getProportionateScreenHeight(40),
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // SizedBox(height: getProportionateScreenHeight(60)),
                CustomTextField(
                    onChanged: (value) {},
                    validator: (value) {
                      return null;
                    },
                    password: false,
                    hintText: "Enter your communities name",
                    controller: nameController),
                SizedBox(height: getProportionateScreenHeight(20)),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: interests.map((interest) {
                    final isSelected = selectedInterests.contains(interest);
                    return ChoiceChip(
                      selectedColor: Colors.green,
                      checkmarkColor: Colors.white,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedInterests.add(interest);
                          } else {
                            selectedInterests.remove(interest);
                          }
                        });
                      },
                      label: Text(interest),
                      selected: isSelected,
                    );
                  }).toList(),
                ),
                SizedBox(height: getProportionateScreenHeight(12)),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: getProportionateScreenHeight(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: _typesDropDown(context)),
                    ],
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(12)),
                CustomButton(
                    label: Text(
                      'Create community',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    color: Theme.of(context).colorScheme.secondary,
                    radius: 12,
                    height: getProportionateScreenHeight(42))
              ],
            ),
          ),
        );
      },
    );
  }

  DropdownButtonHideUnderline _typesDropDown(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Row(
          children: [
            Expanded(
              child: Text(
                'Community type',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).disabledColor,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        items: types
            .map((String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.black,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        value: selectedType,
        onChanged: (String? value) {
          setState(() {
            selectedType = value;
          });
        },
        buttonStyleData: ButtonStyleData(
          height: getProportionateScreenHeight(50),
          width: getProportionateScreenWidth(160),
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(.5, .8),
                blurRadius: 2,
              )
            ],
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          // elevation: 2,
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(
            Icons.arrow_drop_down_rounded,
          ),
          // iconSize: 14,
        ),
        dropdownStyleData: DropdownStyleData(
          // maxHeight: 200,
          // width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.white,
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          // padding:
          //     EdgeInsets.only(left: 14, right: 14),
        ),
      ),
    );
  }
}
