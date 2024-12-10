import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_menu_morph/models/models.dart';
import 'package:forge2d/forge2d.dart' hide Transform;
import 'package:provider/provider.dart';

import '../../controllers/menu_controller.dart';

part 'loading_item_animation.dart';
part 'shake_item_animation.dart';
part 'base_draggable_item.dart';

class DraggableParentItem<T> extends BaseDraggableItem<T> {
  const DraggableParentItem({
    required super.itemBox2D,
    required super.index,
    super.item,
    super.key,
  });

  @override
  BaseDraggableItemState<T> createState() => _DraggableParentItemState<T>();
}

class _DraggableParentItemState<T> extends BaseDraggableItemState<T> {
  @override
  bool get isParent => true;

  @override
  int get itemIndex => widget.index;
}

class DraggableChildItem<T> extends BaseDraggableItem<T> {
  const DraggableChildItem({
    required super.itemBox2D,
    required super.index,
    super.item,
    super.key,
  });

  @override
  BaseDraggableItemState<T> createState() => _DraggableChildItemState<T>();
}

class _DraggableChildItemState<T> extends BaseDraggableItemState<T> {
  @override
  bool get isParent => false;

  @override
  int get itemIndex => widget.index;
}
