import 'package:flutter/material.dart';

import 'menu_item.dart';

enum MenuMorphType {
  hexagon(6),
  triangle(3),
  rectangle(4);

  const MenuMorphType(this.count);
  final int count;
}

class MenuBoardConfiguration<T> {
  final MenuMorphType type;
  final Size boardSizePixels;
  final double parentRadius;
  final double childRadius;
  final EdgeInsetsGeometry padding;

  /// if you are waiting for fetching data from BE
  /// initialData must be [null] then animation will be start automatically
  /// when you have data, please call [updateMenuBoardData]
  final MenuBoardData<T>? initialData;
  final bool isDebug;

  MenuBoardConfiguration({
    required this.type,
    required this.boardSizePixels,

    /// [parentRadius] will be prioritized.
    required this.parentRadius,
    required this.childRadius,
    this.padding = const EdgeInsets.all(16.0),
    this.initialData,

    /// will enable [world.drawDebugData]
    this.isDebug = false,
  }) {
    _data = initialData;
  }
  late MenuBoardData<T>? _data;

  bool get hasData => _data != null;

  MenuItem<T> get parent => _data!.parent;

  List<MenuItem<T>> get children => _data!.children;

  void updateMenuBoardData(MenuBoardData<T> data) {
    var length = data.children.length;
    assert(type == MenuMorphType.hexagon ? length == 6 : true);
    assert(type == MenuMorphType.triangle ? length == 3 : true);
    assert(type == MenuMorphType.rectangle ? length == 4 : true);
    _data = data;
  }
}
