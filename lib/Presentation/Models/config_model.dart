class ConfigModel {
  Map<String, String> restaurantName;
  Map<String, String> restaurantDescription;
  List<String> supportedLanguages;
  bool customImage;
  String imagePath;
  String fontFamily;
  String fontColor;
  double fontSize;
  double secondaryFontSize;
  String mainColor;
  Map<String, int> categoryLayout;
  List<Category> categories;

  ConfigModel({
    required this.restaurantName,
    required this.restaurantDescription,
    required this.supportedLanguages,
    required this.customImage,
    required this.imagePath,
    required this.fontFamily,
    required this.fontColor,
    required this.fontSize,
    required this.secondaryFontSize,
    required this.mainColor,
    required this.categoryLayout,
    required this.categories,
  });

  factory ConfigModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> categoriesJson = json['categories'];

    return ConfigModel(
      restaurantName: Map<String, String>.from(json['restaurantName']),
      restaurantDescription:
          Map<String, String>.from(json['restaurantDescription']),
      supportedLanguages: List<String>.from(json['supportedLanguages']),
      customImage: json['customImage'],
      imagePath: json['imagePath'],
      fontFamily: json['fontFamily'],
      fontColor: json['fontColor'],
      fontSize: json['fontSize'].toDouble(),
      secondaryFontSize: json['secondaryFontSize'].toDouble(),
      mainColor: json['mainColor'],
      categoryLayout: Map<String, int>.from(json['categoryLayout']),
      categories: categoriesJson
          .map((categoryJson) => Category.fromJson(categoryJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'restaurantName': Map<String, String>.from(restaurantName),
      'restaurantDescription': Map<String, String>.from(restaurantDescription),
      'supportedLanguages': supportedLanguages,
      'customImage': customImage,
      'imagePath': imagePath,
      'fontFamily': fontFamily,
      'fontColor': fontColor,
      'fontSize': fontSize,
      'secondaryFontSize': secondaryFontSize,
      'mainColor': mainColor,
      'categoryLayout': Map<String, int>.from(categoryLayout),
      'categories': categories.map((category) => category.toJson()).toList(),
    };
  }
}

class Category {
  String id;
  Map<String, String> name;
  bool customImage;
  String imagePath;
  List<Dish> dishes;

  Category({
    required this.id,
    required this.name,
    required this.customImage,
    required this.imagePath,
    required this.dishes,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    List<dynamic> dishesJson = json['dishes'];

    return Category(
      id: json['id'],
      name: Map<String, String>.from(json['name']),
      customImage: json['customImage'],
      imagePath: json['imagePath'],
      dishes: dishesJson.map((dishJson) => Dish.fromJson(dishJson)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': Map<String, String>.from(name),
      'customImage': customImage,
      'imagePath': imagePath,
      'dishes': dishes.map((dish) => dish.toJson()).toList(),
    };
  }
}

class Dish {
  String id;
  Map<String, String> name;
  bool customImage;
  String imagePath;
  double price;
  String currency;
  List<Ingredient> ingredients;

  Dish({
    required this.id,
    required this.name,
    required this.customImage,
    required this.imagePath,
    required this.price,
    required this.currency,
    required this.ingredients,
  });

  factory Dish.fromJson(Map<String, dynamic> json) {
    List<dynamic> ingredientsJson = json['ingredients'];

    return Dish(
      id: json['id'],
      name: Map<String, String>.from(json['name']),
      customImage: json['customImage'],
      imagePath: json['imagePath'],
      price: json['price'].toDouble(),
      currency: json['currency'],
      ingredients: ingredientsJson
          .map((ingredientJson) => Ingredient.fromJson(ingredientJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': Map<String, String>.from(name),
      'customImage': customImage,
      'imagePath': imagePath,
      'price': price,
      'currency': currency,
      'ingredients':
          ingredients.map((ingredient) => ingredient.toJson()).toList(),
    };
  }
}

class Ingredient {
  Map<String, String> name;
  String imagePath;

  Ingredient({
    required this.name,
    required this.imagePath,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: Map<String, String>.from(json['name']),
      imagePath: json['imagePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': Map<String, String>.from(name),
      'imagePath': imagePath,
    };
  }
}
