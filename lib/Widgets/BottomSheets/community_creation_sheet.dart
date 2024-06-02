import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neu_social/Constants/constants.dart';
import 'package:neu_social/Logic/HomeCubit/home_cubit.dart';
import 'package:neu_social/Logic/NavigationCubit/navigation_cubit.dart';
import 'package:neu_social/Utils/helpers.dart';
import 'package:neu_social/Utils/size_config.dart';
import 'package:neu_social/Widgets/Buttons/custom_button.dart';
import 'package:neu_social/Widgets/Buttons/types_dropdown.dart';
import 'package:neu_social/Widgets/Inputs/custom_input.dart';
import 'package:neu_social/Widgets/Inputs/description_field.dart';
import 'package:neu_social/Widgets/Misc/ovelay.dart';

class CreateCommunity extends StatefulWidget {
  const CreateCommunity({super.key});

  @override
  State<CreateCommunity> createState() => _CreateCommunityState();
}

class _CreateCommunityState extends State<CreateCommunity> {
  bool errorText = false;
  Set<String> selectedInterests = <String>{};
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  String? selectedType;

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BottomSheetNavigationCubit, BottomSheetStatus>(
      listener: (context, state) {
        if (state == BottomSheetStatus.closed) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return Stack(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(12)),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height -
                      getProportionateScreenHeight(40),
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(height: getProportionateScreenHeight(18)),
                          CustomTextField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'A community name is required';
                              }
                              return null;
                            },
                            password: false,
                            hintText: "Enter your communities name",
                            controller: nameController,
                          ),
                          SizedBox(height: getProportionateScreenHeight(20)),
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 8.0,
                            runSpacing: 4.0,
                            children: defaultInterests.map((interest) {
                              final isSelected =
                                  selectedInterests.contains(interest);
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
                                Expanded(
                                  child: CustomDropdownButton(
                                    items: types,
                                    selectedItem: selectedType,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedType = value;
                                      });
                                    },
                                  ),
                                ),
                                // Expanded(child: _typesDropDown(context)),
                              ],
                            ),
                          ),
                          SizedBox(height: getProportionateScreenHeight(12)),
                          DescriptionField(
                            focusNode: focusNode,
                            descriptionController: descriptionController,
                            onChanged: (value) =>
                                setState(() => errorText = false),
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                setState(() {
                                  errorText = true;
                                });
                                return '';
                              }
                              return null;
                            },
                          ),
                          errorText
                              ? SizedBox(
                                  height: getProportionateScreenHeight(4))
                              : Container(),
                          errorText
                              ? Row(
                                  children: [
                                    Text(
                                      'A description is required',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error),
                                    ),
                                  ],
                                )
                              : Container(),
                          SizedBox(height: getProportionateScreenHeight(12)),
                          CustomButton(
                            onTap: () {
                              focusNode.unfocus();
                              if (selectedInterests.isEmpty) {
                                errorSnackBar(
                                    context, 'Select at least one interest');
                              } else if (selectedType == null) {
                                errorSnackBar(context, 'Select a type please');
                              } else if (_formKey.currentState!.validate()) {
                                context.read<HomeCubit>().createCommunity(
                                      descriptionController.text,
                                      nameController.text,
                                      selectedType!.toLowerCase(),
                                      selectedInterests.toList(),
                                      context,
                                    );
                              }
                            },
                            label: Text(
                              'Create',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            color: Theme.of(context).colorScheme.secondary,
                            radius: 12,
                            height: getProportionateScreenHeight(42),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                state is CommunityCreationLoading
                    ? const CustomOverlay()
                    : Container()
              ],
            );
          },
        );
      },
    );
  }
}
