import 'dart:convert';
import 'dart:io';

import 'package:aws_cognito_app/Presentation/Declarations/Constants/constant_enums.dart';
import 'package:aws_cognito_app/Presentation/Declarations/Constants/constant_functions.dart';
import 'package:aws_cognito_app/Presentation/Models/Data/category_data.dart';
import 'package:aws_cognito_app/Presentation/Models/config_model.dart';
import 'package:aws_cognito_app/Presentation/Routes/routes.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/UI/restaurant/dish_details.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/UI/restaurant/menu_card.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/Widgets/EditMode/content_editor_widget.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/Widgets/custom_image_widget.dart';
import 'package:aws_cognito_app/app_manager.dart';
import 'package:aws_cognito_app/Presentation/Models/hex_color.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/UI/restaurant/dish_content.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/UI/restaurant/ingredient_content.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/Widgets/image_widget.dart';
import 'package:aws_cognito_app/Presentation/Services/language_service.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class LayoutService {
  ConfigModel configModel;
  LanguageService languageService;
  Function mainPageCallback;

  LayoutService(this.configModel, this.languageService, this.mainPageCallback);

  List<Widget> getCategoryLayout(BuildContext context) {
    var widgets = <Widget>[];
    widgets.add(_getSilverAppBar());
    widgets.add(_getHorizontalLayoutLine());

    var rows = configModel.categoryLayout["numberInRow"]! + 1;
    var cols = configModel.categoryLayout["numberInCol"]! + 1;

    for (var row = 0; row < rows; row++) {
      var categoryCards = <CategoryCard>[];
      for (var col = 0; col < cols; col++) {
        if (row * cols + col >= configModel.categories.length) {
          break;
        }

        categoryCards.add(_getCategoryCard(
            configModel.categories[row * cols + col], context));
      }

      widgets.add(_getCategorySilver(categoryCards));
      widgets.add(_getHorizontalLayoutLine());
    }

    return widgets;
  }

  List<Widget> getDishLayout(BuildContext context, Category category,
      Function categoryContentPageCallback) {
    var widgets = <Widget>[];

    widgets.add(_getHorizontalLayoutLine());
    for (var dish in category.dishes) {
      widgets.add(
          _getDishSilver(context, category, dish, categoryContentPageCallback));
      widgets.add(_getHorizontalLayoutLine());
    }

    return widgets;
  }

  SliverToBoxAdapter _getCategorySilver(List<CategoryCard> categoryCardsInRow) {
    var widgets = <Widget>[];
    for (var element in categoryCardsInRow) {
      widgets.add(element);

      if (categoryCardsInRow.indexOf(element) < categoryCardsInRow.length - 1) {
        widgets.add(Expanded(
          child: Container(
            width: 8,
            height: 250,
            color: HexColor(configModel.mainColor),
          ),
        ));
      }
    }

    return SliverToBoxAdapter(child: Row(children: widgets));
  }

  CategoryCard _getCategoryCard(Category category, BuildContext context) {
    return CategoryCard(
        onTap: !AppManager.isEditMode
            ? () {
                Get.toNamed(Routes.getCategoryPageRoute(),
                        arguments: CategoryData(category, this))!
                    .then((_) => AppManager.mainPageCallback());
              }
            : () {
                showDialog(
                    context: context,
                    builder: (context) => ContentEditorWidget(
                        configService: AppManager.configService,
                        contentPage: ContentPage.category,
                        pageCallback: mainPageCallback,
                        imagePage: ImagePage.category,
                        category: category));
              },
        category: category,
        title: languageService.getCategoryName(category.id, configModel),
        fontFamily: configModel.fontFamily,
        fontSize: configModel.fontSize,
        fontColor: configModel.fontColor);
  }

  SliverToBoxAdapter _getHorizontalLayoutLine() {
    return SliverToBoxAdapter(
      child: Row(children: <Widget>[
        Expanded(
          flex: 5,
          child: Container(
              height: 8, color: darken(HexColor(configModel.mainColor), 0.03)),
        ),
      ]),
    );
  }

  SliverAppBar _getSilverAppBar() {
    return SliverAppBar(
        automaticallyImplyLeading: false,
        pinned: true,
        snap: true,
        floating: true,
        backgroundColor: HexColor(configModel.mainColor),
        expandedHeight: 350.0,
        flexibleSpace: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return AppManager.editMode
              ? Stack(children: [
                  Container(
                    alignment: Alignment.center,
                    child: ImageWidget(
                        pageCallback: mainPageCallback,
                        imagePage: ImagePage.main,
                        onTap: AppManager.isEditMode
                            ? () => showDialog(
                                context: context,
                                builder: (context) => ContentEditorWidget(
                                    configService: AppManager.configService,
                                    contentPage: ContentPage.main,
                                    pageCallback: mainPageCallback,
                                    imagePage: ImagePage.main))
                            : null),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      languageService.getRestaurantName(),
                      style: TextStyle(
                          color: HexColor(configModel.fontColor),
                          fontFamily: configModel.fontFamily,
                          fontSize: configModel.fontSize),
                    ),
                  ),
                ])
              : Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: configModel.customImage
                          ? foundation.kIsWeb
                              ? MemoryImage(base64Decode(AppManager.storage
                                  .getImageBase64("main_image")))
                              : FileImage(File(configModel.imagePath))
                                  as ImageProvider
                          : AssetImage(configModel.imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: SizedBox(
                      child: Text(
                    languageService.getRestaurantName(),
                    style: TextStyle(
                        color: HexColor(configModel.fontColor),
                        fontFamily: configModel.fontFamily,
                        fontSize: configModel.fontSize),
                  )));
        }));
  }

  SliverToBoxAdapter _getDishSilver(BuildContext context, Category category,
      Dish dish, Function categoryContentPageCallback) {
    double screenWidth = MediaQuery.of(context).size.width;
    var ingredientContents = <IngredientContent>[];

    for (var ingredient in dish.ingredients) {
      ingredientContents.add(IngredientContent(
        name: languageService
            .getIngredientName(
                category.id, dish.id, dish.ingredients.indexOf(ingredient))
            .toUpperCase(),
        color: HexColor(configModel.mainColor),
        fontFamily: configModel.fontFamily,
        fontColor: configModel.fontColor,
        width: 200.0,
      ));
    }

    return SliverToBoxAdapter(
        child: GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => AppManager.isEditMode
              ? ContentEditorWidget(
                  configService: AppManager.configService,
                  contentPage: ContentPage.dish,
                  pageCallback: categoryContentPageCallback,
                  imagePage: ImagePage.dish,
                  category: category,
                  dish: dish)
              : DishDetails(
                  color: HexColor(configModel.mainColor),
                  imagePath: dish.customImage
                      ? "${AppManager.devicePath}/images/dish_${dish.id}"
                      : dish.imagePath,
                  customImage: dish.customImage,
                  dish: dish,
                ),
        );
      },
      child: Row(
        children: [
          Container(
              height: 200,
              width: screenWidth * 0.4,
              alignment: Alignment.center,
              child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: AppManager.editMode
                      ? ImageWidget(
                          pageCallback: categoryContentPageCallback,
                          imagePage: ImagePage.dish,
                          category: category,
                          dish: dish)
                      : CustomImageWidget(dish: dish)

                  // dish.customImage
                  //     ? Image.file(
                  //         File(
                  //             "${AppManager.devicePath}/images/dish_${dish.id}"),
                  //         fit: BoxFit.cover,
                  //         height: 250,
                  //         width: double.infinity)
                  //     : Image.asset(
                  //         dish.imagePath,
                  //         fit: BoxFit.cover,
                  //         height: 250,
                  //         width: double.infinity,
                  //       ),
                  )),
          DishContent(
              name: languageService.getDishName(category.id, dish.id),
              fontFamily: configModel.fontFamily,
              fontSize: configModel.secondaryFontSize,
              fontColor: configModel.fontColor,
              ingredientsString: _getConcatanatedIngredients(
                  category.id, dish.id, dish.ingredients),
              width: (screenWidth * 0.4),
              color: HexColor(configModel.mainColor),
              ingredients: ingredientContents),
          Container(
            height: 200,
            width: screenWidth * 0.2,
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: Text(
                      '${dish.currency} ${dish.price.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: HexColor(configModel.fontColor),
                          fontFamily: configModel.fontFamily,
                          fontSize: configModel.secondaryFontSize - 5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

  String _getConcatanatedIngredients(
      String categoryUUID, String dishUUID, List<Ingredient> ingredients) {
    String value = '';
    for (var element in ingredients) {
      value += languageService.getIngredientName(
          categoryUUID, dishUUID, ingredients.indexOf(element));
      if (ingredients.indexOf(element) < ingredients.length - 1) {
        value += ', ';
      }
    }
    return value;
  }
}
