import 'package:flutter/material.dart';
import 'package:wtms/view/login.dart';
import 'package:wtms/view/register.dart';
import 'package:wtms/view/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workers Task Management System',
      theme: ThemeData(),
      home: const SplashScreen(),
      initialRoute: '/login',
        routes: {'/login':(context) => const LoginScreen(),
          '/register': (context) => const RegisterPage(),
        },
    );
  }
}
