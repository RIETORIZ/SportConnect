import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
    useMaterial3: true,
    primaryColor: Colors.green,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1B5E20),
      selectedItemColor: Colors.yellowAccent,
      unselectedItemColor: Colors.white,
    ),
  );

  static ThemeData darkTheme = ThemeData.dark();

  // If you want to implement system theme logic or additional custom themes,
  // you can manage them here as well.
}
