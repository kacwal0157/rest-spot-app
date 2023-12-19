import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:aws_cognito_app/Presentation/Config/config_prefs.dart';
import 'package:aws_cognito_app/Presentation/Services/image_service.dart';
import 'package:aws_cognito_app/Presentation/Declarations/Constants/constant_functions.dart';
import 'package:aws_cognito_app/Presentation/Models/config_model.dart';
import 'package:aws_cognito_app/app_manager.dart';
import 'package:aws_cognito_app/Presentation/Config/data_fetcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ConfigService {
  ConfigService();

  static String fileName = 'config_0';

  updateConfigFile(Function pageCallbkack) async {
    // final path = await getDocumentsDirectoryPath();
    // final configFile = File('$path/$fileName');

    // await configFile.writeAsString(jsonEncode(AppManager.config));
    AppManager.isEditMode = false;

    //await ImageService().createAndSaveZip(fileName);

    await ConfigPrefs().saveSelectedRecord(fileName);
    await postConfigFile(
      AppManager.userMail,
      AppManager.selectedConfigId,
    );

    pageCallbkack();
  }

  Future<File> editMainImage(Uint8List imageBytes) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    File file = File('${appDocDir.path}/images/main_image');
    file.writeAsBytes(imageBytes);

    AppManager.config.imagePath = '${appDocDir.path}/images/main_image';
    AppManager.config.customImage = true;

    await ImageService().addImageToZip(imageBytes, 'main_image');

    return file;
  }

  Future<void> editMainImageWeb(Uint8List imageBytes) async {
    AppManager.config.customImage = true;

    AppManager.storage.setItem('main_image', base64Encode(imageBytes));
  }

  Future<File> editContentImage(
      String categoryID, Uint8List imageStream) async {
    final category = AppManager.config.categories
        .firstWhere((category) => category.id == categoryID);

    Directory appDocDir = await getApplicationDocumentsDirectory();

    File file = File('${appDocDir.path}/images/category_$categoryID');
    file.writeAsBytes(imageStream);

    category.customImage = true;
    category.imagePath = '${appDocDir.path}/images/category_$categoryID';

    await ImageService().addImageToZip(imageStream, 'category_$categoryID');

    return file;
  }

  Future<void> editContentImageWeb(
      String categoryID, Uint8List imageStream) async {
    final category = AppManager.config.categories
        .firstWhere((category) => category.id == categoryID);

    category.customImage = true;
    AppManager.storage
        .setItem('category_$categoryID', base64Encode(imageStream));
  }

  Future<File> editDishImage(
      String categoryID, String dishID, Uint8List imageStream) async {
    final category = AppManager.config.categories
        .firstWhere((category) => category.id == categoryID);
    final dish = category.dishes.firstWhere((dish) => dish.id == dishID);

    var imageBytes = imageStream;
    Directory appDocDir = await getApplicationDocumentsDirectory();
    File file = File('${appDocDir.path}/images/dish_$dishID');
    file.writeAsBytes(imageBytes);

    dish.customImage = true;
    dish.imagePath = '${appDocDir.path}/images/dish_$dishID';

    await ImageService().addImageToZip(imageStream, 'dish_$dishID');

    return file;
  }

  Future<void> editDishImageWeb(
      String categoryID, String dishID, Uint8List imageStream) async {
    final category = AppManager.config.categories
        .firstWhere((category) => category.id == categoryID);
    final dish = category.dishes.firstWhere((dish) => dish.id == dishID);
    dish.customImage = true;

    AppManager.storage.setItem('dish_$dishID', base64Encode(imageStream));
  }

  editCategoryLayout(int rows, int cols) async {
    AppManager.config.categoryLayout['numberInRow'] = rows;
    AppManager.config.categoryLayout['numberInCol'] = cols;

    AppManager.mainPageCallback();
  }

  editMainFont() async {
    AppManager.currentFont = AppManager.config.fontFamily;
    AppManager.currentFontSize = AppManager.config.fontSize;
    AppManager.currentSecondaryFontSize = AppManager.config.secondaryFontSize;

    AppManager.mainPageCallback();
  }

  editColors() async {
    AppManager.currentColor = AppManager.config.mainColor;
    AppManager.currentFontColor = AppManager.config.fontColor;

    AppManager.mainPageCallback();
  }

  editDishPrice(String categoryID, String dishID, double price) async {
    final category = AppManager.config.categories
        .firstWhere((category) => category.id == categoryID);
    final dish = category.dishes.firstWhere((dish) => dish.id == dishID);

    dish.price = price;
  }

  editSupportedLanguages(List<String> languages) async {
    AppManager.config.supportedLanguages = languages;
    AppManager.currentLanguages = AppManager.config.supportedLanguages;
  }

  editMainName(String language, String name) async {
    AppManager.config.restaurantName[language] = name;
  }

  editCategoryName(String categoryID, String language, String name) async {
    final category = AppManager.config.categories
        .firstWhere((category) => category.id == categoryID);

    category.name[language] = name;
  }

  editDishName(
      String categoryID, String dishID, String language, String name) async {
    final category = AppManager.config.categories
        .firstWhere((category) => category.id == categoryID);
    final dish = category.dishes.firstWhere((dish) => dish.id == dishID);

    dish.name[language] = name;
  }

  editDishIngredients(
      String categoryID, String dishID, String language, String name) async {
    final category = AppManager.config.categories
        .firstWhere((category) => category.id == categoryID);

    final dish = category.dishes.firstWhere((dish) => dish.id == dishID);
    final values = name.split(',').map((value) => value.trim()).toList();

    while (values.length > dish.ingredients.length) {
      dish.ingredients.add(getEmptyIngredient());
    }

    for (var i = 0; i < values.length; i++) {
      dish.ingredients[i].name[language] = values[i];
    }

    if (values.length < dish.ingredients.length) {
      dish.ingredients.removeRange(values.length, dish.ingredients.length);
    }
  }

  editContentAmount(List<Category> categories) {
    AppManager.config.categories = categories;
    AppManager.currentCategories = AppManager.config.categories;
  }
}
