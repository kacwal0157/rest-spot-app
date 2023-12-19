import 'package:aws_cognito_app/Presentation/Declarations/Constants/constant_enums.dart';
import 'package:aws_cognito_app/Presentation/Models/config_model.dart';
import 'package:aws_cognito_app/app_manager.dart';

class LanguageService {
  LanguageService();

  ConfigModel config = AppManager.config;
  Languages activeLanguage = AppManager.language;

  static final Map<String, Languages> languageCodeMapping = {
    'PL': Languages.pl,
    'GB': Languages.gb,
    'DE': Languages.de,
    'ES': Languages.es,
  };

  void changeLanguage(String languageCode) {
    if (languageCodeMapping.containsKey(languageCode)) {
      activeLanguage = languageCodeMapping[languageCode]!;
      AppManager.language = activeLanguage;
    }
  }

  void _updateLanguage() {
    activeLanguage = AppManager.language;
  }

  String _getTranslatedName(Map<String, String> names) {
    _updateLanguage();
    String? translatedName =
        names[activeLanguage.toString().split('.').last.toUpperCase()];
    return translatedName ?? 'Language Error!';
  }

  String getRestaurantName() {
    return _getTranslatedName(AppManager.config.restaurantName);
  }

  String getRestaurantDescription() {
    return _getTranslatedName(AppManager.config.restaurantDescription);
  }

  String getCategoryName(String categoryUUID, ConfigModel configModel) {
    config = configModel;
    int categoryIndex =
        config.categories.indexWhere((element) => element.id == categoryUUID);
    return _getTranslatedName(config.categories[categoryIndex].name);
  }

  String getDishName(String categoryUUID, String dishUUID) {
    int categoryIndex =
        AppManager.config.categories.indexWhere((element) => element.id == categoryUUID);
    int dishIndex = AppManager.config.categories[categoryIndex].dishes
        .indexWhere((element) => element.id == dishUUID);
    return _getTranslatedName(
        AppManager.config.categories[categoryIndex].dishes[dishIndex].name);
  }

  String getIngredientName(
      String categoryUUID, String dishUUID, int ingredientIndex) {
    int categoryIndex =
        AppManager.config.categories.indexWhere((element) => element.id == categoryUUID);
    int dishIndex = AppManager.config.categories[categoryIndex].dishes
        .indexWhere((element) => element.id == dishUUID);
    return _getTranslatedName(AppManager.config.categories[categoryIndex].dishes[dishIndex]
        .ingredients[ingredientIndex].name);
  }
}
