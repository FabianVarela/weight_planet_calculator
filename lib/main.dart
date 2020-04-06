import 'package:flutter/material.dart';
import 'package:weight_planet_calculator/ui/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weight Planet Calculator',
      theme: ThemeData(
        primaryColor: Colors.blueGrey,
        backgroundColor: Colors.white,
      ),
      home: Home(),
    );
  }
}
