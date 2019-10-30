import 'package:flutter/material.dart';

class CustomShapeClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
      final Path path = Path();
      path.lineTo(0.0, size.height);

      var firstControlPoint = Offset(size.width*0.25, size.height - 50);
      var firstEndPoint = Offset(size.width*0.5, size.height - 30);

      path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);

      var secondControlPoint = Offset(size.width*0.75, size.height - 10);
      var secondEndPoint = Offset(size.width, size.height - 80);

      path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);


      path.lineTo(size.width, size.height);
      path.lineTo(size.width, 0.0);
      path.close();
      return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
  
}