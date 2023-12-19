import 'app_manager.dart';
import 'package:aws_cognito_app/Presentation/Declarations/Constants/constant_variables.dart';
import 'package:aws_cognito_app/Presentation/Routes/routes.dart';
import 'package:get/route_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppManager();
    return GestureDetector(
      onTap: () {
        print("Touched in parent component");
        // FocusScopeNode currentFocus = FocusScope.of(context);
        // if (!currentFocus.hasPrimaryFocus) {
        //   currentFocus.unfocus();
        // }

        if (!AppManager.editMode) {
          AppManager.returnTimer.resetTimer();
          AppManager.returnTimer.startTimer(context);
        }
      },
      onTapCancel: () {
        AppManager.returnTimer.resetTimer();
        AppManager.returnTimer.startTimer(context);
      },
      child: GetMaterialApp(
        title: 'rest_spot',
        theme: customThemeData,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.getHomeRoute(),
        getPages: Routes.routes,
      ),
    );
  }
}
