import 'package:air_quality_explorer/core/color.dart';
import 'package:air_quality_explorer/database/check_insertdata.dart';
import 'package:air_quality_explorer/database/database_helper.dart';
import 'package:air_quality_explorer/l10n/local_string.dart';
import 'package:air_quality_explorer/module/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

final dbHelper = DatabaseHelper();

main() {
  CheckInsertdata();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) => (GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'NASA SERVIR',
        translations: LocalStringMessage(),
        theme: ThemeData(
          textTheme: const TextTheme(
            displayLarge: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: AppColor.appTextColor,
                fontFamily: 'SF Pro'),
            displayMedium: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: AppColor.appbarTextColor,
                fontFamily: 'SF Pro'),
          ),
        ),
        home: const SplashScreen(),
      )),
    );
  }
}
