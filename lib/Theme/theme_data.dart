import 'package:neu_social/Theme/Typography/typography_theme.dart';
import 'package:neu_social/Theme/colors/color_palettes.dart';
import 'package:flutter/material.dart';

class ThemeClass {
  Color darkPrimaryColor = Colors.white;
  Color lightPrimaryColor = Colors.black;

  static ThemeData lightTheme = ThemeData(
    primaryColor: Colors.black,
    canvasColor: ColorPalettes().lightsurfaceColor,
    secondaryHeaderColor: Colors.white,
    brightness: Brightness.light,
    useMaterial3: true,
    textTheme: CustomTypography().textTheme,
    colorScheme: ColorScheme.light(
      secondary: ColorPalettes().accentColor,
      primary: ColorPalettes().lightPrimaryColor,
    ),
  );

  static ThemeData dark = ThemeData(
    canvasColor: ColorPalettes().darksurfaceColor,
    primaryColor: ColorPalettes().darkPrimaryColor,
    secondaryHeaderColor: Colors.black,
    textTheme: CustomTypography().textTheme,
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      secondary: ColorPalettes().accentColor,
      primary: ColorPalettes().darkPrimaryColor,
    ),
  );
}
