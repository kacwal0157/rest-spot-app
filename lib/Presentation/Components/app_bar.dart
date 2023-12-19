import 'package:aws_cognito_app/app_manager.dart';
import 'package:flutter/material.dart';

AppBar buildAppBar(
        {String? appBarTitle,
        String? fontFamily,
        String? pushPath,
        double? fontSize,
        double? iconSize,
        Color? color,
        Color? iconColor,
        Color? fontColor,
        List<Widget>? actionWidgets,
        required bool canReturn,
        required bool inApp,
        required BuildContext context}) =>
    AppBar(
      title: Text(
        appBarTitle ?? '',
        style: TextStyle(
          color: fontColor ?? Colors.white,
          fontFamily: fontFamily ?? 'Montserrat',
          fontSize: fontSize ?? 25.0,
        ),
      ),
      centerTitle: false,
      automaticallyImplyLeading: false,
      leading: canReturn
          ? IconButton(
              alignment: Alignment.center,
              icon: Icon(
                Icons.chevron_left,
                color: iconColor ?? Colors.white,
                size: iconSize ?? 25,
              ),
              onPressed: () {
                if (inApp) {
                  Navigator.pop(context, true);
                  AppManager.currentRoute = '/main';
                } else {
                  Navigator.of(context).pushReplacementNamed(pushPath!);
                }
              },
            )
          : null,
      toolbarHeight: 45,
      backgroundColor: color ?? Colors.transparent,
      elevation: 0,
      actions: actionWidgets ?? [],
    );
