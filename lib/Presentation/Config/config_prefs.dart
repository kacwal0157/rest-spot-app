import 'package:aws_cognito_app/Presentation/Config/data_fetcher.dart';
import 'package:aws_cognito_app/Presentation/Declarations/Constants/constant_enums.dart';
import 'package:aws_cognito_app/Presentation/Models/Data/response_data.dart';
import 'package:aws_cognito_app/Presentation/Models/config_model.dart';
import 'package:aws_cognito_app/Presentation/Services/config_service.dart';
import 'package:aws_cognito_app/Presentation/Services/language_service.dart';
import 'package:aws_cognito_app/Presentation/Services/shopping_service.dart';
import 'package:aws_cognito_app/app_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigPrefs {
  Future<void> saveSelectedRecord(String selectedConfig) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedConfig', selectedConfig);
  }

  Future<void> loadSelectedRecord(
      String email, ResponseData responseData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var selectedConfig =
        prefs.getString('selectedConfig') ?? AppManager.CONFIG_1;

    await setConfigFile(email, responseData, selectedConfig);
  }

  Future<void> downloadClientImages(String email, String id) async {
    await downloadImages(email, id);
  }

  Future<void> clearRecords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();

    AppManager.awsToken = '';
    AppManager.config = ConfigModel(
      restaurantName: {},
      restaurantDescription: {},
      supportedLanguages: [],
      customImage: false,
      imagePath: '',
      fontFamily: '',
      fontColor: '',
      fontSize: 0,
      secondaryFontSize: 0,
      mainColor: '',
      categoryLayout: {},
      categories: [],
    );
    AppManager.configService = ConfigService();
    AppManager.currentCategories = [];
    AppManager.currentColor = '';
    AppManager.currentFont = '';
    AppManager.currentFontColor = '';
    AppManager.currentFontSize = 0;
    AppManager.editMode = false;
    AppManager.imagesByBytes = {};
    AppManager.isEditMode = false;
    AppManager.language = Languages.pl;
    AppManager.languageService = LanguageService();
    AppManager.mainPageCallback = () {};
    AppManager.responses = [];
    AppManager.selectedConfig = 'config_1';
    AppManager.selectedConfigId = '';
    AppManager.shoppingService = ShoppingService();
    AppManager.userID = '';
    AppManager.userMail = '';
  }
}
