import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weight_planet_calculator/ui/home.ui.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations(
      <DeviceOrientation>[DeviceOrientation.portraitUp]);

  runApp(MyApp());
}

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
        textTheme: GoogleFonts.barlowTextTheme(Theme.of(context).textTheme),
        primaryColor: Colors.blueGrey,
        backgroundColor: Colors.white,
      ),
      home: Home(),
    );
  }
}
