import 'package:app3/core/themes/APP_text_Style.dart';
import 'package:app3/features/presentaion/ui/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class loginScreen extends StatelessWidget {
  const loginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome back! Glad\n to see you Again!",
                style: AppTextStyle.font30Regular,
              ),
              30.verticalSpace,
              const LoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}
