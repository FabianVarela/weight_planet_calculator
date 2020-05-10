import 'package:flutter/material.dart';
import 'package:weight_planet_calculator/ui/home.ui.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weight Planet Calculator',
      theme: ThemeData(
        fontFamily: 'Barlow',
        primaryColor: Colors.blueGrey,
        backgroundColor: Colors.white,
      ),
      home: Home(),
    );
  }
}
