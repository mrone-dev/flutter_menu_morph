import 'package:flutter/material.dart';

class MenuBoardPainter extends CustomPainter {
  final Animation<double> animation;
  MenuBoardPainter({
    required this.animation,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void _rotate(Canvas canvas, double cx, double cy, double angle) {
    canvas.translate(cx, cy);
    canvas.rotate(-angle);
    canvas.translate(-cx, -cy);
  }
}
