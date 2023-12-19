import 'dart:io';
import 'dart:math';

import 'package:aws_cognito_app/Presentation/Declarations/Constants/constant_enums.dart';
import 'package:aws_cognito_app/Presentation/Models/hex_color.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/Widgets/custom_image_widget.dart';
import 'package:aws_cognito_app/app_manager.dart';
import 'package:aws_cognito_app/Presentation/Models/config_model.dart';
import 'package:aws_cognito_app/Presentation/Screens/Login/Widgets/image_widget.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatefulWidget {
  const CategoryCard(
      {super.key,
      required this.onTap,
      required this.category,
      required this.title,
      required this.fontFamily,
      required this.fontSize,
      required this.fontColor});

  final VoidCallback onTap;
  final Category category;
  final String title;
  final String fontFamily;
  final double fontSize;
  final String fontColor;

  @override
  State<CategoryCard> createState() => _CategoryCard();
}

class _CategoryCard extends State<CategoryCard> {
  _refreshState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 50,
        child: AppManager.editMode
            ? SizedBox(
                height: 250,
                child: Stack(
                  children: <Widget>[
                    Container(
                        alignment: Alignment.center,
                        child: ImageWidget(
                          pageCallback: _refreshState,
                          imagePage: ImagePage.category,
                          category: widget.category,
                          onTap: () {
                            widget.onTap();
                          },
                        )),
                    Container(
                        alignment: Alignment.center,
                        height: 250,
                        child: Text(
                          widget.title,
                          style: TextStyle(
                              color: HexColor(widget.fontColor),
                              fontFamily: widget.fontFamily,
                              fontSize: widget.fontSize - 10),
                        )),
                  ],
                ))
            : GestureDetector(
                onTap: () {
                  widget.onTap(); // new code
                },
                child: Stack(
                  children: <Widget>[
                    Container(
                        alignment: Alignment.center,
                        child: CustomImageWidget(
                          category: widget.category,
                        )),
                    Container(
                        alignment: Alignment.center,
                        height: 250,
                        child: Text(
                          widget.title,
                          style: TextStyle(
                              color: HexColor(widget.fontColor),
                              fontFamily: widget.fontFamily,
                              fontSize: 40.0),
                        )),
                  ],
                ),
              ));
  }
}
