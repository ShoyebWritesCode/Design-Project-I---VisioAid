import 'package:flutter/material.dart';
import 'package:object_detection/HomeScreen.dart';
import 'package:object_detection/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Optexa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue
        ,
      ),
      home: Splash(),
    );
  }
}
