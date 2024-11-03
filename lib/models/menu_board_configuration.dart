import 'package:flutter/material.dart';

import 'menu_item.dart';

enum MenuMorphType {
  hexagon(6),
  triangle(3),
  rectangle(4);

  const MenuMorphType(this.count);
  final int count;
}

class MenuBoardConfiguration {
  final MenuMorphType type;
  final Size boardSizePixels;
  final MenuItem parent;
  final List<MenuItem> children;
  final EdgeInsetsGeometry padding;
  final bool isDebug;

  MenuBoardConfiguration({
    required this.type,
    required this.boardSizePixels,
    required this.parent,
    required this.children,
    this.padding = const EdgeInsets.all(16.0),

    /// will enable [world.drawDebugData]
    this.isDebug = false,
  }) : assert(type == MenuMorphType.hexagon ? children.length == 6 : true);

  static MenuBoardConfiguration hexagonExample(Size boardSizePixels) {
    return MenuBoardConfiguration(
      type: MenuMorphType.hexagon,
      boardSizePixels: boardSizePixels,
      parent: MenuItem(
        name: 'Parent',
        imageName: 'item1.png',
        radius: 60,
      ),
      isDebug: true,
      children: [
        MenuItem(
          name: 'Child 1',
          imageName: 'item1.png',
          radius: 50,
        ),
        MenuItem(
          name: 'Child 2',
          imageName: 'item2.png',
          radius: 50,
        ),
        MenuItem(
          name: 'Child 3',
          imageName: 'item3.png',
          radius: 50,
        ),
        MenuItem(
          name: 'Child 4',
          imageName: 'item4.png',
          radius: 50,
        ),
        MenuItem(
          name: 'Child 5',
          imageName: 'item5.png',
          radius: 50,
        ),
        MenuItem(
          name: 'Child 6',
          imageName: 'item6.png',
          radius: 50,
        ),
      ],
    );
  }
}
