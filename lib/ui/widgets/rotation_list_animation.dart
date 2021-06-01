import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:weight_planet_calculator/hooks/tween_animation_hook.dart';
import 'package:weight_planet_calculator/ui/widgets/rotation_item.dart';

class RotationListAnimation extends HookWidget {
  RotationListAnimation({
    required this.size,
    required this.assetList,
    this.currentIndex = 0,
    this.isReverse = true,
  });

  final Size size;
  final List<String> assetList;
  final int currentIndex;
  final bool isReverse;

  double get _myHeight => size.height * 0.8; // 0.4

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: Duration(milliseconds: 500),
    );
    final tween = useTweenAnimation(
      animationController,
      begin: 0.0,
      end: currentIndex.toDouble(),
    );

    final stackChildren = <Widget>[_Circle(height: _myHeight)];

    for (var i = 0; i < assetList.length; i++) {
      final radialOffset = _myHeight / 2;
      final radianDiff = (2 * pi) / assetList.length;
      final rotationFactor = tween.animate(animationController).value;
      final startRadian = -pi / 2 + -rotationFactor * radianDiff;
      final radians = startRadian + i * radianDiff;

      final reverseValue = isReverse ? -1 : 1; // original 1
      final dx = radialOffset * (reverseValue * cos(radians));
      final dy = radialOffset * (reverseValue * sin(radians));

      stackChildren.add(
        Transform.translate(
          offset: Offset(dx, dy),
          child: RotationItem(asset: assetList[i]),
        ),
      );
    }

    return FractionalTranslation(
      translation: Offset(0.0, isReverse ? -0.9 : 0.9), // 0.2
      child: Align(
        alignment: isReverse ? Alignment.topCenter : Alignment.bottomCenter,
        child: Container(
          height: _myHeight,
          child: Stack(alignment: Alignment.center, children: stackChildren),
        ),
      ),
    );
  }
}

class _Circle extends StatelessWidget {
  const _Circle({Key? key, required this.height}) : super(key: key);

  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: height,
      height: height,
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(shape: BoxShape.circle),
    );
  }
}
