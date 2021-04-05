import 'package:flutter/material.dart';

class DownHillClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height / 40);
    var firstControlPoint = new Offset(size.width / 1.2, -size.height / 20);
    var firstEndPoint = new Offset(size.width / 1.9, size.height / 8);
    var secondControlPoint = new Offset(size.width / 4, size.height / 4);
    var secondEndPoint = new Offset(0.0, size.height / 10);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}

class UphillClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height / 5);
    path.cubicTo(
      size.width / 1.9,
      size.height / 2.3,
      size.width / 2,
      0.0,
      0.0,
      size.height / 4.5,
    );
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
