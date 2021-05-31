import 'dart:math';

import 'package:flutter/material.dart';
import 'package:weight_planet_calculator/ui/widgets/rotation_item.dart';

class RotationListAnimation extends StatefulWidget {
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

  @override
  _RotationListAnimationState createState() => _RotationListAnimationState();
}

class _RotationListAnimationState extends State<RotationListAnimation>
    with SingleTickerProviderStateMixin {
  double get _myHeight => widget.size.height * 0.8; // 0.4

  late AnimationController _controller;
  late Tween<double> _rotationTween;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    )..addListener(() => setState(() {}));

    _rotationTween = Tween<double>(
      begin: 0.0,
      end: widget.currentIndex.toDouble(),
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(RotationListAnimation oldWidget) {
    if (widget.currentIndex != oldWidget.currentIndex) {
      _rotationTween = Tween<double>(
        begin: _rotationTween.evaluate(_controller),
        end: widget.currentIndex.toDouble(),
      );
      _controller.forward(from: 0.0);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stackChildren = <Widget>[_Circle(height: _myHeight)];

    for (var i = 0; i < widget.assetList.length; i++) {
      final radialOffset = _myHeight / 2;
      final radianDiff = (2 * pi) / widget.assetList.length;
      final rotationFactor = _rotationTween.animate(_controller).value;
      final startRadian = -pi / 2 + -rotationFactor * radianDiff;
      final radians = startRadian + i * radianDiff;

      final reverseValue = widget.isReverse ? -1 : 1; // original 1
      final dx = radialOffset * (reverseValue * cos(radians));
      final dy = radialOffset * (reverseValue * sin(radians));

      stackChildren.add(
        Transform.translate(
          offset: Offset(dx, dy),
          child: RotationItem(asset: widget.assetList[i]),
        ),
      );
    }

    return FractionalTranslation(
      translation: Offset(0.0, widget.isReverse ? -0.9 : 0.9), // 0.2
      child: Align(
        alignment:
            widget.isReverse ? Alignment.topCenter : Alignment.bottomCenter,
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
