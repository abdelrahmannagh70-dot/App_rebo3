import 'package:app3/core/routes/app_route.dart';
import 'package:app3/core/services/local/local_Helper.dart';
import 'package:app3/core/themes/app_colors.dart';
import 'package:app3/core/routes/app_router.dart';
import 'package:app3/core/utils/app.constans.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookiaApp extends StatelessWidget {
  const BookiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,

        theme: ThemeData(
          fontFamily: 'DM',
        ),

        initialRoute:initPage(),

        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
  String initPage(){
    if(localHelper.prefs?.getString(AppConstans.userToken)!=null){
      return AppRoutes.homeScreen;
    }else{
      return AppRoutes.welcomeScreen;
    }
  }
}