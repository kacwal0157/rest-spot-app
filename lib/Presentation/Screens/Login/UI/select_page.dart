import 'package:aws_cognito_app/Presentation/Declarations/Constants/constant_aws.dart';
import 'package:aws_cognito_app/Presentation/Declarations/Constants/constant_images.dart';
import 'package:aws_cognito_app/Presentation/Declarations/Constants/constant_variables.dart';
import 'package:aws_cognito_app/Presentation/Routes/routes.dart';
import 'package:aws_cognito_app/app_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class SelectPage extends StatefulWidget {
  const SelectPage({super.key});

  @override
  State<SelectPage> createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Center(
            child: Container(
          width: 600,
          padding: const EdgeInsets.all(blockPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: blockHeight * 2),
              Image(
                image: const AssetImage(selectImage),
                height: size.height * 0.6,
                width: size.width,
              ),
              const SizedBox(
                height: blockHeight,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _getElevatedBtn(
                      '/config_select', context, 'Edycja', {}, false),
                  _getElevatedBtn('/restaurant', context, 'Aplikacja',
                      {'editMode': false}, true),
                ],
              ),
              const SizedBox(
                height: blockHeight + 20,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: IconButton(
                  icon: const Icon(
                    Icons.logout_rounded,
                    size: 40,
                  ),
                  onPressed: () => logout(AppManager.userMail, context),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 15),
                child: Text(
                  'Wyloguj',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        )),
      ),
    ));
  }

  _getElevatedBtn(String path, BuildContext context, String text,
      Map<String, dynamic> arguments, bool padding) {
    return Padding(
      padding: padding
          ? const EdgeInsets.only(left: blockPadding, right: blockPadding + 10)
          : const EdgeInsets.all(0),
      child: ElevatedButton(
        onPressed: () {
          {
            if (path == '/config_select') {
              Get.toNamed(Routes.getConfigSelectPageRoute(),
                  arguments: arguments);
            } else {
              Get.toNamed(Routes.getRestaurantPageRoute(),
                  arguments: arguments);
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 21, 28, 28),
          foregroundColor: Colors.white,
          fixedSize: const Size(200, 50),
          elevation: 0,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
