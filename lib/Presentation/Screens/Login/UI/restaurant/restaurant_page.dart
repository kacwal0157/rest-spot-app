import 'package:aws_cognito_app/Presentation/Components/app_bar.dart';
import 'package:aws_cognito_app/Presentation/Declarations/Constants/constant_enums.dart';
import 'package:aws_cognito_app/Presentation/Models/config_model.dart';
import 'package:aws_cognito_app/app_manager.dart';
import 'package:aws_cognito_app/Presentation/Models/hex_color.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/Widgets/edit_mode_widget.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/Widgets/language_widget.dart';
import 'package:aws_cognito_app/Presentation/Services/layout_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Services/config_service.dart';

class RestaurantPage extends StatefulWidget {
  const RestaurantPage({super.key});

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  final args = Get.arguments as Map<String, dynamic>;

  @override
  void initState() {
    AppManager.editMode = args['editMode'];

    if (args['configFile'] != null) {
      ConfigService.fileName = args['configFile'];
    }
    super.initState();
  }

  _refreshState() {
    setState(() {});
  }

  _setCurrentState() {
    AppManager.currentRoute = '/main';
    AppManager.mainPageCallback = _refreshState;
    AppManager.currentColor = AppManager.config.mainColor;
    AppManager.currentFont = AppManager.config.fontFamily;
    AppManager.currentFontColor = AppManager.config.fontColor;
    AppManager.currentLanguages = AppManager.config.supportedLanguages;
    AppManager.currentCategories = AppManager.config.categories;
  }

  @override
  Widget build(BuildContext context) {
    _setCurrentState();

    ConfigModel config = AppManager.config;
    var layoutService =
        LayoutService(config, AppManager.languageService, _refreshState);

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: buildAppBar(
          canReturn: false,
          context: context,
          inApp: true,
          actionWidgets: [
            LanguageWidget(
                languageService: AppManager.languageService,
                pageCallback: _refreshState),
            //ShopingWidget(),
          ],
          appBarTitle: AppManager.languageService.getRestaurantDescription(),
          color: HexColor(config.mainColor),
          fontFamily: config.fontFamily,
          fontSize: config.secondaryFontSize,
          fontColor: HexColor(config.fontColor),
          iconColor: HexColor(config.fontColor),
        ),
        backgroundColor: HexColor(config.mainColor),
        body: GestureDetector(
            onTap: () {
              // Handle the tap gesture anywhere within the CustomScrollView
              print('Touched anywhere within the CustomScrollView');
            },
            child: Stack(
              children: [
                CustomScrollView(
                  slivers: layoutService.getCategoryLayout(context),
                ),
                AppManager.editMode
                    ? EditModeWidget(
                        pageCallback: _refreshState,
                        editingPage: EditingPage.main)
                    : Container(),
              ],
            )),
      ),
    );
  }
}
