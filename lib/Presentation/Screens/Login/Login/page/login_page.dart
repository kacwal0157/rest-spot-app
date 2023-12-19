import 'package:aws_cognito_app/Presentation/Declarations/Constants/constant_images.dart';
import 'package:aws_cognito_app/Presentation/Declarations/Constants/constant_variables.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/Login/widget/form_header_widget.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/Login/widget/login_footer_widget.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/Login/widget/login_form_widget.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Center(
              child: Container(
                width: 600,
                padding: const EdgeInsets.all(blockPadding),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FormHeaderWidget(
                        image: loginImage,
                        title: 'Witaj ponownie',
                        subTitle:
                            'Zaloguj się, aby korzystać z pełnych możliwości.'),
                    LoginFormWidget(),
                    LoginFooterWidget(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      onWillPop: () async {
        return false;
      },
    );
  }
}
