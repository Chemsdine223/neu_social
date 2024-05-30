import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neu_social/Data/LocalStorage/storage_service.dart';
import 'package:neu_social/Logic/SignupCubit/signup_cubit.dart';
import 'package:neu_social/Logic/NavigationCubit/navigation_cubit.dart';
import 'package:neu_social/Screens/home.dart';
import 'package:neu_social/Screens/signup.dart';
import 'package:neu_social/Theme/theme_cubit.dart';
import 'package:neu_social/Theme/theme_data.dart';
import 'package:neu_social/Utils/size_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final auth = await StorageService().authenticityCheck();
  if (!auth) {
    await StorageService().setDefaultCommunity();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SignupCubit(),
        ),
        BlocProvider(
          create: (context) => BottomSheetNavigationCubit(),
        ),
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, AppTheme>(
        builder: (context, theme) {
          return MaterialApp(
            theme: theme == AppTheme.light
                ? ThemeClass.lightTheme
                : ThemeClass.dark,
            debugShowCheckedModeBanner: false,
            home: BlocBuilder<SignupCubit, Authentication>(
              builder: (context, auth) {
                return auth == Authentication.authenticated
                    ? const HomeScreen()
                    : const Signup();
              },
            ),
          );
        },
      ),
    );
  }
}
