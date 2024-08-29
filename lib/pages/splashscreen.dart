import 'dart:async';

import 'package:chatapp/colors.dart';
import 'package:chatapp/pages/loginpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'boardingscreen.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => OnboardingScreens()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: color.thirdcolor,
        child: Center(
            child: Text(
          "Chat App",
          style: TextStyle(color: Colors.white, fontSize: 40),
        )),
      ),
    );
  }
}
