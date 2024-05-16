import 'package:assistant/screens/home_page.dart';
import 'package:assistant/screens/pallette.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EchoIntellect',
      theme: ThemeData.light(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: pallette.whiteColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: pallette.whiteColor,
        ),
      ),
      home: const Homepage(),
    );
  }
}
