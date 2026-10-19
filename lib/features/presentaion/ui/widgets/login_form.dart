import 'package:app3/core/routes/app_route.dart';
import 'package:app3/core/utils/app_validator.dart';
import 'package:app3/core/widget/App_button.dart';
import 'package:app3/core/widget/custom_text_from_feild.dart';
import 'package:app3/features/presentaion/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final formState = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginLoadingState) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) {
              return const PopScope(
                canPop: false,
                child: AlertDialog(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  content: Center(child: CircularProgressIndicator()),
                ),
              );
            },
          );
        } else if (state is LoginSuccessState) {
          Navigator.of(context, rootNavigator: true).pop();

          Navigator.pushReplacementNamed(context, AppRoutes.homeScreen);
        } else if (state is LoginErrorState) {
          Navigator.of(context, rootNavigator: true).pop();

          showDialog(
            context: context,
            builder: (dialogContext) {
              return AlertDialog(
                title: const Text("Login Failed"),
                content: const Text(
                  "Email or password is incorrect. Please try again.",
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                    },
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
        }
      },
      child: Form(
        key: formState,
        child: Column(
          children: [
            CustomTextFromFeild(
              controller: emailController,
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return "Email is required";
                }

                if (!AppValidator.validateEmail(v)) {
                  return "Please enter a valid email";
                }

                return null;
              },
              hintText: "Enter your Email",
            ),

            15.verticalSpace,

            CustomTextFromFeild(
              controller: passController,
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return "Password is required";
                }

                if (v.length < 7) {
                  return "Password must be at least 7 characters";
                }

                return null;
              },
              hintText: "Enter your Password",
              isPassword: true,
            ),

            30.verticalSpace,

            AppButton(
              titel: "Login",
              onTap: () {
                if (formState.currentState?.validate() ?? false) {
                  context.read<AuthCubit>().login(
                    email: emailController.text.trim(),
                    password: passController.text,
                  );
                }
              },
            ),

            20.verticalSpace,

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? "),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.registerScreen);
                  },
                  child: const Text(
                    "Register Now",
                    style: TextStyle(
                      color: Color(0xFFC5A653),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
