import 'package:client_portal/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: bgColor,
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
        background: secondaryColor,
        seedColor: primaryColor,
        surface: secondaryColor,
        surfaceTint: Colors.transparent,
        brightness: Brightness.dark),
    textTheme: GoogleFonts.poppinsTextTheme()
        .apply(bodyColor: Colors.white, displayColor: Colors.white),
    canvasColor: secondaryColor,
    listTileTheme: ListTileThemeData().copyWith(
      tileColor: secondaryColor,
      selectedColor: primaryColor.withOpacity(.4),
      iconColor: Colors.white70,
      textColor: Colors.white.withOpacity(.9),
    ),
    drawerTheme: DrawerThemeData(
        backgroundColor: secondaryColor, surfaceTintColor: Colors.transparent));

ThemeData lightTheme = ThemeData.light(useMaterial3: true).copyWith(
  textTheme: GoogleFonts.poppinsTextTheme()
      .apply(bodyColor: Colors.black87, displayColor: Colors.black),
  canvasColor: secondaryColor,
  scaffoldBackgroundColor: Colors.blueGrey[100],
  colorScheme: ColorScheme.fromSeed(
    seedColor: primaryColor,
    background: Colors.blueGrey[50],
  ),
);
