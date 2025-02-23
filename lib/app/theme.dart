import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color(0xff222E50),
      primary: Color(0xff222E50),
      secondary: Color(0xffF3D62E),
      surface: Colors.white,
      onSurface: Colors.black,
      error: Colors.redAccent,
    ),
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
      ),
    ),
    brightness: Brightness.light,
    useMaterial3: true,
  );
}
