import 'package:flutter/material.dart';
import 'package:flutter_menu_morph/models/models.dart';
import 'package:forge2d/forge2d.dart';

import 'controllers/menu_controller.dart';

class DraggableMenuItem extends StatefulWidget {
  final MenuItemBox2D itemBox2D;
  final MenuBox2DController controller;
  const DraggableMenuItem({
    required this.controller,
    required this.itemBox2D,
    super.key,
  });

  @override
  State<DraggableMenuItem> createState() => _DraggableMenuItemState();
}

class _DraggableMenuItemState extends State<DraggableMenuItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationCtrl;
  late Animation<Offset> _animation;

  MenuItemBox2D get itemBox2D => widget.itemBox2D;

  MenuItem get item => widget.itemBox2D.value;

  @override
  void initState() {
    super.initState();
    _animationCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    _animationCtrl.addListener(() {
      if (_animationCtrl.isAnimating) {
        itemBox2D.body.setTransform(
          Vector2(_animation.value.dx, _animation.value.dy),
          itemBox2D.body.angle,
        );
      } else if (_animationCtrl.isCompleted) {
        _animationCtrl.reset();
      }
    });
  }

  @override
  void dispose() {
    _animationCtrl.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant DraggableMenuItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (itemBox2D.position.x != _position.dx ||
    //     itemBox2D.position.y != _position.dy) {
    //   _getLatestPosition();
    //   setState(() {});
    // }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    itemBox2D.setTransform(details.delta);
  }

  void _onPanEnd(DragEndDetails details) {
    print('onPanEnd ${details.localPosition}');
    itemBox2D.setMovingByUser(false);
    widget.controller.userStopMovingItems();
    itemBox2D.reposition();
    // widget.itemBox2D.body.setTransform(
    //   widget.itemBox2D.originPosition,
    //   widget.itemBox2D.body.angle,
    // );
    // _animation = Tween(
    //   begin: itemBox2D.currentPosition,
    //   end: itemBox2D.originPosition.toOffset(),
    // ).animate(
    //   CurvedAnimation(
    //     parent: _animationCtrl,
    //     curve: Curves.linear,
    //   ),
    // );

    // _animationCtrl.forward(from: 0);
  }

  void _onPanStart(DragStartDetails details) {
    itemBox2D.setMovingByUser(true);
    widget.controller.userMovingItems();
    print('_onPanStart');
    if (_animationCtrl.isAnimating) {
      _animationCtrl.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      top: itemBox2D.currentPosition.dy,
      left: itemBox2D.currentPosition.dx,
      duration: Durations.short1,
      child: FractionalTranslation(
        translation: const Offset(-.5, -.5),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          child: _buildMenuItem(),
        ),
      ),
    );
  }

  Widget _buildMenuItem() {
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
      child: Center(
        child: Text(
          item.name,
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
