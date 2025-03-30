
import 'package:flutter/material.dart';

class HeaderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..style = PaintingStyle.fill;

    /// 🔹 **Blue Shape**
    Path bluePath = Path();
    // Color(0XFFF2E8EB) dark
    // Color(0XFF964F66)  text
    //Color(0XFFFCF7FA)    light background
    paint.color = Color(0XFFF2E8EB);
    // bluePath.moveTo(0, 0);
    bluePath.lineTo(0, size.height*0.85);
    bluePath.quadraticBezierTo(size.width * 0.5, size.height*0.9, size.width*0.7, size.height * 0.5);
    bluePath.quadraticBezierTo(size.width*0.8, size.height * 0.3, size.width, size.height*0.8);
    bluePath.lineTo(size.width,0);
    bluePath.close();
    canvas.drawPath(bluePath, paint);

    // /// 🔹 **Yellow Shape**
    // Path yellowPath = Path();
    // paint.color = Colors.amber.shade700;
    // yellowPath.lineTo(0, size.height*0.5);
    // yellowPath.quadraticBezierTo(size.width * 0.5, size.height*0.9, size.width*0.7, size.height * 0.5);
    // yellowPath.quadraticBezierTo(size.width * 0.6, size.height*0.7, size.width, size.height*0.5);
    // yellowPath.lineTo(size.width, 0);
    // yellowPath.close();
    // canvas.drawPath(yellowPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class HeaderPainterYellow extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..style = PaintingStyle.fill;

    /// 🔹 **Blue Shape**
    Path bluePath = Path();
    paint.color = Colors.blue;
    // bluePath.moveTo(0, 0);
    bluePath.lineTo(0, size.height*0.70);
    bluePath.quadraticBezierTo(size.width * 0.4, size.height*0.8, size.width*0.7, size.height * 0.5);
    bluePath.quadraticBezierTo(size.width*0.8, size.height * 0.3, size.width, size.height*0.7);
    bluePath.lineTo(size.width,0);
    bluePath.close();
    canvas.drawPath(bluePath, paint);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}