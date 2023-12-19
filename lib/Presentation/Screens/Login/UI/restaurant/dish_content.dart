import 'package:aws_cognito_app/Presentation/Models/hex_color.dart';
import 'package:flutter/material.dart';

class DishContent extends StatefulWidget {
  const DishContent(
      {super.key,
      required this.name,
      required this.fontFamily,
      required this.fontSize,
      required this.fontColor,
      required this.width,
      required this.color,
      required this.ingredients,
      required this.ingredientsString});

  final String name;
  final String fontFamily;
  final double fontSize;
  final String fontColor;
  final double width;
  final Color color;
  final List<Widget> ingredients;
  final String ingredientsString;

  @override
  State<DishContent> createState() => _Dish();
}

class _Dish extends State<DishContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: 200,
      alignment: Alignment.centerLeft,
      color: widget.color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                widget.name,
                style: TextStyle(
                    color: HexColor(widget.fontColor),
                    fontFamily: widget.fontFamily,
                    fontWeight: FontWeight.bold,
                    fontSize: widget.fontSize - 5),
                textAlign: TextAlign.left,
              )),
          Text(
            widget.ingredientsString,
            style: TextStyle(
                color: Colors.white,
                fontFamily: widget.fontFamily,
                fontWeight: FontWeight.w100,
                fontSize: widget.fontSize - 5),
          )
        ],
      ),
    );
  }
}
