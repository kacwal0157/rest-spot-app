import 'package:aws_cognito_app/Presentation/Screens/Login/Login/page/forget_password_page.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/Login/page/login_page.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/Login/page/register_page.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/Login/page/verification_page.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/Login/page/welcome_splash_page.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/UI/config_select_page.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/UI/loading_page.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/UI/restaurant/category_content.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/UI/restaurant/restaurant_page.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/UI/select_page.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/Web/main_web.dart';
import 'package:get/route_manager.dart';

class Routes {
  static String home = '/';
  static String loadingPage = '/loading';
  static String loginPage = '/login';
  static String registerPage = '/register';
  static String resetPasswordPage = '/reset_password';
  static String verificationPage = '/verification';
  static String selectPage = '/select';
  static String configSelectPage = '/config_select';
  static String restaurantPage = '/restaurant';
  static String categoryPage = '/category';

  static String currentPage = '/';

  static String getHomeRoute() => home;
  static String getLoadingPageRoute() => loadingPage;
  static String getLoginPageRoute() => loginPage;
  static String getRegisterPageRoute() => registerPage;
  static String getResetPasswordPageRoute() => resetPasswordPage;
  static String getVerificationPageRoute() => verificationPage;
  static String getSelectPageRoute() => selectPage;
  static String getConfigSelectPageRoute() => configSelectPage;
  static String getRestaurantPageRoute() => restaurantPage;
  static String getCategoryPageRoute() => categoryPage;

  static List<GetPage> routes = [
    GetPage(
      name: home,
      page: () {
        currentPage = home;
        return const WelcomeSplashPage();
        // return const MainWeb();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: loadingPage,
      page: () {
        currentPage = home;
        return const LoadingPage();
      },
      transition: Transition.fade,
    ),
    GetPage(
      name: loginPage,
      page: () {
        currentPage = home;
        return const LoginPage();
      },
      transition: Transition.downToUp,
    ),
    GetPage(
      name: registerPage,
      page: () {
        currentPage = home;
        return const RegisterPage();
      },
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: verificationPage,
      page: () {
        currentPage = home;
        return const VerificationPage();
      },
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: resetPasswordPage,
      page: () {
        currentPage = home;
        return const ForgetPasswordPage();
      },
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: selectPage,
      page: () {
        currentPage = home;
        return const SelectPage();
      },
      transition: Transition.circularReveal,
    ),
    GetPage(
      name: configSelectPage,
      page: () {
        currentPage = home;
        return const ConfigSelectPage();
      },
      transition: Transition.size,
    ),
    GetPage(
      name: restaurantPage,
      page: () {
        currentPage = home;
        return const RestaurantPage();
      },
      transition: Transition.zoom,
    ),
    GetPage(
      name: categoryPage,
      page: () {
        currentPage = home;
        return const CategoryContent();
      },
      transition: Transition.leftToRight,
    ),
  ];
}
