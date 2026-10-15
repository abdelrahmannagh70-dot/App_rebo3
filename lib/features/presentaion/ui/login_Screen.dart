import 'package:app3/core/routes/app_route.dart';
import 'package:app3/core/themes/APP_text_Style.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/src/widgets/text.dart';

class loginScreen extends StatelessWidget {
  const loginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.loginScreen);
            },
            icon: Icon(Icons.abc),
          ),
          Text(
            "Welcome back! Glad to see you again!",
            style: AppTextStyle.font30Regular,
          ),

        ],
      ),
    );

  }
}
