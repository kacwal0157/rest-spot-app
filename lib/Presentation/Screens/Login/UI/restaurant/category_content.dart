import 'package:aws_cognito_app/Presentation/Components/app_bar.dart';
import 'package:aws_cognito_app/Presentation/Declarations/Constants/constant_enums.dart';
import 'package:aws_cognito_app/Presentation/Models/Data/category_data.dart';
import 'package:aws_cognito_app/Presentation/Models/hex_color.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/Widgets/edit_mode_widget.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/Widgets/language_widget.dart';
import 'package:aws_cognito_app/app_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryContent extends StatefulWidget {
  const CategoryContent({super.key});

  @override
  State<CategoryContent> createState() => _CategoryContentState();
}

class _CategoryContentState extends State<CategoryContent> {
  final args = Get.arguments as CategoryData;

  _refreshState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    AppManager.currentRoute = '/card';

    return Scaffold(
      appBar: buildAppBar(
        canReturn: true,
        context: context,
        inApp: true,
        actionWidgets: [
          LanguageWidget(
              languageService: AppManager.languageService,
              pageCallback: _refreshState),
          //ShopingWidget(),
        ],
        appBarTitle: AppManager.languageService
            .getCategoryName(args.category.id, args.layoutService.configModel),
        color: HexColor(args.layoutService.configModel.mainColor),
        fontFamily: args.layoutService.configModel.fontFamily,
        fontSize: AppManager.config.secondaryFontSize,
        fontColor: HexColor(args.layoutService.configModel.fontColor),
        iconColor: HexColor(args.layoutService.configModel.fontColor),
      ),
      backgroundColor: HexColor(args.layoutService.configModel.mainColor),
      body: Stack(
        children: [
          AppManager.editMode
              ? CustomScrollView(
                  slivers: args.layoutService
                      .getDishLayout(context, args.category, _refreshState),
                )
              : NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    return false;
                  },
                  child: CustomScrollView(
                    slivers: args.layoutService
                        .getDishLayout(context, args.category, _refreshState),
                  ),
                ),
          AppManager.editMode
              ? EditModeWidget(
                  pageCallback: _refreshState,
                  editingPage: EditingPage.card,
                  category: args.category)
              : Container(),
        ],
      ),
    );
  }
}
