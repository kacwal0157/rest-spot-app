// platform_interface.dart

import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

import '../../../Declarations/Constants/constant_enums.dart';
import '../../../Models/config_model.dart';

abstract class ImageFunctionInterface {
  uploadImage(BuildContext context, Function pageCallback, ImagePage imagePage,
      Category? category, Dish? dish, ImageCache imageCache);
}
