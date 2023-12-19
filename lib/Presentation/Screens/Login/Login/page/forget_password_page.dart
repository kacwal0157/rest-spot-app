import 'package:aws_cognito_app/Presentation/Components/app_bar.dart';
import 'package:aws_cognito_app/Presentation/Components/input_decoration.dart';
import 'package:aws_cognito_app/Presentation/Declarations/Constants/constant_images.dart';
import 'package:aws_cognito_app/Presentation/Declarations/Constants/constant_variables.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/Login/widget/form_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});
  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final args = Get.arguments as Map<String, dynamic>;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: buildAppBar(
            canReturn: true,
            inApp: false,
            context: context,
            iconColor: primaryColor,
            iconSize: 50,
            pushPath: '/login'),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              width: 600,
              padding: const EdgeInsets.all(blockPadding),
              child: Column(
                children: [
                  const SizedBox(
                    height: blockHeight * 4,
                  ),
                  FormHeaderWidget(
                    image: resetPasswordImage,
                    title: 'Zapomniałeś hasła?',
                    subTitle: args['subTitle'] as String,
                    heightBetween: 30.0,
                  ),
                  const SizedBox(
                    height: blockHeight + 10,
                  ),
                  Form(
                    child: Column(
                      children: [
                        TextFormField(
                            decoration: getInputDecoration(
                          hint: args['inputHint'] as String,
                          label: args['inputLabel'] as String,
                          prefixIcon: args['iconData'] as IconData,
                        ) //widget.iconType),
                            ),
                        const SizedBox(
                          height: blockHeight + 10,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: darkElevatedButton,
                            child: const Text('Potwierdź'),
                          ),
                        ),
                      ],
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
