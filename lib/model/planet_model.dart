import 'package:flutter/material.dart';
import 'package:weight_planet_calculator/styles/generated/assets.gen.dart';

class Planet {
  Planet(this.name, this.asset, this.weightGravity, this.color);

  String name;
  String asset;
  double weightGravity;
  Color color;
}

final List<Planet> planets = <Planet>[
  Planet('Mercury', Assets.images.mercury, .38, Colors.red),
  Planet('Venus', Assets.images.venus, .91, Colors.yellow),
  Planet('Earth', Assets.images.earth, 1, Colors.green),
  Planet('Mars', Assets.images.mars, .38, Colors.blueGrey),
  Planet('Jupiter', Assets.images.jupiter, 2.34, Colors.black),
  Planet('Saturn', Assets.images.saturn, .93, Colors.orange),
  Planet('Uranus', Assets.images.uranus, .92, Colors.brown),
  Planet('Neptune', Assets.images.neptune, 1.12, Colors.indigo),
  Planet('Pluto', Assets.images.pluto, .06, Colors.amber),
];
