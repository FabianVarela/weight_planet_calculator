import 'package:flutter/material.dart';

class RotationItem extends StatelessWidget {
  const RotationItem({required this.asset, super.key});

  final String asset;

  static const double _diameter = 5; // original 2
  static const int _constDiameter = 25;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 120,
      child: Center(
        child: SizedBox.square(
          dimension: _diameter * _constDiameter,
          child: DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(asset),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
