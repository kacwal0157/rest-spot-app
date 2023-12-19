import 'dart:io';

import 'package:aws_cognito_app/Presentation/Screens/Login/Widgets/custom_image_widget.dart';
import 'package:aws_cognito_app/Presentation/Utils/return_timer.dart';
import 'package:flutter/material.dart';

import '../../../../Models/config_model.dart';

class DishDetails extends StatefulWidget {
  const DishDetails(
      {super.key,
      required this.color,
      required this.imagePath,
      required this.customImage,
      required this.dish});

  final Color color;
  final String imagePath;
  final bool customImage;
  final Dish dish;

  @override
  State<DishDetails> createState() => _DishDetails();
}

class _DishDetails extends State<DishDetails> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dialogBackgroundColor: widget.color),
      child: AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: Stack(
          children: <Widget>[
            SizedBox(
              width: 1000,
              height: 600,
              child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: CustomImageWidget(dish: widget.dish)

                  // widget.customImage
                  //     ? Image.file(File(widget.imagePath),
                  //         fit: BoxFit.cover, height: 250, width: double.infinity)
                  //     : Image.asset(
                  //         widget.imagePath,
                  //         fit: BoxFit.cover,
                  //         height: 250,
                  //         width: double.infinity,
                  //       ),
                  ),
            ),
            Positioned(
              right: 12,
              top: 0,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.white.withOpacity(0.8),
                  size: 40,
                ),
                onPressed: () {
                  Navigator.pop(context, 'Cancel');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
