import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neu_social/Data/OfflineService/storage_service.dart';
import 'package:neu_social/Logic/AuthCubit/auth_cubit.dart';
import 'package:neu_social/Logic/ChatCubit/websocket_cubit.dart';
import 'package:neu_social/Logic/LogoutCubit/logout_cubit.dart';
import 'package:neu_social/Logic/SignupCubit/signup_cubit.dart';
import 'package:neu_social/Logic/NavigationCubit/navigation_cubit.dart';
import 'package:neu_social/Screens/home.dart';
import 'package:neu_social/Screens/interests_screen.dart';
import 'package:neu_social/Screens/login.dart';
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
          create: (context) => AuthCubit(),
        ),
        BlocProvider(
          create: (context) => BottomSheetNavigationCubit(),
        ),
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider(
          create: (context) => LogoutCubit(),
        ),
        BlocProvider(
          create: (context) => WebSocketCubit(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, AppTheme>(
        builder: (context, theme) {
          return MaterialApp(
            theme: theme == AppTheme.light
                ? ThemeClass.lightTheme
                : ThemeClass.dark,
            debugShowCheckedModeBanner: false,
            home: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return state is AuthSuccess?
                    ? const InterestsScreen()
                    : const LoginScreen();
              },
            ),
          );
        },
      ),
    );
  }
}
