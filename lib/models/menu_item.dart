import 'package:flutter/material.dart';
import 'package:flutter_menu_morph/extensions/extensions.dart';
import 'package:forge2d/forge2d.dart';

class MenuItem {
  final String name;
  final String imageName;

  /// [radius] of parent will be prioritized.
  /// If there is available space for children
  /// [radius] will be applied to child
  final double radius;

  MenuItem({
    required this.name,
    required this.imageName,
    required this.radius,
  });

  @override
  String toString() => 'MenuItem($name, [$radius])';
}

class MenuItemBox2D {
  final MenuItem value;
  final Body body;
  final Vector2 originPosition;
  final double speed;

  MenuItemBox2D({
    required this.value,
    required this.body,
    required this.originPosition,
    this.speed = 300.0,
  }) {
    _originMassData = body.getMassData().clone();
  }

  bool isMovingByUser = false;
  bool isCollided = false;

  Offset get currentPosition => body.position.toOffset();

  double get radius => value.radius;

  // radius is 10 atm
  bool get isAtOriginPosition => (body.position - originPosition).length < 5;

  late MassData _originMassData;

  /// move the body towards to origin position
  void reposition() {
    if (isMovingByUser || isCollided) {
      return;
    }
    if (isAtOriginPosition) {
      body.linearVelocity = Vector2.zero();
    } else {
      var direction = originPosition -
          Vector2(
            currentPosition.dx,
            currentPosition.dy,
          );
      direction.normalize();
      body.linearVelocity = direction * speed;
    }
  }

  void checkCurrentPositionAndStop() {
    if (isAtOriginPosition && !isCollided) {
      body.linearVelocity = Vector2.zero();
    }
  }

  void setMovingByUser(bool value) {
    isMovingByUser = value;
  }

  /// call [Body] setTransform, keep origin angle
  void setTransform(Offset offset) {
    body.setTransform(
      Vector2(
        currentPosition.dx + offset.dx,
        currentPosition.dy + offset.dy,
      ),
      body.angle,
    );
  }

  void _resetMassData() {
    body.setMassData(_originMassData);
  }

  @override
  String toString() => 'MenuItemBox2D($value)';
}
