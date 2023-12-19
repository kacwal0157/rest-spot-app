import 'package:aws_cognito_app/Presentation/Declarations/Constants/constant_variables.dart';
import 'package:flutter/material.dart';

Future buildAlertDialog(
    {required BuildContext context,
    String title = 'Błąd',
    String actionBtnText = 'Rozumiem',
    String? alertDescription}) async {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(alertDescription ?? ''),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                actionBtnText,
                style: TextStyle(color: primaryColor),
              ))
        ],
      );
    },
  );
}
