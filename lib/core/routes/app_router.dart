import 'package:app3/core/routes/app_route.dart';
import 'package:app3/features/presentaion/ui/login_Screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route? onGenerateRoute(RouteSettings setting) {
    switch (setting.name) {
      case AppRoutes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => loginScreen(),
        );

      case AppRoutes.registerScreen:
        return MaterialPageRoute(
          builder: (_) => loginScreen(),
        );

      case AppRoutes.homeScreen:
        return MaterialPageRoute(
          builder: (_) => loginScreen(),
        );

      case AppRoutes.welcomeScreen:
        return MaterialPageRoute(
          builder: (_) => loginScreen(),
        );

      default:
        return null;
    }
  }
}