import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neu_social/Logic/AuthCubit/auth_cubit.dart';
import 'package:neu_social/Screens/home.dart';
import 'package:neu_social/Utils/helpers.dart';
import 'package:neu_social/Utils/size_config.dart';
import 'package:neu_social/Widgets/Buttons/custom_button.dart';
import 'package:neu_social/Widgets/Inputs/custom_input.dart';
import 'package:neu_social/Widgets/Misc/ovelay.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        // print(state);
        if (state is AuthFailure) {
          errorSnackBar(context, state.message);
        }
        if (state is AuthSuccess) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ));
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              // floatingActionButton: FloatingActionButton(
              //   onPressed: () {
              //     NetworkService.verifyUser();
              //     // NetworkService.register('firstName', 'lastName',
              //     //     'email1320@gmail.com', 'dob', 'password');
              //   },
              // ),
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(18)),
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: getProportionateScreenHeight(120),
                          ),
                          SizedBox(
                            width: getProportionateScreenWidth(180),
                            child: Text(
                              'Login',
                              textAlign: TextAlign.start,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),

                          // _dateField(context),
                          SizedBox(height: getProportionateScreenHeight(48)),
                          CustomTextField(
                            controller: emailController,
                            hintText: 'Email',
                            password: false,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (value) {},
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'E-mail cannot be empty';
                              } else if (!RegExp(
                                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                  .hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: getProportionateScreenHeight(8)),
                          CustomTextField(
                            controller: passwordController,
                            hintText: 'Password',
                            password: true,
                            onChanged: (value) {},
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Password cannot be empty';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(18),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  onTap: () async {
                                    if (formKey.currentState!.validate()) {
                                      context.read<AuthCubit>().login(
                                            emailController.text,
                                            passwordController.text,
                                          );
                                    }
                                  },
                                  color: Colors.green.shade800,
                                  radius: 12,
                                  height: getProportionateScreenHeight(45),
                                  label: Text(
                                    'Login',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            state is AuthLoading ? const CustomOverlay() : Container(),
          ],
        );
      },
    );
  }
}
