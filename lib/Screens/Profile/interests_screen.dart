import 'package:flutter/material.dart';
import 'package:neu_social/Constants/constants.dart';
import 'package:neu_social/Data/OfflineService/storage_service.dart';
import 'package:neu_social/Screens/Home/home.dart';
import 'package:neu_social/Utils/size_config.dart';
import 'package:neu_social/Widgets/Buttons/custom_button.dart';

class InterestsScreen extends StatefulWidget {
  const InterestsScreen({super.key});

  @override
  State<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  Set<String> selectedInterests = <String>{};

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Select your interests',
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge!
                      .copyWith(color: Theme.of(context).primaryColor),
                ),
                SizedBox(height: getProportionateScreenHeight(24)),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: defaultInterests.map((interest) {
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
                SizedBox(height: getProportionateScreenHeight(24)),
                CustomButton(
                  onTap: () async {
                    await StorageService()
                        .saveInterests(selectedInterests.toList())
                        .then((value) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ));
                    });
                  },
                  color: Colors.green.shade800,
                  radius: 8,
                  label: Text(
                    'Proceed',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  height: getProportionateScreenHeight(42),
                )
              ],
            ),
          ),
        ),
        // const CustomOverlay(),
      ],
    );
  }
}
