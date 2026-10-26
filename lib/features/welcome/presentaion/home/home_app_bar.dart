import 'package:app3/core/routes/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../gen/assets.gen.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Assets.images.logo2.image(width: 100.w),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.searchScreen);
          },
          child: Icon(Icons.search, size: 30.r),
        ),
      ],
    );
  }
}
