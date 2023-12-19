import 'package:aws_cognito_app/Data/Services/AWS/aws_cognito.dart';
import 'package:flutter/material.dart';

register(String name, String email, String password,
    BuildContext context) //String phoneNum,
async {
  await AWSServices().registerUser(name, email, password, context); //phoneNum,
}

login(String email, String password, BuildContext context) async =>
    await AWSServices().loginUser(email, password, context);

registerConfirmation(String email, String number, BuildContext context) async {
  await AWSServices().registerConfirmation(email, number, context);
}

logout(String email, BuildContext context) async =>
    await AWSServices().logoutUser(email, context);
