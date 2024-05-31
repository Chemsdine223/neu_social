import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neu_social/Logic/HomeCubit/home_cubit.dart';
import 'package:neu_social/Screens/Profile/profile.dart';
import 'package:neu_social/Theme/theme_cubit.dart';
import 'package:neu_social/Utils/size_config.dart';
import 'package:neu_social/Widgets/Misc/logout_dialog.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'Img/user.png',
                    height: getProportionateScreenHeight(56),
                  ),
                  SizedBox(height: getProportionateScreenHeight(12)),
                  BlocBuilder<HomeCubit, HomeState>(
                    builder: (context, state) {
                      return state is HomeLoaded
                          ? Text(state.user.firstname)
                          : Container();
                    },
                  )
                ],
              ),
            ),
          ),
          ListTile(
            trailing: BlocBuilder<ThemeCubit, AppTheme>(
              builder: (context, theme) {
                return Switch(
                  value: theme == AppTheme.dark ? true : false,
                  onChanged: (value) {
                    context.read<ThemeCubit>().toggleTheme();
                  },
                );
              },
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Profile(),
                  ));
            },
            leading: const Icon(Icons.person),
            title: const Text(
              'Profile',
            ),
          ),
          ListTile(
            leading: Image.asset(
              'Img/group-users.png',
              height: 20,
            ),
            title: const Text(
              'My communities',
            ),
          ),
          const Spacer(),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return const LogoutDialog();
                },
              );
            },
            leading: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.error,
            ),
            title: Text(
              'Logout',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
