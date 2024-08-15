import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neu_social/Data/OfflineService/storage_service.dart';
import 'package:neu_social/Logic/AuthCubit/auth_cubit.dart';
import 'package:neu_social/Logic/ChatCubit/chat_cubit.dart';
import 'package:neu_social/Logic/LogoutCubit/logout_cubit.dart';
import 'package:neu_social/Logic/NavigationCubit/navigation_cubit.dart';
import 'package:neu_social/Screens/Home/home.dart';
import 'package:neu_social/Widgets/Misc/loading.dart';
import 'package:neu_social/Screens/Auth/login.dart';
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
          // lazy: false,
          create: (context) => ChatCubit(),
        ),
        BlocProvider(
          create: (context) => AuthCubit(context.read<ChatCubit>()),
        ),
        BlocProvider(
          create: (context) => BottomSheetNavigationCubit(),
        ),
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider(
          create: (context) => LogoutCubit(context.read<ChatCubit>()),
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
                if (state is AuthUserCheck) {
                  return const LoadingScreen();
                } else if (state is AuthSuccess) {
                  return const HomeScreen();
                } else {
                  return const LoginScreen();
                }
              },
            ),
          );
        },
      ),
    );
  }
}
