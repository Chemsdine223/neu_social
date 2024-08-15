import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neu_social/Constants/constants.dart';
import 'package:neu_social/Data/OfflineService/storage_service.dart';
import 'package:neu_social/Logic/HomeCubit/home_cubit.dart';
import 'package:neu_social/Utils/helpers.dart';
import 'package:neu_social/Utils/size_config.dart';

class AddInterests extends StatefulWidget {
  const AddInterests({super.key});

  @override
  State<AddInterests> createState() => _AddInterestsState();
}

class _AddInterestsState extends State<AddInterests> {
  List<String> selectedInterests = [];
  List<String> userInterests = [];

  @override
  void initState() {
    super.initState();
    _loadUserInterests();
  }

  Future<void> _loadUserInterests() async {
    userInterests = await StorageService().getInterests();
    setState(() {});
  }

  List<String> getAvailableInterests() {
    return defaultInterests
        .where((interest) => !userInterests.contains(interest))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final availableInterests = getAvailableInterests();

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios)),
        centerTitle: true,
        title: const Text('Add Interests'),
      ),
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(12)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const Text('data'),
              Text(
                availableInterests.isEmpty
                    ? 'No available interests'
                    : 'Add new interest',
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8.0,
                runSpacing: 4.0,
                children: availableInterests.map((interest) {
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
            ],
          ),
        ),
      ),
      floatingActionButton: availableInterests.isEmpty
          ? null
          : FloatingActionButton(
              onPressed: () async {
                final homeCubit = context.read<HomeCubit>();
                for (var interest in selectedInterests) {
                  await homeCubit.addInterest(interest);
                }
                if (context.mounted) {
                  successSnackBar(context, 'Added successfully !');
                  Navigator.pop(context);
                }
              },
              child: const Icon(Icons.save),
            ),
    );
  }
}
