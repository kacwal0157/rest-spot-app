import 'dart:convert';
import 'dart:io';

import 'package:aws_cognito_app/Presentation/Declarations/Constants/constant_enums.dart';
import 'package:aws_cognito_app/app_manager.dart';
import 'package:aws_cognito_app/Presentation/Models/config_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ImageWidget extends StatefulWidget {
  const ImageWidget(
      {super.key,
      required this.pageCallback,
      required this.imagePage,
      this.category,
      this.dish,
      this.onTap});

  final Function pageCallback;
  final ImagePage imagePage;
  final Category? category;
  final Dish? dish;
  final VoidCallback? onTap;

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  Object image = AssetImage(AppManager.config.imagePath);

  @override
  Widget build(BuildContext context) {
    // imageCache.clear();
    // imageCache.clearLiveImages();

    switch (widget.imagePage) {
      case ImagePage.main:
        image = AppManager.config.customImage
            ? kIsWeb
                ? MemoryImage(base64Decode(
                    AppManager.storage.getImageBase64("main_image")))
                : FileImage(File('${AppManager.devicePath}/images/main_image'))
            : AssetImage(AppManager.config.imagePath);
        break;
      case ImagePage.category:
        image = widget.category!.customImage
            ? kIsWeb
                ? MemoryImage(base64Decode(AppManager.storage
                    .getImageBase64("category_${widget.category!.id}")))
                : FileImage(File(
                    '${AppManager.devicePath}/images/category_${widget.category!.id}'))
            : AssetImage(widget.category!.imagePath);
        break;
      case ImagePage.dish:
        image = widget.dish!.customImage
            ? kIsWeb
                ? MemoryImage(base64Decode(AppManager.storage
                    .getImageBase64("dish_${widget.dish!.id}")))
                : FileImage(File(
                    '${AppManager.devicePath}/images/dish_${widget.dish!.id}'))
            : AssetImage(widget.dish!.imagePath);
        break;
    }

    return Ink.image(
      image: image as ImageProvider,
      key: UniqueKey(),
      fit: BoxFit.cover,
      width: double.infinity,
      child: InkWell(
        onTap: widget.onTap,
      ),
    );
  }
}

class ImageWidgetFunctions {
  final ImagePicker imagePicker = ImagePicker();
  ImageWidgetFunctions();

  Future<ImageSource?> showImageSource(BuildContext context,
      ImagePage imagePage, Category? category, Dish? dish) async {
    if (Platform.isIOS) {
      return showCupertinoModalPopup<ImageSource>(
        context: context,
        builder: (context) => CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
                child: const Text('Camera'),
                onPressed: () {
                  Navigator.of(context).pop(ImageSource.camera);
                }),
            CupertinoActionSheetAction(
                child: const Text('Gallery'),
                onPressed: () {
                  Navigator.of(context).pop(ImageSource.gallery);
                }),
          ],
        ),
      );
    } else {
      return showModalBottomSheet(
        context: context,
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop(ImageSource.camera);
                }),
            ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.of(context).pop(ImageSource.gallery);
                }),
          ],
        ),
      );
    }
  }

  // Function to capture a photo with the camera
  String getFileName(ImagePage imagePage, Category? category, Dish? dish) {
    switch (imagePage) {
      case ImagePage.category:
        return "category_${category!.id}";
      case ImagePage.dish:
        return "dish_${dish!.id}";
      case ImagePage.main:
        return "main";
    }
  }

  pickImage(ImageSource source, Function pageCallback, ImagePage imagePage,
      Category? category, Dish? dish, ImageCache imageCache) async {
    try {
      final status = await Permission.storage.request();
      if (status.isGranted) {
        final image = await ImagePicker().pickImage(source: source);
        if (image == null) return;

        switch (imagePage) {
          case ImagePage.main:
            File file = await AppManager.configService
                .editMainImage(await image.readAsBytes());
            imageCache.evict(FileImage(file));
            pageCallback();
            break;
          case ImagePage.category:
            File file = await AppManager.configService
                .editContentImage(category!.id, await image.readAsBytes());
            imageCache.evict(FileImage(file));
            pageCallback();
            break;
          case ImagePage.dish:
            File file = await AppManager.configService.editDishImage(
                category!.id, dish!.id, await image.readAsBytes());
            imageCache.evict(FileImage(file));
            pageCallback();
            break;
        }
      } else {
        print("Permission to storage not grranted");
        return;
      }
    } on PlatformException {
      print("No access to camera");
      Error();
    }
  }
}
