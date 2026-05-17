import 'package:flutter/material.dart';

class AppTema {
  static ThemeData tema = ThemeData(
    visualDensity: const VisualDensity(vertical: -4),
    // colorScheme: ColorScheme.fromSeed(
    //   seedColor: Colors.blue,
    //   primary: Colors.blue,
    //   secondary: Colors.indigoAccent,
    //   surface: Colors.white,
    //   brightness: Brightness.light,
    // ),
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    appBarTheme: const AppBarTheme(leadingWidth: 40),
    cardTheme: CardThemeData(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    dropdownMenuTheme: const DropdownMenuThemeData(
      textStyle: TextStyle(fontSize: 13),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(fontSize: 13),
        hintStyle: TextStyle(fontSize: 13),
      ),
    ),
    fontFamily: "Roboto",
    textTheme: ThemeData.light().textTheme.copyWith(
      bodySmall: const TextStyle(fontSize: 10),
      bodyMedium: const TextStyle(fontSize: 12),
      bodyLarge: const TextStyle(fontSize: 13),
      titleSmall: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      titleMedium: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      titleLarge: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black45, width: 0.5),
      ),
    ),
    useMaterial3: true,
  );
}
