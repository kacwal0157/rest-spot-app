import 'package:aws_cognito_app/Presentation/Models/hex_color.dart';
import 'package:flutter/material.dart';

class IngredientContent extends StatefulWidget {
  final String name;
  final Color color;
  final String fontFamily;
  final String fontColor;
  final double width;
  //final imagePath;

  const IngredientContent(
      {super.key,
      required this.name,
      required this.color,
      required this.fontFamily,
      required this.fontColor,
      required this.width});
      //required this.imagePath});

  @override
  State<IngredientContent> createState() => _IngredientContent();
}

class _IngredientContent extends State<IngredientContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: widget.color,
        width: widget.width,
        child: Row(children: [
          Text(widget.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: HexColor(widget.fontColor),
                  fontFamily: widget.fontFamily,
                  fontSize: 15.0)),
          // SizedBox(
          //     width: widget.width / 2,
          //     height: 30.0,
          //     child: Image.asset(
          //       widget.imagePath,
          //       fit: BoxFit.cover,
          //       height: 250,
          //       width: double.infinity,
          //     )),
        ]));
  }
}
