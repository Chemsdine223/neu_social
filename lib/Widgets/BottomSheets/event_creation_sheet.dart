import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:neu_social/Logic/HomeCubit/home_cubit.dart';
import 'package:neu_social/Utils/DateTime/date_utilities.dart';
import 'package:neu_social/Utils/helpers.dart';
import 'package:neu_social/Utils/size_config.dart';
import 'package:neu_social/Widgets/Buttons/custom_button.dart';
import 'package:neu_social/Widgets/Inputs/custom_input.dart';
import 'package:neu_social/Widgets/Inputs/description_field.dart';

class CreateEventSheet extends StatefulWidget {
  final int communityId;
  const CreateEventSheet({
    super.key,
    required this.communityId,
  });

  @override
  State<CreateEventSheet> createState() => _CreateEventSheetState();
}

class _CreateEventSheetState extends State<CreateEventSheet> {
  final nameController = TextEditingController();
  final dateController = TextEditingController();
  final locationController = TextEditingController();
  DateTime? eventDate;
  TimeOfDay? eventTime;
  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final focusNode = FocusNode();

  @override
  void dispose() {
    focusNode.dispose();
    nameController.dispose();
    dateController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: nameController,
                hintText: 'Event name',
                password: false,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter an event name';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: getProportionateScreenHeight(8),
              ),
              CustomTextField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'A date is required';
                  }
                  return null;
                },
                controller: TextEditingController(
                    text: eventDate != null ? formatDateTime(eventDate!) : ''),
                icon: InkWell(
                  onTap: () async {
                    final datePicked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2080),
                    );
                    if (datePicked != null) {
                      setState(() {
                        eventDate = datePicked;
                      });
                    }
                  },
                  child: const Icon(
                    Icons.calendar_month,
                  ),
                ),
                password: false,
                readOnly: true,

                hintText: 'Choose a date',
                // controller: dateController,
              ),
              SizedBox(
                height: getProportionateScreenHeight(8),
              ),
              CustomTextField(
                icon: InkWell(
                  onTap: () async {
                    final timePicked = await showTimePicker(
                      context: context,
                      initialEntryMode: TimePickerEntryMode.dialOnly,
                      initialTime: TimeOfDay(
                        hour: DateTime.now().hour,
                        minute: DateTime.now().minute,
                      ),
                    );
                    if (timePicked != null) {
                      setState(() {
                        eventTime = timePicked;
                      });
                    }
                  },
                  child: const Icon(
                    Icons.timer_rounded,
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Time is required';
                  }
                  return null;
                },
                hintText: 'Enter a time',
                controller: TextEditingController(
                    text: eventTime != null ? formatTimeOfDay(eventTime!) : ''),
              ),
              SizedBox(
                height: getProportionateScreenHeight(8),
              ),
              CustomTextField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter a location';
                  }
                  return null;
                },
                hintText: 'Enter a location',
                controller: locationController,
              ),
              SizedBox(
                height: getProportionateScreenHeight(8),
              ),
              DescriptionField(
                validator: (value) {
                  if (value!.isEmpty) {
                    errorSnackBar(context, 'A description is required');
                    return '';
                  }
                  return null;
                },
                hint: 'Enter your events description',
                descriptionController: descriptionController,
                focusNode: focusNode,
              ),
              SizedBox(
                height: getProportionateScreenHeight(8),
              ),
              Row(
                children: [
                  Expanded(
                    child: BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        if (state is HomeLoaded) {
                          final currentCommunity = state.communities
                              .where((c) => c.id == widget.communityId)
                              .first;

                          return CustomButton(
                            onTap: () async {
                              if (formKey.currentState!.validate()) {
                                focusNode.unfocus();
                                if (!currentCommunity.events.any(
                                    (element) => element.date == eventDate)) {
                                  context.read<HomeCubit>().createEvent(
                                        currentCommunity,
                                        descriptionController.text,
                                        formatTimeOfDay(eventTime!),
                                        eventDate!,
                                        nameController.text,
                                        locationController.text,
                                      );
                                  Navigator.pop(context);
                                  successSnackBar(
                                      context, 'Event created successfully !');
                                } else {
                                  errorSnackBar(context, 'Already reserved !');
                                }
                              }
                            },
                            color: Colors.green.shade800,
                            radius: 12,
                            height: getProportionateScreenHeight(45),
                            label: Text(
                              'Create',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
