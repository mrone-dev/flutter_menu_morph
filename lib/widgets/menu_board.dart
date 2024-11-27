import 'package:flutter/material.dart';
import 'package:flutter_menu_morph/models/models.dart';
import 'package:provider/provider.dart';

import '../controllers/menu_controller.dart';
import 'debug_painter.dart';
import 'draggable_item/draggable_menu_item.dart';

class MenuBoard<T> extends StatefulWidget {
  final MenuBoardConfiguration<T> configuration;
  final ValueChanged<MenuBox2DController<T>>? onMenuCreated;

  const MenuBoard({
    required this.configuration,
    this.onMenuCreated,
    super.key,
  });

  @override
  State<MenuBoard<T>> createState() => _MenuBoardState<T>();
}

class _MenuBoardState<T> extends State<MenuBoard<T>>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationCtrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
  );
  late final MenuBox2DController<T> _menuController;

  Size get _boardSizePixels => _menuController.boardSizePixels;
  bool get _isDebug => widget.configuration.isDebug;
  MenuState<T> get _menuState => _menuController.state;

  @override
  void initState() {
    super.initState();
    _menuController =
        MenuBox2DController<T>(configuration: widget.configuration)
          ..initialize();
    widget.onMenuCreated?.call(_menuController);
    _animationCtrl.addListener(() {
      _onAnimationUpdate();
    });
    _animationCtrl.repeat();
  }

  @override
  void didUpdateWidget(covariant MenuBoard<T> oldWidget) {
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

  MenuItem<T>? _getChildMenuItemByIndex(int index) {
    return _menuState.children.elementAtOrNull(index);
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.loose(_boardSizePixels),
      child: ChangeNotifierProvider.value(
        value: _menuController,
        builder: (_, __) {
          return Consumer<MenuBox2DController<T>>(
            builder: (_, __, ___) {
              return _buildMainBoard();
            },
          );
        },
      ),
    );
  }

  Widget _buildMainBoard() {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (_isDebug) _buildDebugDraw(),
        ..._menuController.childrenBox.map(
          (entry) {
            var value = entry.value;
            return DraggableMenuItem<T>(
              key: value.globalKey,
              itemBox2D: value,
              item: _getChildMenuItemByIndex(entry.key),
              index: entry.key,
            );
          },
        ),
        DraggableMenuItem<T>(
          itemBox2D: _menuController.parentBox,
          item: _menuState.parent,
          index: MenuBox2DController.parentIndex,
        ),
      ],
    );
  }

  Widget _buildDebugDraw() {
    return CustomPaint(
      painter: DebugPainter([..._menuController.allMenuItemsBox2D]),
    );
  }
}
