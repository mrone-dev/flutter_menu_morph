import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_menu_morph/models/models.dart';
import 'package:forge2d/forge2d.dart';
// ignore: implementation_imports
import 'package:forge2d/src/settings.dart' as settings;

import 'menu_contact_listener.dart';

class MenuBox2DController<T> with ChangeNotifier {
  final MenuBoardConfiguration configuration;
  final MenuBoardData<T>? initialData;
  MenuBox2DController({
    required this.configuration,
    this.initialData,
  });

  static const int parentIndex = -1;

  MenuStateStatus status = MenuStateStatus.pending;
  late final World world;
  late MenuState<T> state;
  late Size boardSizePixels;
  late double _childRadius;

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

  void initialize(Size size) {
    boardSizePixels = size;
    settings.maxTranslation = 4.0;
    world = World(Vector2.zero());

    var centerPosition =
        Vector2(boardSizePixels.width / 2, boardSizePixels.height / 2);

    var positions = _calculateItemPositions(centerPosition);
    var parent = MenuItemBox2D.newItemBox2D(
      world,
      centerPosition,
      configuration.parentRadius,
    );

    state = MenuState(
      parentBox: parent,
      initialData: initialData,
      childrenBox: List.generate(
        configuration.type.count,
        (index) => MenuItemBox2D.newItemBox2D(
          world,
          positions.elementAt(index),
          _childRadius,
        ),
      ).asMap(),
    );
    world.setContactListener(MenuContactListener());
    status = MenuStateStatus.completed;
    notifyListeners();
  }

  /// user moving items
  /// update all [Body] type to [BodyType.static] to prevent collisions
  void setChildBodiesToStatic() {
    for (var body in allBodies) {
      body.setType(BodyType.static);
    }
  }

  /// user stop moving items
  void setChildBodiesToDynamic() {
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

  void handleOrientationChange(Size size) {
    boardSizePixels = size;
    var centerPosition =
        Vector2(boardSizePixels.width / 2, boardSizePixels.height / 2);

    var positions = _calculateItemPositions(centerPosition);
    setChildBodiesToStatic();
    state = state.updateItemPositions(centerPosition, positions, _childRadius);
    notifyListeners();
    setChildBodiesToDynamic();
  }

  void enableParent() {
    state.enableParent();
    notifyListeners();
  }

  void disableParent() {
    state.disableParent();
    notifyListeners();
  }

  void enableChildren([List<int> indexes = const []]) {
    state.enableChildren(indexes);
    notifyListeners();
  }

  void disableChildren([List<int> indexes = const []]) {
    state.disableChildren(indexes);
    notifyListeners();
  }

  List<Vector2> _calculateItemPositions(Vector2 center) {
    var parentRadius = configuration.parentRadius;
    var childRadius = configuration.childRadius;
    var boxWidth = boardSizePixels.width;
    var boxHeight = boardSizePixels.height;
    var angles = configuration.type.angles;

    List<Vector2> results = [];

    /// max radius from center
    var maxRadius = min(
      boxWidth / 2,
      boxHeight / 2,
    );

    var availableChildRadius =
        (maxRadius - configuration.space - parentRadius) / 2;
    if (availableChildRadius < childRadius) {
      _childRadius = availableChildRadius;
    } else {
      _childRadius = configuration.childRadius;
    }
    var adjustedDistance = _childRadius + configuration.space + parentRadius;

    for (var angle in angles) {
      double x = center.x + adjustedDistance * cos(angle);
      double y = center.y + adjustedDistance * sin(angle);

      // Create and position each circle at (x, y)
      results.add(Vector2(x, y));
    }

    return results;
  }
}
