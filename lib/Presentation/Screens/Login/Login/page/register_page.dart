import 'package:aws_cognito_app/Presentation/Declarations/Constants/constant_images.dart';
import 'package:aws_cognito_app/Presentation/Declarations/Constants/constant_variables.dart';
import 'package:aws_cognito_app/Presentation/Routes/routes.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/Login/widget/form_header_widget.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/Login/widget/signup_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              width: 600,
              padding: const EdgeInsets.all(blockPadding),
              child: Column(
                children: [
                  const FormHeaderWidget(
                    image: signUpImage,
                    title: 'Zarejestruj się',
                    subTitle:
                        'Stwórz konto i ciesz się pełną funkcjonalnością.',
                  ),
                  const SignUpFormWidget(),
                  _buildGoogleButton(),
                  _buildLoginButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: const Image(
          image: AssetImage(googleImage),
          width: 20.0,
        ),
        style: darkOutlinedButton,
        label: Text('Zarejestruj się za pomocą Google'.toUpperCase()),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Get.toNamed(Routes.getLoginPageRoute());
      },
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'Masz juz konto? ',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            TextSpan(
              text: 'Zaloguj się',
              style: TextStyle(
                color: primaryColor,
                fontFamily: 'Poppins',
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
