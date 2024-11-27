import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_menu_morph/models/models.dart';
import 'package:forge2d/forge2d.dart' hide Transform;
import 'package:provider/provider.dart';

import '../../controllers/menu_controller.dart';

part 'loading_menu_item_animation.dart';
part 'shake_menu_item_animation.dart';

// TODO: too many flags for building widgets, need to optimize
class DraggableMenuItem<T> extends StatefulWidget {
  final MenuItemBox2D itemBox2D;
  final MenuItem<T>? item;
  final int index;
  const DraggableMenuItem({
    required this.itemBox2D,
    required this.index,
    this.item,
    super.key,
  });

  @override
  State<DraggableMenuItem<T>> createState() => DraggableMenuItemState<T>();
}

class DraggableMenuItemState<T> extends State<DraggableMenuItem<T>>
    with
        TickerProviderStateMixin,
        ShakeMenuItemAnimationMixin,
        LoadingMenuItemAnimation {
  late final MenuBox2DController _controller;
  MenuItemBox2D get _itemBox2D => widget.itemBox2D;

  MenuItem? get _item => widget.item;

  bool get _isLoading => hasLoadingAnimation && _item == null;

  bool get _hasItem => _item != null;

  @override
  void initState() {
    super.initState();
    _controller = context.read<MenuBox2DController<T>>();
    _initShakeAnimationController(this);
    var style = _controller.configuration.loadingAnimationStyle;
    _initLoadingAnimationController(this, style);
  }

  @override
  void dispose() {
    _shakeAnimationCtrl.dispose();
    _loadingAnimationCtrl?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant DraggableMenuItem<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item != widget.item) {
      setState(() {});
      _stopLoadingAnimation();
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _itemBox2D.onPanUpdate(details.delta);
  }

  void _onPanEnd(DragEndDetails details) {
    _controller.userStopMovingItems();
    _itemBox2D.onPanEnd();
  }

  void _onPanStart(DragStartDetails details) {
    _itemBox2D.onPanStart();
    _controller.userMovingItems();
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
      child: FractionalTranslation(
        translation: const Offset(-.5, -.5),
        child: hasLoadingAnimation || _item != null
            ? _buildGestureItem()
            : const SizedBox.square(),
      ),
    );
  }

  Widget _buildGestureItem() {
    return IgnorePointer(
      ignoring: !_hasItem,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: hasLoadingAnimation
            ? _buildTransformScale(
                child: _buildMenuItem(),
              )
            : _buildMenuItem(),
      ),
    );
  }

  Widget _buildMenuItem() {
    return AnimatedSwitcher(
      duration: Durations.medium1,
      child: Container(
        width: _itemBox2D.radius * 2,
        height: _itemBox2D.radius * 2,
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
        child: AnimatedSwitcher(
          duration: Durations.medium1,
          child: _isLoading
              ? const SizedBox.square()
              : widget.item?.itemBuilder(context, widget.item!.data),
        ),
      ),
    );
  }
}
