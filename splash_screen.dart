import 'package:flutter/material.dart';
import 'dart:async';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 8), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen())); //call login class
    });
  }

 @override
Widget build(BuildContext context) {
  return const Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "\t\t\t Workers Task\n "
            " Management System", 
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.lightGreen,
            ),
          ),
          SizedBox(height: 20),
          CircularProgressIndicator(
            backgroundColor: Colors.lightGreen,
            valueColor: AlwaysStoppedAnimation(Colors.green),
          ),
        ],
      ),
    ),
  );
}

}
