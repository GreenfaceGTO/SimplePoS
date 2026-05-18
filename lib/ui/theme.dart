import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTema {
  static TextStyle baseStyle = GoogleFonts.hankenGrotesk();
  static TextStyle labelStyle = GoogleFonts.jetBrainsMono();

  static Color clrPrimary = Color(0xff005b66);

  static ThemeData tema = ThemeData(
    visualDensity: const VisualDensity(vertical: -4),
    colorScheme: ColorScheme.fromSeed(seedColor: clrPrimary),
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    appBarTheme: AppBarTheme(foregroundColor: clrPrimary, titleSpacing: 0),
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
    textTheme: ThemeData.light().textTheme.copyWith(
      bodySmall: baseStyle.copyWith(fontSize: 10, color: Colors.black54),
      bodyMedium: baseStyle.copyWith(fontSize: 12, color: Colors.black54),
      bodyLarge: baseStyle.copyWith(fontSize: 13, color: Colors.black54),
      titleSmall: baseStyle.copyWith(
        fontSize: 14,
        color: Colors.black87,
        fontWeight: FontWeight.w700,
      ),

      titleMedium: baseStyle.copyWith(
        fontSize: 16,
        color: Colors.black87,
        fontWeight: FontWeight.w700,
      ),

      titleLarge: baseStyle.copyWith(
        fontSize: 18,
        color: Colors.black87,
        fontWeight: FontWeight.w700,
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black45, width: 0.5),
      ),
    ),

    useMaterial3: true,
  );
}
