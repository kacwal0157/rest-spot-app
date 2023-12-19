import 'package:aws_cognito_app/Presentation/Declarations/Constants/constant_images.dart';
import 'package:aws_cognito_app/Presentation/Declarations/Constants/constant_variables.dart';
import 'package:aws_cognito_app/Presentation/Routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class WelcomeSplashPage extends StatefulWidget {
  const WelcomeSplashPage({super.key});

  @override
  State<WelcomeSplashPage> createState() => _WelcomeSplashPageState();
}

class _WelcomeSplashPageState extends State<WelcomeSplashPage> {
  bool aniamte = false;

  @override
  void initState() {
    startAnimation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 2000),
            left: aniamte ? size.width * 0.1 : -20,
            top: aniamte ? size.height * 0.05 : -20,
            child: Container(
              width: blockHeight * 3,
              height: blockHeight * 3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: primaryColor,
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 2000),
            left: aniamte ? size.width * 0.15 : 30,
            top: aniamte ? size.height * 0.15 : 30,
            child: Container(
              width: blockHeight * 2.5,
              height: blockHeight * 2.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: primaryColor,
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 2000),
            top: aniamte ? size.height * 0.05 : -30,
            left: size.width * 0.4,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 2000),
              opacity: aniamte ? 1 : 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '.myFlutterApp',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  Text(
                    'Everyday is a new story.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 2500),
            bottom: aniamte ? 0 : -50,
            left: size.width * 0.22,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 2400),
              opacity: aniamte ? 1 : 0,
              child: Image(
                image: const AssetImage(welcomeImage),
                height: size.height * 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      aniamte = true;
    });

    await Future.delayed(const Duration(milliseconds: 5000))
        .then((_) => Get.toNamed(Routes.getLoginPageRoute()));
  }
}
