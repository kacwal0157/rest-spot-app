import 'package:aws_cognito_app/Presentation/Declarations/Constants/constant_variables.dart';
import 'package:flutter/material.dart';

InputDecoration getInputDecoration(
    {required String label,
    required String hint,
    required IconData prefixIcon,
    IconButton? suffixIcon}) {
  return InputDecoration(
    label: Text(label),
    prefixIcon: Icon(prefixIcon),
    hintText: hint,
    border: const OutlineInputBorder(),
    prefixIconColor: secondaryColor,
    floatingLabelStyle: TextStyle(color: secondaryColor),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: 2.0,
        color: secondaryColor,
      ),
    ),
    suffixIcon: suffixIcon,
  );
}
