import 'package:flutter/cupertino.dart';

class HeaderClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final width = size.width;
    final height = size.height;

    final path = Path()
      ..lineTo(0, height - 50)
      ..quadraticBezierTo(width / 2, height, width, height - 50)
      ..lineTo(width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
