import 'package:aws_cognito_app/Presentation/Declarations/Constants/constant_images.dart';
import 'package:aws_cognito_app/Presentation/Declarations/Constants/constant_variables.dart';
import 'package:aws_cognito_app/Presentation/Routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class LoginFooterWidget extends StatelessWidget {
  const LoginFooterWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('ALBO'),
        const SizedBox(height: blockHeight - 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Image(
              image: AssetImage(googleImage),
              width: 20.0,
            ),
            onPressed: () {},
            label: Text('Zaloguj się poprzez Google'.toUpperCase()),
            style: darkOutlinedButton,
          ),
        ),
        const SizedBox(height: blockHeight - 10),
        TextButton(
          onPressed: () {
            Get.toNamed(Routes.getRegisterPageRoute());
          },
          child: Text.rich(
            TextSpan(
              text: 'Nie posiadasz konta? ',
              style: Theme.of(context).textTheme.bodySmall,
              children: [
                TextSpan(
                  text: 'Zarejestruj się!',
                  style: TextStyle(color: primaryColor),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
