import 'package:aws_cognito_app/Presentation/Components/forget_password_btn.dart';
import 'package:aws_cognito_app/Presentation/Components/input_decoration.dart';
import 'package:aws_cognito_app/Presentation/Declarations/Constants/constant_aws.dart';
import 'package:aws_cognito_app/Presentation/Declarations/Constants/constant_variables.dart';
import 'package:aws_cognito_app/Presentation/Routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidget();
}

class _LoginFormWidget extends State<LoginFormWidget> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool showPassword = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: buttonHeight),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: emailController,
              decoration: getInputDecoration(
                  hint: 'E-mail',
                  label: 'E-mail',
                  prefixIcon: Icons.person_outline_rounded),
            ),
            const SizedBox(height: blockHeight),
            TextFormField(
              controller: passwordController,
              obscureText: !showPassword,
              decoration: getInputDecoration(
                hint: 'Hasło',
                label: 'Hasło',
                prefixIcon: Icons.fingerprint,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                  icon: Icon(
                    Icons.remove_red_eye_rounded,
                    color: primaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: blockHeight - 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: () {
                    _getModalBottomSheet(context);
                  },
                  child: Text(
                    'Zapomniałeś hasła?',
                    style: TextStyle(color: primaryColor),
                  )),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await login(
                      emailController.text, passwordController.text, context);
                },
                style: darkElevatedButton,
                child: Text('Zaloguj'.toUpperCase()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _getModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      builder: (context) => Container(
        height: 250,
        padding: const EdgeInsets.all(blockPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Wybierz sposób!',
                style: Theme.of(context).textTheme.headlineMedium),
            Text('W jaki sposób chcesz abyśmy pomogli odzyskać twoje hasło?',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: blockHeight),
            ForgetPasswordBtnWidget(
              btnIcon: Icons.mail_outline_rounded,
              title: 'E-mail',
              subTitle: 'Reset poprzez weryfikację e-mail.',
              onTap: () {
                Navigator.pop(context);
                Get.toNamed(
                  Routes.getResetPasswordPageRoute(),
                  arguments: {
                    'subTitle':
                        'Nic nie szkodzi, zresteuj je! Podaj nam swojego maila przypisanego do konta.',
                    'inputLabel': 'E-mail',
                    'inputHint': 'E-mail',
                    'iconData': Icons.mail_outline_rounded,
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
