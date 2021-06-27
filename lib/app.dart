import 'package:flutter/material.dart';
import 'package:weight_planet_calculator/ui/common/custom_theme.dart';
import 'package:weight_planet_calculator/ui/home_view.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weight Planet Calculator',
      theme: CustomTheme.mainTheme(context),
      home: const HomeView(),
    );
  }
}
