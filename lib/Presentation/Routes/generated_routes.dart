/*import 'package:aws_cognito_app/Presentation/Models/Data/category_data.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/Login/page/login_page.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/Login/page/verification_page.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/Login/page/register_page.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/Login/page/welcome_splash_page.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/Login/page/forget_password_page.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/UI/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'package:aws_cognito_app/Presentation/Config/config_prefs.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/UI/config_select_page.dart';
import 'package:aws_cognito_app/Presentation/Services/config_service.dart';
import 'package:aws_cognito_app/app_manager.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/UI/select_page.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/UI/restaurant/category_content.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/UI/restaurant/restaurant_page.dart';
import 'package:aws_cognito_app/Presentation/Services/language_service.dart';
import 'package:aws_cognito_app/Presentation/Services/shopping_service.dart';

class RouteGenerator {
  Route<dynamic> generateRoute(RouteSettings settings) {
    ShoppingService shoppingService = ShoppingService();
    LanguageService languageService = LanguageService();

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const WelcomeSplashPage());
      case '/loading':
        return PageTransition(
            type: PageTransitionType.fade, child: const LoadingPage());
      case '/login':
        return PageTransition(
            type: PageTransitionType.fade, child: const LoginPage());
      case '/register':
        return PageTransition(
            type: PageTransitionType.leftToRight, child: const RegisterPage());
      case '/reset-password':
        final args = settings.arguments as Map<String, dynamic>;
        return PageTransition(
          type: PageTransitionType.rightToLeft,
          child: ForgetPasswordPage(
            subTitle: args['subTitle'],
            inputLabel: args['inputLabel'],
            inputHint: args['inputHint'],
            iconType: args['iconData'],
          ),
        );
      case '/verification':
        final args = settings.arguments as Map<String, dynamic>;
        return PageTransition(
          type: PageTransitionType.leftToRight,
          child: VerificationPage(
            email: args['email'],
          ),
        );
      case '/restaurant':
        ConfigPrefs().loadSelectedRecord(
            AppManager.userMail, AppManager.responses[0].id);
        return MaterialPageRoute(builder: (_) => const SelectPage());
      case '/configs':
        return PageTransition(
            type: PageTransitionType.bottomToTop,
            child: const ConfigSelectPage());
      case '/main':
        final args = settings.arguments as Map<String, dynamic>;
        AppManager.currentRoute = '/main';
        AppManager.editMode = args['editMode'];

        if (args['configFile'] != null) {
          ConfigService.fileName = args['configFile'];
        }
        return PageTransition(
            type: PageTransitionType.fade,
            child: RestaurantPage(shoppingService, languageService));
      case '/card':
        final args = settings.arguments as CategoryData;
        AppManager.currentRoute = '/card';

        return PageTransition(
            type: PageTransitionType.leftToRight,
            child: CategoryContent(
              category: args.category,
              layoutService: args.layoutService,
              shoppingService: shoppingService,
              languageService: languageService,
            ));
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
*/