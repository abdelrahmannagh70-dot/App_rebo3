import 'package:app3/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton extends StatelessWidget {
  final String titel;
  final Color? bgColor;
  final Color? textColor;
  final Function()? onTap;

  const AppButton({
    super.key,
    required this.titel,
    this.bgColor,
    this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: bgColor ?? AppColors.mainColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          titel,
          style: TextStyle(
            fontFamily: 'DM',
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: textColor ?? Colors.white,
          ),
        ),
      ),
    );
  }
}
