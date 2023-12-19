import 'package:flutter/material.dart';

class ShoppingService {
  List<Widget>? shopingWidgets;

  ShoppingService() {
    shopingWidgets = getShoppingWidget();
  }

  List<Widget> getShoppingWidget() {
    List<Widget> widgets = [];
    widgets.add(const Padding(
        padding: EdgeInsets.only(right: 10), child: Icon(Icons.shopping_cart)));

    return widgets;
  }
}
