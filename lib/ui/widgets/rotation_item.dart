import 'package:flutter/material.dart';

class RotationItem extends StatelessWidget {
  const RotationItem({required this.asset, super.key});

  final String asset;

  static const double _diameter = 5; // original 2
  static const int _constDiameter = 25;

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: const Size(120, 120),
      child: Center(
        child: Container(
          width: _diameter * _constDiameter,
          height: _diameter * _constDiameter,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(asset),
              fit: BoxFit.contain,
            ),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
