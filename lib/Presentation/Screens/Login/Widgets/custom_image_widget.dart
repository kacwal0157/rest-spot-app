import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../../../../app_manager.dart';
import '../../../Models/config_model.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class CustomImageWidget extends StatefulWidget {
  const CustomImageWidget(
      {super.key, this.category, this.dish, this.configModel});

  final Category? category;
  final Dish? dish;
  final ConfigModel? configModel;

  @override
  State<CustomImageWidget> createState() => _CustomImageWidgetState();
}

class _CustomImageWidgetState extends State<CustomImageWidget> {
  @override
  Widget build(BuildContext context) {
    String suffix = 'main_image';
    String id = '';
    bool customImage =
        widget.configModel != null ? widget.configModel!.customImage : true;
    String imagePath =
        widget.configModel != null ? widget.configModel!.imagePath : '';

    if (widget.category != null) {
      suffix = 'category_';
      id = widget.category!.id;
      customImage = widget.category!.customImage;
      imagePath = widget.category!.imagePath;
    } else if (widget.dish != null) {
      suffix = 'dish_';
      id = widget.dish!.id;
      customImage = widget.dish!.customImage;
      imagePath = widget.dish!.imagePath;
    }

    if (kIsWeb) {
      return customImage
          ? Image.memory(
              base64Decode(AppManager.storage.getImageBase64("$suffix$id")),
              fit: BoxFit.cover,
              height: 250,
              width: double.infinity)
          : Image.asset(
              imagePath,
              fit: BoxFit.cover,
              height: 250,
              width: double.infinity,
            );
    } else {
      return customImage
          ? Image.file(
              File("${AppManager.devicePath}/images/$suffix$id"),
              fit: BoxFit.cover,
              height: 250,
              width: double.infinity,
            )
          : Image.asset(
              imagePath,
              fit: BoxFit.cover,
              height: 250,
              width: double.infinity,
            );
    }
  }
}
