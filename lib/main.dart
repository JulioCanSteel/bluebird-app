import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'constants/app_constants.dart';
import 'package:google_fonts/google_fonts.dart';



void main() {
  runApp(BluebirdApp());
}

class BluebirdApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: AppConstants.backgroundColor,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: WelcomeScreen(),
    );
  }
}