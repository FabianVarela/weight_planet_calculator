import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weight_planet_calculator/ui/common/custom_colors.dart';

class CustomTheme {
  static ThemeData mainTheme(BuildContext context) {
    final themeData = ThemeData(
      textTheme: GoogleFonts.barlowTextTheme(Theme.of(context).textTheme),
      primaryColor: CustomColors.blueGrey,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: CustomColors.blueGrey,
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: CustomColors.blueGrey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: CustomColors.blueGrey),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      iconTheme: IconThemeData(color: CustomColors.blueGrey),
    );

    return themeData.copyWith(
      colorScheme: themeData.colorScheme.copyWith(
        background: CustomColors.white,
      ),
    );
  }
}
