import 'package:allen/colors.dart';
import 'package:allen/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: Pallete.whiteColor,
        appBarTheme: const AppBarTheme(
          color: Pallete.whiteColor,
        ),
        // textTheme: const TextTheme()
      ),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Pallete.blackColor,
        appBarTheme: const AppBarTheme(
          color: Pallete.blackColor,
        ),
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
