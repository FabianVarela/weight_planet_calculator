import 'package:flutter/material.dart';
import 'package:weight_planet_calculator/styles/generated/assets.gen.dart';

class Planet {
  const Planet({
    required this.name,
    required this.imagePath,
    required this.shaderPath,
    required this.weightGravity,
    required this.gravityMs2,
    required this.yearDays,
    required this.color,
    this.isHome = false,
  });

  final String name;
  final String imagePath;
  final String shaderPath;
  final double weightGravity;
  final double gravityMs2;
  final int yearDays;
  final Color color;
  final bool isHome;
}

final List<Planet> planets = [
  Planet(
    name: 'Mercury',
    imagePath: Assets.planets.mercury,
    shaderPath: 'shaders/mercury.frag',
    weightGravity: 0.38,
    gravityMs2: 3.7,
    yearDays: 88,
    color: const Color(0xFF8B7355),
  ),
  Planet(
    name: 'Venus',
    imagePath: Assets.planets.venus,
    shaderPath: 'shaders/venus.frag',
    weightGravity: 0.91,
    gravityMs2: 8.87,
    yearDays: 225,
    color: const Color(0xFFE8C47A),
  ),
  Planet(
    name: 'Earth',
    imagePath: Assets.planets.earth,
    shaderPath: 'shaders/earth.frag',
    weightGravity: 1,
    gravityMs2: 9.81,
    yearDays: 365,
    color: const Color(0xFF4A90D9),
    isHome: true,
  ),
  Planet(
    name: 'Mars',
    imagePath: Assets.planets.mars,
    shaderPath: 'shaders/mars.frag',
    weightGravity: 0.38,
    gravityMs2: 3.71,
    yearDays: 687,
    color: const Color(0xFFB84C2C),
  ),
  Planet(
    name: 'Jupiter',
    imagePath: Assets.planets.jupiter,
    shaderPath: 'shaders/jupiter.frag',
    weightGravity: 2.34,
    gravityMs2: 24.79,
    yearDays: 4333,
    color: const Color(0xFFB07A50),
  ),
  Planet(
    name: 'Saturn',
    imagePath: Assets.planets.saturn,
    shaderPath: 'shaders/saturn.frag',
    weightGravity: 0.93,
    gravityMs2: 10.44,
    yearDays: 10759,
    color: const Color(0xFFD4B483),
  ),
  Planet(
    name: 'Uranus',
    imagePath: Assets.planets.uranus,
    shaderPath: 'shaders/uranus.frag',
    weightGravity: 0.92,
    gravityMs2: 8.69,
    yearDays: 30687,
    color: const Color(0xFF7BC8C8),
  ),
  Planet(
    name: 'Neptune',
    imagePath: Assets.planets.neptune,
    shaderPath: 'shaders/neptune.frag',
    weightGravity: 1.12,
    gravityMs2: 11.15,
    yearDays: 60190,
    color: const Color(0xFF3D5A8A),
  ),
];
