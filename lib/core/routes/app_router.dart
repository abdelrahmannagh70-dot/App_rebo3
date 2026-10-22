import 'package:app3/core/routes/app_route.dart';
import 'package:app3/features/presentaion/cubit/auth_cubit.dart';
import 'package:app3/features/presentaion/cubit/cubit/home_cubit.dart';
import 'package:app3/features/presentaion/ui/login_Screen.dart';
//import 'package:app3/features/presentaion/ui/register_screen.dart';
import 'package:app3/features/welcome/presentaion/ui/home_screen.dart';
import 'package:app3/features/welcome/presentaion/ui/register_screen.dart';
import 'package:app3/features/welcome/presentaion/ui/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  static Route? onGenerateRoute(RouteSettings setting) {
    switch (setting.name) {
      case AppRoutes.loginScreen:
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create: (context) => AuthCubit(),
                child: loginScreen(),
              ),
        );

      case AppRoutes.registerScreen:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case AppRoutes.homeScreen:
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create: (context) => HomeCubit()..getBestSellerBox(),
                child: const HomeScreen(),
              ),
        );

      case AppRoutes.welcomeScreen:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());

      default:
        return null;
    }
  }
}
