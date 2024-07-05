import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:notes/authentication/splash.dart';
import 'package:notes/theme/my_theme.dart' as my_theme;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: my_theme.backGroundColor,
          foregroundColor: my_theme.foreGroundColor,
          centerTitle: true,
        ),
        scaffoldBackgroundColor: my_theme.backGroundColor,
        iconTheme: const IconThemeData(color: my_theme.foreGroundColor),
        textTheme: GoogleFonts.oswaldTextTheme(),
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
