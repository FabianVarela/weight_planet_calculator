import 'package:flutter/material.dart';

class Planet {
  Planet(this.name, this.asset, this.weightGravity, this.color);

  String name;
  String asset;
  double weightGravity;
  Color color;
}

final List<Planet> planets = <Planet>[
  Planet('Mercury', 'assets/images/mercury.png', 0.38, Colors.red),
  Planet('Venus', 'assets/images/venus.png', 0.91, Colors.yellow),
  Planet('Earth', 'assets/images/earth.png', 1, Colors.green),
  Planet('Mars', 'assets/images/mars.png', 0.38, Colors.blueGrey),
  Planet('Jupiter', 'assets/images/jupiter.png', 2.34, Colors.black),
  Planet('Saturn', 'assets/images/saturn.png', 0.93, Colors.orange),
  Planet('Uranus', 'assets/images/uranus.png', 0.92, Colors.brown),
  Planet('Neptune', 'assets/images/neptune.png', 1.12, Colors.indigo),
  Planet('Pluto', 'assets/images/pluto.png', 0.06, Colors.amber),
];
