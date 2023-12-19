import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainWeb extends StatefulWidget {
  const MainWeb({super.key});

  @override
  State<MainWeb> createState() => _MainWeb();
}

class _MainWeb extends State<MainWeb> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: const Color.fromARGB(
              255, 81, 92, 101), // Set your desired background color here
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 65, 66, 67), // Start color
                  Color.fromARGB(255, 119, 142, 120), // End color
                ],
              ),
            ),
            child: Stack(children: [
              Row(
                children: [
                  Expanded(
                    child: Image.asset(
                      "assets/images/web_home.png",
                      height: 500,
                    ),
                  )
                ],
              )
            ]),
          )),
    );
  }
}
