import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:aws_cognito_app/Presentation/Declarations/Constants/constant_enums.dart';
import 'package:aws_cognito_app/app_manager.dart';
import 'package:aws_cognito_app/Presentation/Models/config_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import "package:universal_html/html.dart" as universal_html;

import 'image_functions_interface.dart';

class WebImageWidgetFunctions extends ImageFunctionInterface {
  final ImagePicker imagePicker = ImagePicker();
  WebImageWidgetFunctions();

  @override
  uploadImage(BuildContext context, Function pageCallback, ImagePage imagePage,
      Category? category, Dish? dish, ImageCache imageCache) async {
    try {
      final image = await pickFile();
      if (image == null) return;

      switch (imagePage) {
        case ImagePage.main:
          await AppManager.configService.editMainImageWeb(image);
          pageCallback();
          break;
        case ImagePage.category:
          await AppManager.configService
              .editContentImageWeb(category!.id, image);
          pageCallback();
          break;
        case ImagePage.dish:
          await AppManager.configService
              .editDishImageWeb(category!.id, dish!.id, image);
          pageCallback();
          break;
      }
    } catch (e) {
      printError(info: "Error with choosing file in browser");
    }
  }

  Future<Uint8List?> pickFile() async {
    final input = universal_html.FileUploadInputElement()..accept = '*/*';
    input.click();

    await input.onChange.first;
    if (input.files?.isEmpty ?? true) return null;
    return readFileAsBytes(input.files!.first);
  }

  XFile convertFileToXFile(File file) {
    return XFile(file.path);
  }

  Future<Uint8List> readFileAsBytes(universal_html.File file) async {
    final reader = universal_html.FileReader();
    final completer = Completer<Uint8List>();

    reader.readAsArrayBuffer(file);
    reader.onLoadEnd.listen((event) {
      completer.complete(reader.result as Uint8List);
    });
    reader.onError.listen((event) {
      completer.completeError(event);
    });

    return completer.future;
  }
}
