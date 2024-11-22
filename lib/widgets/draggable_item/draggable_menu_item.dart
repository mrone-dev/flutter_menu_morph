import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_menu_morph/models/models.dart';
import 'package:forge2d/forge2d.dart' hide Transform;

import '../../controllers/menu_controller.dart';

part 'loading_menu_item_animation.dart';
part 'shake_menu_item_animation.dart';

class DraggableMenuItem extends StatefulWidget {
  final MenuItemBox2D itemBox2D;
  final MenuBox2DController controller;
  final MenuItem? item;
  const DraggableMenuItem({
    required this.controller,
    required this.itemBox2D,
    this.item,
    super.key,
  });

  @override
  State<DraggableMenuItem> createState() => DraggableMenuItemState();
}

class DraggableMenuItemState extends State<DraggableMenuItem>
    with
        TickerProviderStateMixin,
        ShakeMenuItemAnimationMixin,
        LoadingMenuItemAnimation {
  MenuItemBox2D get _itemBox2D => widget.itemBox2D;

  MenuItem? get _item => widget.item;

  @override
  void initState() {
    super.initState();
    _initShakeAnimationController(this);
  }

  @override
  void dispose() {
    _shakeAnimationCtrl.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant DraggableMenuItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_item != widget.item) {
      setState(() {});
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _itemBox2D.onPanUpdate(details.delta);
  }

  void _onPanEnd(DragEndDetails details) {
    widget.controller.userStopMovingItems();
    _itemBox2D.onPanEnd();
  }

  void _onPanStart(DragStartDetails details) {
    _itemBox2D.onPanStart();
    widget.controller.userMovingItems();
    stopShakeAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shakeAnimationCtrl,
      builder: (_, child) {
        Vector2? offset;
        if (_shakeAnimationCtrl.isAnimating) {
          offset = _shakeAnimation.value;
        }

        return AnimatedPositioned(
          top: offset?.y ?? _itemBox2D.currentPosition.dy,
          left: offset?.x ?? _itemBox2D.currentPosition.dx,
          duration: Durations.short1,
          child: child!,
        );
      },
      child: _buildGestureItem(),
    );
  }

  Widget _buildGestureItem() {
    return FractionalTranslation(
      translation: const Offset(-.5, -.5),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: _buildMenuItem(),
      ),
    );
  }

  Widget _buildMenuItem() {
    if (widget.item != null) {
      return widget.item!.itemBuilder(context, widget.item);
    }
    // TODO loading widget
    return Container(
      width: widget.itemBox2D.radius * 2,
      height: widget.itemBox2D.radius * 2,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset.zero,
          ),
        ],
      ),
      child: const Center(
        child: Text(
          '_item.name',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
