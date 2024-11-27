import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_menu_morph/models/models.dart';
import 'package:forge2d/forge2d.dart';
// ignore: implementation_imports
import 'package:forge2d/src/settings.dart' as settings;

import 'menu_contact_listener.dart';

class MenuBox2DController<T> with ChangeNotifier {
  final MenuBoardConfiguration configuration;
  MenuBox2DController({required this.configuration});

  static const int parentIndex = -1;

  MenuStateStatus status = MenuStateStatus.pending;
  late final World world;
  late final MenuState<T> state;

  Size get boardSizePixels => configuration.boardSizePixels;

  MenuItemBox2D get parentBox => state.parentBox;

  Iterable<MapEntry<int, MenuItemBox2D>> get childrenBox =>
      state.childrenBox.entries;
  Iterable<MenuItemBox2D> get allMenuItemsBox2D => [
        parentBox,
        ...state.childrenBox.values,
      ];

  Iterable<Body> get allBodies => [
        parentBox.body,
        ...state.childrenBox.values.map((e) => e.body),
      ];

  bool get isDebug => configuration.isDebug;

  void initialize() {
    settings.maxTranslation = 4.0;
    world = World(Vector2.zero());

    var centerPosition =
        Vector2(boardSizePixels.width / 2, boardSizePixels.height / 2);

    // TODO: check with other types
    var positions = _drawHexagonCircles(
      centerPosition,
      configuration.parentRadius,
      configuration.childRadius,
      boardSizePixels.width,
      boardSizePixels.height,
      16.0,
    );
    var parent = _createMenuItemBox2D(
      centerPosition,
      configuration.parentRadius,
    );

    state = MenuState(
      parentBox: parent,
      childrenBox: List.generate(
        configuration.type.count,
        (index) => _createMenuItemBox2D(
          positions.elementAt(index),
          configuration.childRadius,
        ),
      ).asMap(),
    );
    world.setContactListener(MenuContactListener());
    status = MenuStateStatus.completed;
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

  void updateMenuBoardData(MenuBoardData<T> data) {
    var type = configuration.type;
    var length = data.children.length;
    assert(type == MenuMorphType.hexagon ? length == 6 : true);
    assert(type == MenuMorphType.triangle ? length == 3 : true);
    assert(type == MenuMorphType.rectangle ? length == 4 : true);
    state.updateMenuBoardData(data);
    notifyListeners();
  }

  MenuItemBox2D _createMenuItemBox2D(
    Vector2 position,
    double radius,
  ) {
    var body = _createMenuItemBody(
      position,
      radius,
    );
    var box2D = MenuItemBox2D(
      body: body,
      originPosition: position,
      radius: radius,
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
