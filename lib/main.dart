import 'package:app3/bookia_App.dart';
import 'package:app3/core/networking/dio_factory.dart';
import 'package:app3/core/services/local/local_Helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  await localHelper.init();
  DioFactory.init();


  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('de'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: BookiaApp(),
    ),
  );
}