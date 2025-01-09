import 'package:flutter/material.dart';
import 'package:flutter_menu_morph/models/models.dart';
import 'package:provider/provider.dart';

import '../controllers/menu_controller.dart';
import 'debug_painter.dart';
import 'draggable_item/draggable_item.dart';

class MenuBoard<T> extends StatefulWidget {
  final MenuBoardConfiguration<T> configuration;
  final Size boardSizePixels;
  final ValueChanged<MenuBox2DController<T>>? onMenuCreated;
  final MenuBoardData<T>? initialData;
  const MenuBoard({
    required this.configuration,
    required this.boardSizePixels,
    this.onMenuCreated,
    this.initialData,
    super.key,
  });

  @override
  State<MenuBoard<T>> createState() => _MenuBoardState<T>();
}

class _MenuBoardState<T> extends State<MenuBoard<T>>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final AnimationController _animationCtrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
  );
  late final MenuBox2DController<T> _menuController;

  Size get _boardSizePixels => _menuController.boardSizePixels;
  bool get _isDebug => widget.configuration.isDebug;
  MenuState<T> get _menuState => _menuController.state;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _menuController = MenuBox2DController<T>(
      initialConfiguration: widget.configuration,
      initialData: widget.initialData,
    )..initialize(widget.boardSizePixels);
    widget.onMenuCreated?.call(_menuController);
    _animationCtrl.addListener(() {
      _onAnimationUpdate();
    });
    _animationCtrl.repeat();
  }

  @override
  void didUpdateWidget(covariant MenuBoard<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.configuration != widget.configuration) {
      _menuController.handleConfigurationChanges(widget.configuration);
    }

    if (oldWidget.boardSizePixels != widget.boardSizePixels) {
      _menuController.handleOrientationChanges(widget.boardSizePixels);
    }
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
    super.build(context);
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
      alignment: AlignmentDirectional.center,
      fit: StackFit.expand,
      children: [
        if (_isDebug) _buildDebugDraw(),
        ..._menuController.childrenBox.map(
          (entry) {
            var value = entry.value;
            return DraggableChildItem<T>(
              key: value.globalKey,
              itemBox2D: value,
              item: _getChildMenuItemByIndex(entry.key),
              index: entry.key,
            );
          },
        ),
        DraggableParentItem<T>(
          key: _menuState.parentBox.globalKey,
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
