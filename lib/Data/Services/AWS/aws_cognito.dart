// ignore_for_file: use_build_context_synchronously

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:aws_cognito_app/Presentation/Components/alert_dialog.dart';
import 'package:aws_cognito_app/Presentation/Config/config_prefs.dart';
import 'package:aws_cognito_app/Presentation/Routes/routes.dart';
import 'package:aws_cognito_app/Presentation/Services/http_service.dart';
import 'package:aws_cognito_app/app_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/route_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:localstorage/localstorage.dart';

class AWSServices {
  final userPool = CognitoUserPool(
    '${(dotenv.env['POOL_ID'])}',
    '${(dotenv.env['CLIENT_ID'])}',
  );

  final ConfigPrefs configPrefs = ConfigPrefs();

  Future<void> loginUser(
      String email, String password, BuildContext context) async {
    if (!kIsWeb) {
      final appDocDir = await getApplicationDocumentsDirectory();
      AppManager.devicePath = appDocDir.path;
    }

    final cognitoUser = CognitoUser(email, userPool);
    final authDetails =
        AuthenticationDetails(username: email, password: password);

    Get.toNamed(Routes.getLoadingPageRoute());
    try {
      final session = await cognitoUser.authenticateUser(authDetails);
      final accessToken = session?.accessToken.getJwtToken();
      debugPrint('Login Success...');
      debugPrint(accessToken);

      await configPrefs.clearRecords();
      AppManager.awsToken = accessToken!.toString();

      AppManager.responses = await getUserMetadata(email);
      await configPrefs.downloadClientImages(email, AppManager.responses[0].id);
      await configPrefs
          .loadSelectedRecord(email, AppManager.responses[0])
          .then((_) => Get.toNamed(Routes.getSelectPageRoute()));
    } catch (e) {
      debugPrint('Error: $e');
      Get.back();

      String alertDescription = 'Wystąpił nieznany błąd';
      if (e is CognitoUserException) {
        if (e is CognitoUserNewPasswordRequiredException) {
          alertDescription = 'Wymagane jest ustawienie nowego hasła.';
        } else if (e is CognitoUserMfaRequiredException) {
          alertDescription = 'Wymagane uwierzytelnianie MFA.';
        } else if (e is CognitoUserSelectMfaTypeException) {
          alertDescription =
              'Wymagane jest wybranie typu uwierzytelniania (SMS lub TOTP).';
        } else if (e is CognitoUserMfaSetupException) {
          alertDescription =
              'Wymagane jest skonfigurowanie uwierzytelniania MFA.';
        } else if (e is CognitoUserTotpRequiredException) {
          alertDescription = 'Wymagane jest podanie jednorazowego kodu TOTP.';
        } else if (e is CognitoUserCustomChallengeException) {
          alertDescription = 'Wymagane jest niestandardowe wyzwanie.';
        } else if (e is CognitoUserConfirmationNecessaryException) {
          alertDescription = 'Wymagane jest ustawienie potwierdzenia konta.';
        } else {
          alertDescription = 'Błąd użytkownika Cognito.';
        }
      } else {
        if (e.toString().contains('InvalidParameterException') &&
            e.toString().contains('USERNAME')) {
          alertDescription = 'Brakuje jednego z parametrów: E-mail.';
        } else if (e.toString().contains('NotAuthorizedException')) {
          alertDescription = 'Nazwa użytkownika lub hasło są niepoprawne.';
        }
      }

      buildAlertDialog(context: context, alertDescription: alertDescription);
    }
  }

  Future<void> registerUser(
      String name, String email, String password, BuildContext context) async {
    //phoneNum
    final userAttributes = [
      AttributeArg(name: 'name', value: name),
    ];

    Get.toNamed(Routes.getLoadingPageRoute());
    try {
      await userPool
          .signUp(email, password, userAttributes: userAttributes)
          .then((_) => Get.toNamed(
                Routes.getVerificationPageRoute(),
                arguments: {'email': email},
              ));
    } on CognitoClientException catch (e) {
      debugPrint('Error: $e');
      Get.back();

      String alertDescription = 'Wystąpił nieznany błąd.';
      if (e.message!.contains('validation')) {
        alertDescription =
            'Błąd walidacji hasła: musi składać się z co najmniej jednej małej i dużej litery oraz znaku specjalnego i cyfry.';
      } else if (e.message!.contains('should be an email')) {
        alertDescription = 'Niepoprawny adres E-mail.';
      } else if (e.message!.contains('already exists')) {
        alertDescription = 'Podany adres E-mail już istnieje.';
      } else {
        alertDescription = 'Błąd użytkownika Cognito: ${e.message}';
      }

      buildAlertDialog(
        context: context,
        alertDescription: alertDescription,
      );
    } catch (e) {
      Get.back();
      debugPrint('Error: $e');

      buildAlertDialog(
        context: context,
        alertDescription: 'Nieznany błąd: $e',
      );
    }
  }

  Future<void> registerConfirmation(
      String email, String verificationCode, BuildContext context) async {
    final cognitoUser = CognitoUser(email, userPool);

    Get.toNamed(Routes.getLoadingPageRoute());
    try {
      await cognitoUser.confirmRegistration(verificationCode);
      await configPrefs.clearRecords();
      await getUserMetadata(email);
      await configPrefs
          .loadSelectedRecord(email, AppManager.responses[0])
          .then((_) => Get.toNamed(Routes.getSelectPageRoute()));

      debugPrint('Kod potwierdzający zweryfikowany pomyślnie.');
    } on CognitoClientException catch (e) {
      Get.back();
      buildAlertDialog(
        context: context,
        alertDescription: 'Błąd klienta Cognito: ${e.message}',
      );
    } catch (e) {
      Get.back();
      buildAlertDialog(
        context: context,
        alertDescription: 'Inny błąd: $e',
      );
    }
  }

  Future<void> logoutUser(String email, BuildContext context) async {
    final user = CognitoUser(email, userPool);

    Navigator.of(context).pushNamed('/loading');
    try {
      await configPrefs.clearRecords();
      await user
          .signOut()
          .then((value) => Get.toNamed(Routes.getLoginPageRoute()));
      debugPrint('Wylogowano z Cognito.');
    } catch (e) {
      debugPrint('Błąd podczas wylogowywania: $e');
      Get.back();
    }
  }

  Future<void> resendConfirmationCode(
      String email, BuildContext context) async {
    final cognitoUser = CognitoUser(email, userPool);
    String dialogMessage = '';
    String dialogTitle = '';

    try {
      await cognitoUser.resendConfirmationCode();
      dialogMessage = 'Wysłano ponownie kod weryfikacyjny.';
      dialogTitle = 'Wysłano!';
    } catch (e) {
      dialogMessage = 'Błąd podczas wysyłania kodu weryfikacyjnego: $e';
      dialogTitle = 'Błąd!';
    }

    buildAlertDialog(
      context: context,
      alertDescription: dialogMessage,
      title: dialogTitle,
    );
  }
}
