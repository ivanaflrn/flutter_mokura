import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeController {
  static TextTheme get defaultTextTheme => GoogleFonts.poppinsTextTheme();

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    // textTheme: defaultTextTheme,
    colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        background: Colors.white,
        error: Colors.red,
        onTertiary: Colors.orange
    ),
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    // textTheme: defaultTextTheme,
    colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        background: Colors.white,
        error: Colors.red,
        onTertiary: Colors.orange
    ),
  );
}