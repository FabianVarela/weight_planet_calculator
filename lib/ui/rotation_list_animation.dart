import 'dart:math';

import 'package:flutter/material.dart';

class RotationListAnimation extends StatefulWidget {
  RotationListAnimation({
    @required this.size,
    this.assetList,
    this.currentIndex,
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
  double get _widgetHeight => widget.size.height * 0.8; // original 0.4

  AnimationController _controller;
  Tween<double> _rotationTween;

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
    final List<Widget> stackChildren = <Widget>[_setCircle()];

    for (int i = 0; i < widget.assetList.length; i++) {
      final double radialOffset = _widgetHeight / 2;
      final double radianDiff = (2 * pi) / widget.assetList.length;
      final double rotationFactor = _rotationTween.animate(_controller).value;
      final double startRadian = -pi / 2 + -rotationFactor * radianDiff;
      final double radians = startRadian + i * radianDiff;

      final double reverseValue = widget.isReverse ? -1 : 1; // original 1
      final double dx = radialOffset * (reverseValue * cos(radians));
      final double dy = radialOffset * (reverseValue * sin(radians));

      stackChildren.add(
        Transform.translate(
          offset: Offset(dx, dy),
          child: RotationItem(
            asset: widget.assetList[i],
          ),
        ),
      );
    }

    return Container(
      child: FractionalTranslation(
        translation: Offset(
          0.0,
          widget.isReverse ? -0.9 : 0.9, // original 0.2
        ),
        child: Align(
          alignment:
              widget.isReverse ? Alignment.topCenter : Alignment.bottomCenter,
          child: Container(
            height: _widgetHeight,
            child: Stack(
              alignment: Alignment.center,
              children: stackChildren,
            ),
          ),
        ),
      ),
    );
  }

  Widget _setCircle() {
    return Container(
      width: _widgetHeight,
      height: _widgetHeight,
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // border: Border.all(color: Colors.grey.shade300, width: 1.5),
      ),
      child: Container(),
    );
  }
}

class RotationItem extends StatelessWidget {
  RotationItem({@required this.asset});

  final String asset;

  final double _diameter = 5; // original 2
  final double _constDiameter = 25;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Center(
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
        ],
      ),
    );
  }
}
