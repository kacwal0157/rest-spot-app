import 'package:aws_cognito_app/Presentation/Models/config_model.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

Color darken(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

getEmptyCategory() {
  var randomUUID = const Uuid().v4();
  Map<String, String> emptyCategoryNames = {
    'PL': 'Pusta kategoria',
    'GB': 'Empty category',
    'DE': 'Leere kategorie',
    'ES': 'Categoría vacía',
  };

  return Category(
      id: randomUUID,
      name: emptyCategoryNames,
      customImage: false,
      imagePath: 'assets/images/photo1.jpg',
      dishes: []);
}

getEmptyDish() {
  var randomUUID = const Uuid().v4();
  Map<String, String> emptyDishNames = {
    'PL': 'Pusta potrawa',
    'GB': 'Empty dish',
    'DE': 'Leere schüssel',
    'ES': 'Plato vacio',
  };

  return Dish(
      id: randomUUID,
      name: emptyDishNames,
      customImage: false,
      imagePath: 'assets/images/photo2.jpg',
      price: 00.00,
      currency: 'PLN',
      ingredients: []);
}

getEmptyIngredient() {
  Map<String, String> emptyIngredientNames = {
    'PL': 'Pusty składnik',
    'GB': 'Empty ingredient',
    'DE': 'Leere komponente',
    'ES': 'Componente vacío',
  };
  return Ingredient(
      name: emptyIngredientNames, imagePath: 'assets/images/photo3.jpg');
}
