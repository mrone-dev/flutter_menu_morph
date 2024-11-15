import 'package:flutter/material.dart';

import '../models/models.dart';

class DebugPainter extends CustomPainter {
  final List<MenuItemBox2D> menuItems;

  DebugPainter(this.menuItems);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke;

    for (var item in menuItems) {
      var position = item.currentPosition;
      // Radius of the circle
      var radius = item.body.fixtures.first.shape.radius;
      canvas.drawCircle(
        position,
        radius,
        paint,
      );

      var textPainter = TextPainter(textDirection: TextDirection.ltr)
        ..text = TextSpan(
          text: 'mass: ${item.body.mass}\n'
              'linearVelocity: ${(item.body.position - item.originPosition).length}',
          style: const TextStyle(color: Colors.black, fontSize: 14.0),
        );

      textPainter.layout();
      textPainter.paint(
        canvas,
        position - Offset(radius, radius + 50),
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
