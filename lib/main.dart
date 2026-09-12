import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:weight_planet_calculator/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations(
    <DeviceOrientation>[DeviceOrientation.portraitUp],
  );

  runApp(const App());
}
