import 'dart:math';
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_menu_morph/models/models.dart';
import 'package:forge2d/forge2d.dart';
import 'package:forge2d/src/settings.dart' as settings;

import 'menu_contact_listener.dart';

enum MenuStateStatus {
  pending,
  completed,
}

class MenuBox2DState extends Equatable {
  final MenuItemBox2D parent;
  final Map<int, MenuItemBox2D> children;

  const MenuBox2DState({
    required this.parent,
    required this.children,
  });

  @override
  List<Object?> get props => [parent, children];
}

class MenuBox2DController with ChangeNotifier {
  final MenuBoardConfiguration configuration;
  MenuBox2DController({required this.configuration});
  MenuStateStatus status = MenuStateStatus.pending;
  late final World world;
  late final MenuBox2DState state;

  Size get boardSizePixels => configuration.boardSizePixels;

  MenuItemBox2D get parent => state.parent;

  Iterable<MenuItemBox2D> get children => state.children.values;
  Iterable<MenuItemBox2D> get allMenuItemsBox2D => [
        parent,
        ...children,
      ];

  Iterable<Body> get allBodies => [
        parent.body,
        ...children.map((e) => e.body),
      ];

  bool get isDebug => configuration.isDebug;

  Picture? picture;

  late PictureRecorder recorder;

  void initialize() {
    settings.maxTranslation = 3.0;
    world = World(Vector2.zero());

    var centerPosition =
        Vector2(boardSizePixels.width / 2, boardSizePixels.height / 2);
    status = MenuStateStatus.completed;

    var positions = _drawHexagonCircles(
      centerPosition,
      configuration.parent.radius,
      configuration.children.first.radius,
      boardSizePixels.width,
      boardSizePixels.height,
      16.0,
    );
    var parent = _createMenuItemBox2D(configuration.parent, centerPosition);
    var children = configuration.children;
    state = MenuBox2DState(
      parent: parent,
      children: List.generate(
        children.length,
        (index) => _createMenuItemBox2D(
          children.elementAt(index),
          positions.elementAt(index),
        ),
      ).asMap(),
    );
    world.setContactListener(MenuContactListener());
    notifyListeners();
  }

  /// update all [Body] type to [BodyType.static] to prevent collisions
  void userMovingItems() {
    for (var body in allBodies) {
      body.setType(BodyType.static);
    }
  }

  void userStopMovingItems() {
    for (var body in allBodies) {
      body.setType(BodyType.dynamic);
    }
  }

  void update() {
    world.stepDt(1 / 60);

    for (var item in allMenuItemsBox2D) {
      item.checkCurrentPositionAndStop();
    }
    notifyListeners();
  }

  void setDebugDraw([DebugDraw? debugDraw]) {
    world.debugDraw = debugDraw;
  }

  MenuItemBox2D _createMenuItemBox2D(MenuItem item, Vector2 position) {
    var body = _createMenuItemBody(
      position,
      item.radius,
    );
    var box2D = MenuItemBox2D(
      value: item,
      body: body,
      originPosition: position,
    );
    body.userData = box2D;
    return box2D;
  }

  Body _createMenuItemBody(
    Vector2 position,
    double radius, [
    Vector2? linearVelocity,
  ]) {
    var bodyDef = BodyDef(
      type: BodyType.dynamic,
      position: position,
      linearDamping: 0,
      allowSleep: false,
      fixedRotation: true,
      linearVelocity: linearVelocity,
      // bullet: true,
    );

    var body = world.createBody(bodyDef);
    var circleShape = CircleShape(
      radius: radius,
    );
    var fixtureDef = FixtureDef(
      circleShape,
      friction: 0.0,
      restitution: 1,
      density: 0.0,
      isSensor: true,
    );
    body.createFixture(fixtureDef);
    return body;
  }

  List<Vector2> _drawHexagonCircles(
    Vector2 center,
    double radiusO,
    double radiusR1,
    double boxWidth,
    double boxHeight,
    double space,
  ) {
    List<Vector2> results = [];
    // Calculate the maximum distance to keep circles inside the box
    double maxD = min((boxWidth / 2) - radiusR1, (boxHeight / 2) - radiusR1);
    double d = radiusO + radiusR1 + space;
    double adjustedD = min(d, maxD);

    for (int i = 0; i < 6; i++) {
      double angle = (pi / 3) * i + (pi / 6); // 60 degrees in radians
      double x = center.x + adjustedD * cos(angle);
      double y = center.y + adjustedD * sin(angle);

      // Create and position each circle at (x, y)
      results.add(Vector2(x, y));
    }

    return results;
  }
}
