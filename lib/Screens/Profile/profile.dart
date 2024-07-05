import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neu_social/Logic/HomeCubit/home_cubit.dart';
import 'package:neu_social/Logic/LogoutCubit/logout_cubit.dart';
import 'package:neu_social/Screens/signup.dart';
import 'package:neu_social/Utils/size_config.dart';
import 'package:neu_social/Widgets/Buttons/custom_button.dart';
import 'package:neu_social/Widgets/Misc/ovelay.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogoutCubit, LogoutState>(
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                scrolledUnderElevation: 0,
                elevation: 0,
                automaticallyImplyLeading: false,
                centerTitle: true,
                leadingWidth: getProportionateScreenWidth(56),
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Builder(builder: (context) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back_ios),
                    );
                  }),
                ),
                title: const Text('Profile'),
              ),
              body: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  // print(state);
                  if (state is HomeLoaded) {
                    // print(state.user);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: getProportionateScreenHeight(40)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'Img/user.png',
                                    height: getProportionateScreenHeight(72),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 26),
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).canvasColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.person),
                                  trailing: Text(state.user.firstname),
                                  title: const Text('First name'),
                                ),
                                ListTile(
                                  leading: const Icon(Icons.person),
                                  trailing: Text(state.user.lastname),
                                  title: const Text('Last name'),
                                ),
                                ListTile(
                                  leading: const Icon(Icons.email),
                                  title: const Text('E-mail'),
                                  trailing: Text(state.user.email),
                                ),
                                ListTile(
                                  leading: const Icon(Icons.date_range),
                                  title: const Text('Date of birth'),
                                  trailing: Text(state.user.dob),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          CustomButton(
                            color: Theme.of(context).colorScheme.error,
                            label: const Text('Logout'),
                            radius: 4,
                            height: getProportionateScreenHeight(36),
                            icon: const Icon(
                              Icons.logout,
                              color: Colors.white,
                            ),
                            onTap: () {
                              context.read<LogoutCubit>().logout();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Signup(),
                                  ));
                            },
                          ),
                        ],
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ),
            state == LogoutState.loading ? const CustomOverlay() : Container(),
          ],
        );
      },
    );
  }
}
