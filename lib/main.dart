import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app.dart';

ThemeMode appTheme = ThemeMode.system; //dark / light

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowCheckedModeBanner: false,
      title: 'db Meter',
      home: NoiseApp(),
      darkTheme: ThemeData.dark().copyWith(
        textTheme: ThemeData.dark().textTheme.apply(
              fontFamily: GoogleFonts.comfortaa().fontFamily,
            ),
        primaryTextTheme: ThemeData.dark().textTheme.apply(
              fontFamily: GoogleFonts.comfortaa().fontFamily,
            ),
        accentTextTheme: ThemeData.dark().textTheme.apply(
              fontFamily: GoogleFonts.comfortaa().fontFamily,
            ),
      ),
      theme: ThemeData(
        fontFamily: GoogleFonts.comfortaa().fontFamily,
      ),
      themeMode: appTheme,
    );
  }
}
