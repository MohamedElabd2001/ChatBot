
import 'package:flutter/material.dart';
import 'package:gemini_api/pages/home_page.dart';
import 'package:device_preview/device_preview.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.grey.shade900,
        primaryColor: Colors.grey.shade900,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

