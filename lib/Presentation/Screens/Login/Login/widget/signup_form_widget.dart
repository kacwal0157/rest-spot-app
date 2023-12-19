import 'package:aws_cognito_app/Presentation/Components/input_decoration.dart';
import 'package:aws_cognito_app/Presentation/Declarations/Constants/constant_aws.dart';
import 'package:aws_cognito_app/Presentation/Declarations/Constants/constant_variables.dart';
import 'package:flutter/material.dart';

class SignUpFormWidget extends StatefulWidget {
  const SignUpFormWidget({super.key});

  @override
  State<SignUpFormWidget> createState() => _SignUpFormWidgetState();
}

class _SignUpFormWidgetState extends State<SignUpFormWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  //TextEditingController phoneNumController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    //phoneNumController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: buttonHeight),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: nameController,
              decoration: getInputDecoration(
                  hint: 'Nazwa',
                  label: 'Nazwa użytkownika',
                  prefixIcon: Icons.person_outline_rounded),
            ),
            const SizedBox(
              height: blockHeight,
            ),
            TextFormField(
              controller: emailController,
              decoration: getInputDecoration(
                  hint: 'E-mail',
                  label: 'E-mail',
                  prefixIcon: Icons.email_outlined),
            ),
            const SizedBox(
              height: blockHeight,
            ),
            /*TextFormField(
              controller: phoneNumController,
              decoration:
                  getInputDecoration('Number telefonu', Icons.numbers, 'Tel.'),
            ),
            const SizedBox(
              height: blockHeight,
            ),*/
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: getInputDecoration(
                  hint: 'Hasło', label: 'Hasło', prefixIcon: Icons.fingerprint),
            ),
            const SizedBox(
              height: blockHeight,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await register(
                      nameController.text,
                      emailController.text,
                      passwordController.text,
                      //phoneNumController.text,
                      context);
                },
                style: darkElevatedButton,
                child: Text('Zarejestruj się'.toUpperCase()),
              ),
            )
          ],
        ),
      ),
    );
  }
}
