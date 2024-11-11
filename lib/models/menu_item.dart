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
  final double collisionSpeed;

  MenuItemBox2D({
    required this.value,
    required this.body,
    required this.originPosition,
    this.speed = 300.0,
    this.collisionSpeed = 100.0,
  }) {
    _originMassData = body.getMassData().clone();
  }

  Offset get currentPosition => body.position.toOffset();

  double get radius => value.radius;

  // radius is 10 atm
  bool get isAtOriginPosition => (body.position - originPosition).length < 5;

  late MassData _originMassData;

  /// true -> user is moving the item a
  bool get isPrioritized => _isPrioritized;

  set prioritized(bool value) {
    _isPrioritized = value;
  }

  bool _isPrioritized = false;

  bool get isCollided => _isCollided;
  set collided(bool value) {
    _isCollided = value;
  }

  bool _isCollided = false;

  void onPanStart() {
    prioritized = true;
  }

  void onPanEnd() {
    reposition();
  }

  void onPanUpdate(Offset offset) {
    _setTransform(offset);
  }

  void collidedWithTheOther(
    Vector2 direction, [
    Duration duration = Durations.medium3,
  ]) {
    Vector2 impulse = direction * collisionSpeed;
    collided = true;
    body.applyLinearImpulse(impulse, point: body.worldCenter);

    Future<void>.delayed(duration).then((_) {
      collided = false;
      reposition();
    });
  }

  /// move the body towards to origin position
  void reposition() {
    if (isCollided) {
      return;
    }
    if (isAtOriginPosition) {
      _clearVelocityAndShake();
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
    if (isAtOriginPosition &&
        !_isCollided &&
        body.linearVelocity != Vector2.zero()) {
      _clearVelocityAndShake();
    }
  }

  /// call [Body] setTransform, keep origin angle
  void _setTransform(Offset offset) {
    body.setTransform(
      Vector2(
        currentPosition.dx + offset.dx,
        currentPosition.dy + offset.dy,
      ),
      body.angle,
    );
  }

  void _clearVelocityAndShake() {
    prioritized = false;
    body.linearVelocity = Vector2.zero();
  }

  @override
  String toString() => 'MenuItemBox2D($value)';
}
