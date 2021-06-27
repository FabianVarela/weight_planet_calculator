import 'package:flutter/material.dart';

class RotationItem extends StatelessWidget {
  const RotationItem({Key? key, required this.asset}) : super(key: key);

  final String asset;

  final double _diameter = 5; // original 2
  final double _constDiameter = 25;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
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
