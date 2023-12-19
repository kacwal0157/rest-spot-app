import 'package:aws_cognito_app/Presentation/Declarations/Constants/constant_enums.dart';
import 'package:aws_cognito_app/Presentation/Models/config_model.dart';
import 'package:aws_cognito_app/app_manager.dart';
import 'package:flutter/material.dart';

class NameEditorWidget extends StatefulWidget {
  const NameEditorWidget(
      {super.key,
      required this.contentPage,
      required this.pageContent,
      this.category,
      this.dish});

  final ContentPage contentPage;
  final String pageContent;
  final Category? category;
  final Dish? dish;

  @override
  State<NameEditorWidget> createState() => _NameEditorWidgetState();
}

class _NameEditorWidgetState extends State<NameEditorWidget> {
  String ingredients = '';

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      for (String language in AppManager.config.supportedLanguages)
        _getTextField(language),
      const SizedBox(height: 30.0),
    ]);
  }

  _getTextField(String languageCode) {
    return TextField(
      decoration: InputDecoration(
        labelText: '${widget.pageContent} ($languageCode)',
      ),
      controller: TextEditingController(
        text: _insertName(languageCode),
      ),
      onChanged: (value) {
        _saveName(languageCode, value);
      },
    );
  }

  String? _insertName(String languageCode) {
    switch (widget.contentPage) {
      case ContentPage.main:
        return AppManager.config.restaurantName[languageCode];
      case ContentPage.category:
        return AppManager.config.categories
            .firstWhere((category) => category == widget.category)
            .name[languageCode];
      case ContentPage.dish:
        return AppManager.config.categories
            .firstWhere((category) => category == widget.category)
            .dishes
            .firstWhere((dish) => dish == widget.dish)
            .name[languageCode];
      case ContentPage.ingredient:
        ingredients = '';
        for (var ingredient in AppManager.config.categories
            .firstWhere((category) => category == widget.category)
            .dishes
            .firstWhere((dish) => dish == widget.dish)
            .ingredients) {
          ingredients += ingredient.name[languageCode]!;
          ingredients += ', ';
        }

        return ingredients;
    }
  }

  _saveName(String languageCode, String name) {
    switch (widget.contentPage) {
      case ContentPage.main:
        AppManager.configService.editMainName(languageCode, name);
        break;
      case ContentPage.category:
        AppManager.configService
            .editCategoryName(widget.category!.id, languageCode, name);
        break;
      case ContentPage.dish:
        AppManager.configService.editDishName(
            widget.category!.id, widget.dish!.id, languageCode, name);
        break;
      case ContentPage.ingredient:
        AppManager.configService.editDishIngredients(
            widget.category!.id, widget.dish!.id, languageCode, name);
        break;
    }

    AppManager.mainPageCallback();
  }
}
