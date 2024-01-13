import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weight_planet_calculator/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations(
    <DeviceOrientation>[DeviceOrientation.portraitUp],
  );

  runApp(const App());
}
