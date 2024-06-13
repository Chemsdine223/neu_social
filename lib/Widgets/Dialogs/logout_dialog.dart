import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neu_social/Logic/LogoutCubit/logout_cubit.dart';
import 'package:neu_social/Screens/signup.dart';
import 'package:neu_social/Utils/size_config.dart';
import 'package:neu_social/Widgets/Buttons/custom_button.dart';

class LogoutDialog extends StatefulWidget {
  const LogoutDialog({super.key});

  @override
  State<LogoutDialog> createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<LogoutDialog> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LogoutCubit, LogoutState>(
      listener: (context, state) {
        if (state == LogoutState.done) {
          Navigator.pop(context);
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return const Signup();
            },
          ));
        }
      },
      builder: (context, state) {
        return Dialog(
          child: SizedBox(
            height: getProportionateScreenHeight(200),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.circular(12),
                  ),

                  // color: Colors.red,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Are you sure you want to logout ?',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(32),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomButton(
                                  onTap: () async {
                                    await context.read<LogoutCubit>().logout();
                                  },
                                  label: Text(
                                    'Yes',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                  ),
                                  color: Theme.of(context).colorScheme.error,
                                  radius: 8,
                                  height: getProportionateScreenHeight(32)),
                            ),
                            SizedBox(width: getProportionateScreenWidth(12)),
                            Expanded(
                              child: CustomButton(
                                  onTap: () => Navigator.pop(context),
                                  label: Text(
                                    'No',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                  ),
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  radius: 8,
                                  height: getProportionateScreenHeight(32)),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                state == LogoutState.loading
                    ? Container(
                        height: getProportionateScreenHeight(200),
                        decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(12)),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            // color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        );
      },
    );
  }
}
