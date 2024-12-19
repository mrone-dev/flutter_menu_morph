import 'package:flutter/material.dart';
import 'package:forge2d/forge2d.dart';

import 'menu_controller.dart';

class Forge2DPainter extends CustomPainter {
  final MenuBox2DController controller;
  final Listenable listenable;
  Forge2DPainter(this.controller, this.listenable) : super(repaint: listenable);
  late final CanvasDebugDraw debugDraw;

  bool check = false;
  @override
  void paint(Canvas canvas, Size size) {
    // if (controller.picture != null) {
    //   canvas.drawPicture(controller.picture!);
    // }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class CanvasDebugDraw extends DebugDraw {
  Canvas canvas;

  CanvasDebugDraw(super.viewport, this.canvas);

  @override
  void drawPoint(Vector2 argPoint, double argRadiusOnScreen, Color3i argColor) {
    var paint = Paint()
      ..color = Color.fromARGB(255, argColor.r, argColor.g, argColor.b)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(argPoint.x, argPoint.y), argRadiusOnScreen, paint);
  }

  @override
  void drawPolygon(List<Vector2> vertices, Color3i color) {
    var paint = Paint()
      ..color = Color.fromARGB(255, color.r, color.g, color.b)
      ..style = PaintingStyle.stroke;

    var path = Path()..moveTo(vertices[0].x, vertices[0].y);
    for (var vertex in vertices) {
      path.lineTo(vertex.x, vertex.y);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  void drawSolidPolygon(List<Vector2> vertices, Color3i color) {
    var paint = Paint()
      ..color = Color.fromARGB(255, color.r, color.g, color.b)
      ..style = PaintingStyle.fill;

    var path = Path()..moveTo(vertices[0].x, vertices[0].y);
    for (var vertex in vertices) {
      path.lineTo(vertex.x, vertex.y);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  void drawCircle(Vector2 center, num radius, Color3i color) {
    var paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(Offset(center.x, center.y), radius.toDouble(), paint);
  }

  @override
  void drawSolidCircle(Vector2 center, num radius, Color3i color) {
    var paint = Paint()
      ..color = Color.fromARGB(255, color.r, color.g, color.b)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(center.x, center.y), radius.toDouble(), paint);
    // canvas.restore();
  }

  @override
  void drawSegment(Vector2 p1, Vector2 p2, Color3i color) {
    var paint = Paint()
      ..color = Color.fromARGB(255, color.r, color.g, color.b)
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(p1.x, p1.y), Offset(p2.x, p2.y), paint);
  }

  @override
  void drawTransform(dynamic xf, Color3i color) {
    // Implement drawing of transform if needed
  }

  @override
  void drawStringXY(num x, num y, String s, Color3i color) {
    var textPainter = TextPainter(
      text: TextSpan(
        text: s,
        style: TextStyle(
          color: Color.fromARGB(255, color.r, color.g, color.b),
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(x.toDouble(), y.toDouble()));
  }

  @override
  void drawParticles(List<Particle> particles, double radius) {
    // Implement particle drawing if needed
  }

  @override
  void drawParticlesWireframe(List<Particle> particles, double radius) {
    // Implement wireframe particle drawing if needed
  }
}
