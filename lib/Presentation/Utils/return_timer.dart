import 'dart:async';
import 'package:aws_cognito_app/Presentation/Routes/routes.dart';

import 'package:flutter/material.dart';

class ReturnTimer {
  Timer? _timer;
  final int secondsToReturn;
  BuildContext? context;

  ReturnTimer(this.secondsToReturn);

  void startTimer(BuildContext? context) {
    if (context != null) {
      this.context = context;
      Duration duration = Duration(seconds: secondsToReturn);
      _timer = Timer(duration, () {
        if (Routes.currentPage == Routes.categoryPage) {
          Routes.currentPage = Routes.restaurantPage;
          Navigator.of(context).pushNamed(Routes.restaurantPage);
        }
      });
    }
  }

  void resetTimer() {
    if (_timer != null) {
      _timer!.cancel();
      startTimer(context);
    }
  }

  void cancelTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }
}
