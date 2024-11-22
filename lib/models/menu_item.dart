import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_menu_morph/extensions/extensions.dart';
import 'package:flutter_menu_morph/widgets/widgets.dart';
import 'package:forge2d/forge2d.dart';

typedef MenuItemWidgetBuilder<T> = Widget Function(
  BuildContext context,
  T data,
);

typedef MenuItemCallback<T> = void Function(T data);

class MenuBoardData<T> {
  final MenuItem<T> parent;
  final List<MenuItem<T>> children;

  const MenuBoardData({
    required this.parent,
    required this.children,
  });

  void updateParent(MenuItem<T> parent) => _copyWith(parent: parent);

  void updateChildren(List<MenuItem<T>> children) =>
      _copyWith(children: children);

  MenuBoardData<T> _copyWith({
    MenuItem<T>? parent,
    List<MenuItem<T>>? children,
  }) =>
      MenuBoardData<T>(
        parent: parent ?? this.parent,
        children: children ?? this.children,
      );
}

// TODO add shape
class MenuItem<T> extends Equatable {
  final T data;
  final MenuItemWidgetBuilder<T> itemBuilder;
  final MenuItemCallback<T>? onPressed;

  const MenuItem({
    required this.data,
    required this.itemBuilder,
    this.onPressed,
  });

  @override
  List<Object?> get props => [data, itemBuilder, onPressed];

  @override
  String toString() => 'MenuItem($data)';
}

class MenuItemBox2D {
  final Body body;
  final Vector2 originPosition;
  final double speed;
  final double collisionSpeed;
  final double radius;

  MenuItemBox2D({
    required this.body,
    required this.originPosition,
    required this.radius,
    this.speed = 500.0,
    this.collisionSpeed = 200.0,
  }) {
    globalKey = GlobalKey<DraggableMenuItemState>();
  }

  Offset get currentPosition => body.position.toOffset();

  // radius is 10 atm
  bool get isAtOriginPosition => (body.position - originPosition).length < 5;

  late GlobalKey<DraggableMenuItemState> globalKey;

  DraggableMenuItemState? get _widgetState => globalKey.currentState;

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
    _reposition();
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
      _reposition();
    });
  }

  void checkCurrentPositionAndStop() {
    if (isAtOriginPosition &&
        !_isCollided &&
        body.linearVelocity != Vector2.zero()) {
      _clearVelocityAndShake();
    }
  }

  void stopShakeAnimation() {
    _widgetState?.stopShakeAnimation();
  }

  /// move the body towards to origin position
  void _reposition() {
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
    _widgetState?.startShakeAnimation();
  }

  @override
  String toString() => 'MenuItemBox2D(originPosition: $originPosition)';
}
