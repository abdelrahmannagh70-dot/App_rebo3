import 'package:app3/core/routes/app_route.dart';
import 'package:app3/features/book_details/presentaion/cubit/book_details_cubit.dart';
import 'package:app3/features/book_details/ui/book_details_screen.dart';
import 'package:app3/features/presentaion/cubit/auth_cubit.dart';
import 'package:app3/features/presentaion/cubit/cubit/home_cubit.dart';
import 'package:app3/features/presentaion/ui/login_Screen.dart';
//import 'package:app3/features/presentaion/ui/register_screen.dart';
import 'package:app3/features/welcome/presentaion/home/home_screen.dart';
import 'package:app3/features/welcome/presentaion/ui/register_screen.dart';
import 'package:app3/features/welcome/presentaion/ui/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/welcome/presentaion/home/search_screen.dart';

class AppRouter {
  static Route? onGenerateRoute(RouteSettings setting) {
    switch (setting.name) {
      case AppRoutes.loginScreen:
        return MaterialPageRoute(
          settings: setting,
          builder:
              (_) => BlocProvider(
                create: (context) => AuthCubit(),
                child: loginScreen(),
              ),
        );

      case AppRoutes.registerScreen:
        return MaterialPageRoute(
          settings: setting,
          builder: (_) => const RegisterScreen(),
        );

      case AppRoutes.homeScreen:
        return MaterialPageRoute(
          settings: setting,
          builder:
              (_) => BlocProvider(
                create: (context) => HomeCubit()..getBestSellerBox(),
                child: const HomeScreen(),
              ),
        );

      case AppRoutes.welcomeScreen:
        return MaterialPageRoute(
          settings: setting,
          builder: (_) => const WelcomeScreen(),
        );

      case AppRoutes.searchScreen:
        return MaterialPageRoute(
          settings: setting,
          builder:
              (_) => BlocProvider(
                create: (context) => HomeCubit()..search("text"),
                child: const SearchScreen(),
              ),
        );
      case AppRoutes.bookDetailsScreen:
        int id=setting.arguments as int;
        return MaterialPageRoute(
          settings: setting,
          builder:
              (_) => BlocProvider(
                create: (context) => BookDetailsCubit()..getDetails(id),
                child: BookDetailsScreen(bookId: id),
              ),
        );

      default:
        return null;
    }
  }
}
