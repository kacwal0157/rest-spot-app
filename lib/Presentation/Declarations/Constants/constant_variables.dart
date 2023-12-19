import 'package:aws_cognito_app/Presentation/Models/hex_color.dart';
import 'package:flutter/material.dart';

const buttonHeight = 20.0;
const blockHeight = 20.0;
const blockPadding = 10.0;

Color primaryColor = HexColor('#FEE400');
Color secondaryColor = HexColor('#272727');

ButtonStyle darkElevatedButton = ElevatedButton.styleFrom(
  elevation: 0,
  backgroundColor: secondaryColor,
  foregroundColor: Colors.white,
  side: const BorderSide(color: Colors.white),
  padding: const EdgeInsets.symmetric(vertical: buttonHeight),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
);

ButtonStyle darkOutlinedButton = OutlinedButton.styleFrom(
  foregroundColor: secondaryColor,
  side: BorderSide(color: secondaryColor),
  padding: const EdgeInsets.symmetric(vertical: buttonHeight),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
);

ThemeData customThemeData = ThemeData(
  textTheme: TextTheme(
    headlineSmall: TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
      color: secondaryColor,
    ),
    headlineMedium: TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
      color: secondaryColor,
    ),
    headlineLarge: TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: secondaryColor,
    ),
    bodySmall: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      color: Colors.black.withOpacity(0.6),
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 24.0,
      fontWeight: FontWeight.normal,
      color: Colors.black.withOpacity(0.6),
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 32.0,
      fontWeight: FontWeight.normal,
      color: Colors.black.withOpacity(0.6),
    ),
  ),
);
