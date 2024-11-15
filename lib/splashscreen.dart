import 'dart:async';

import 'package:attendance/login.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Splashscreen extends StatefulWidget {
  
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    
    Timer( Duration(seconds: 3),() async {
      await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login(),));
    } );
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
       backgroundColor: const Color.fromARGB(255, 237, 241, 244),
      body: 
       Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Lottie.asset('assets/lottie/Animation - 1731062586747.json'),
          ),
        ],
      ),
    );
  }
}