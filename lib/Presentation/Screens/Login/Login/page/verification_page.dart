import 'package:aws_cognito_app/Data/Services/AWS/aws_cognito.dart';
import 'package:aws_cognito_app/Presentation/Components/app_bar.dart';
import 'package:aws_cognito_app/Presentation/Declarations/Constants/constant_aws.dart';
import 'package:aws_cognito_app/Presentation/Declarations/Constants/constant_images.dart';
import 'package:aws_cognito_app/Presentation/Declarations/Constants/constant_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final args = Get.arguments as Map<String, dynamic>;
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        appBar: buildAppBar(
            canReturn: true,
            context: context,
            inApp: false,
            iconColor: primaryColor,
            iconSize: 50,
            pushPath: '/register'),
        body: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: 600,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: const AssetImage(verficationImage),
                    height: size.height * 0.6,
                  ),
                  Text(
                    'Weryfikacja'.toUpperCase(),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(
                    height: blockHeight,
                  ),
                  Text(
                    'Podaj kod weryfikacyjny otrzymany na ${args['email'] as String}',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: blockHeight + 10,
                  ),
                  OtpTextField(
                    numberOfFields: 6,
                    focusedBorderColor: secondaryColor,
                    cursorColor: secondaryColor,
                    fillColor: Colors.black.withOpacity(0.1),
                    filled: true,
                    keyboardType: TextInputType.number,
                    onSubmit: (value) async {
                      await registerConfirmation(
                          args['email'] as String, value, context);
                    },
                  ),
                  const SizedBox(
                    height: blockHeight,
                  ),
                  TextButton(
                    onPressed: () async {
                      await AWSServices().resendConfirmationCode(
                          args['email'] as String, context);
                    },
                    child: Text.rich(
                      TextSpan(
                        text: 'Kod nie przyszedł? ',
                        style: Theme.of(context).textTheme.bodySmall,
                        children: [
                          TextSpan(
                            text: 'Wyślij ponownie!',
                            style: TextStyle(color: primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
