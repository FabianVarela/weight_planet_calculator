import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  static ThemeData mainTheme(BuildContext context) {
    final themeData = ThemeData(
      textTheme: GoogleFonts.barlowTextTheme(Theme.of(context).textTheme),
      primaryColor: Colors.blueGrey,
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.blueGrey,
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: const TextStyle(color: Colors.blueGrey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blueGrey),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.blueGrey),
    );

    return themeData.copyWith(
      colorScheme: themeData.colorScheme.copyWith(surface: Colors.white),
    );
  }
}
