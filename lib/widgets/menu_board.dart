import 'package:flutter/material.dart';

import '../controllers/menu_controller.dart';
import 'debug_painter.dart';
import 'draggable_item/draggable_menu_item.dart';
import '../models/models.dart';

class MenuBoard extends StatefulWidget {
  final MenuBoardConfiguration configuration;
  const MenuBoard({
    required this.configuration,
    super.key,
  });

  @override
  State<MenuBoard> createState() => _MenuBoardState();
}

class _MenuBoardState extends State<MenuBoard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationCtrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
  );
  late final MenuBox2DController _menuController;

  Size get _boardSizePixels => _menuController.boardSizePixels;
  bool get _isDebug => widget.configuration.isDebug;

  @override
  void initState() {
    super.initState();
    _menuController = MenuBox2DController(configuration: widget.configuration)
      ..initialize();
    _animationCtrl.addListener(() {
      _onAnimationUpdate();
    });
    _animationCtrl.repeat();
  }

  @override
  void didUpdateWidget(covariant MenuBoard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // TODO handle rotation
  }

  @override
  void dispose() {
    _animationCtrl.removeListener(_onAnimationUpdate);
    _animationCtrl.dispose();
    super.dispose();
  }

  void _onAnimationUpdate() {
    _menuController.update();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.loose(_boardSizePixels),
      child: ListenableBuilder(
        listenable: _menuController,
        builder: (context, _) {
          return Stack(
            fit: StackFit.expand,
            children: [
              if (_isDebug) _buildDebugDraw(),
              ..._menuController.children.map(
                (e) => DraggableMenuItem(
                  key: e.globalKey,
                  controller: _menuController,
                  itemBox2D: e,
                ),
              ),
              DraggableMenuItem(
                controller: _menuController,
                itemBox2D: _menuController.parent,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDebugDraw() {
    return CustomPaint(
      painter: DebugPainter([..._menuController.allMenuItemsBox2D]),
    );
  }
}
