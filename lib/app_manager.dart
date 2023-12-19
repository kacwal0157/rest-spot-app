import 'dart:typed_data';

import 'package:aws_cognito_app/Presentation/Declarations/Constants/constant_enums.dart';
import 'package:aws_cognito_app/Presentation/Models/Data/response_data.dart';
import 'package:aws_cognito_app/Presentation/Models/config_model.dart';
import 'package:aws_cognito_app/Presentation/Services/config_service.dart';
import 'package:aws_cognito_app/Presentation/Services/language_service.dart';
import 'package:aws_cognito_app/Presentation/Services/shopping_service.dart';
import 'package:aws_cognito_app/Presentation/Utils/return_timer.dart';
import 'package:localstorage/localstorage.dart';

import 'Presentation/Services/browser_image_storage.dart';

class AppManager {
  //*LANGUAGE
  static Languages language = Languages.pl;

  static BrowserImageStorage storage = BrowserImageStorage();

  //*URLS
  static const String url =
      'https://lq0hjcqtve.execute-api.eu-central-1.amazonaws.com/prod';

  static const String CONFIG_1 = 'config_1';

  //*CALLBACK
  static Function mainPageCallback = () {};

  //*AWS
  static String userMail = '';
  static String userID = '';
  static List<ResponseData> responses = <ResponseData>[];
  static String awsToken = '';

  //*EDIT_MODE
  static bool editMode = false;

  //*NAMES
  static bool isEditMode = false;

  //*LANGUAGE
  static List<String> currentLanguages = <String>[];

  //*COLOR
  static String currentColor = '';
  static String currentFontColor = '';

  //*FONT
  static String currentFont = '';
  static double currentFontSize = 50.0;
  static double currentSecondaryFontSize = 25.0;

  //*CONFIG
  static ConfigModel config = ConfigModel(
      restaurantName: <String, String>{},
      restaurantDescription: <String, String>{},
      supportedLanguages: <String>[],
      customImage: false,
      imagePath: "imagePath",
      fontFamily: "fontFamily",
      fontColor: "fontColor",
      fontSize: 50.0,
      secondaryFontSize: 25.0,
      mainColor: "mainColor",
      categoryLayout: <String, int>{},
      categories: <Category>[]);
  static ConfigService configService = ConfigService();
  static String selectedConfig = 'config_1';
  static String selectedConfigId = 'UUID';

  //*ROUTE
  static String currentRoute = '';

  //*CATEGORY
  static List<Category> currentCategories = <Category>[];

  //*IMAGES
  static Map<String, Uint8List> imagesByBytes = <String, Uint8List>{};

  //*WIDGET SERVICES
  static ShoppingService shoppingService = ShoppingService();
  static LanguageService languageService = LanguageService();

  //*TIME
  static ReturnTimer returnTimer = ReturnTimer(5);

  //#PATH
  static String devicePath = "";

  AppManager._();

  static final AppManager _instance = AppManager._();
  factory AppManager() => _instance;
}
