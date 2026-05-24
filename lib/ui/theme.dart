import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTema {
  static TextStyle baseStyle = GoogleFonts.hankenGrotesk();
  static TextStyle labelStyle = GoogleFonts.jetBrainsMono();

  static Color clrPrimary = Color(0xff005b66);

  static ThemeData tema = ThemeData(
    appBarTheme: AppBarTheme(foregroundColor: clrPrimary, titleSpacing: 0),
    cardTheme: CardThemeData(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    colorScheme: ColorScheme.fromSeed(seedColor: clrPrimary),
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    dropdownMenuTheme: const DropdownMenuThemeData(
      textStyle: TextStyle(fontSize: 13),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(fontSize: 13),
        hintStyle: TextStyle(fontSize: 13),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: WidgetStatePropertyAll(3),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: clrPrimary,
      foregroundColor: Colors.white,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black45, width: 0.5),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      labelTextStyle: WidgetStatePropertyAll(TextStyle(fontSize: 10)),
      iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: clrPrimary, size: 22);
        }
        return IconThemeData(color: Colors.grey, size: 20);
      }),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
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

    useMaterial3: true,
    visualDensity: const VisualDensity(vertical: -4),
  );
}
