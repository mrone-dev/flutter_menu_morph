part of 'draggable_menu_item.dart';

mixin LoadingMenuItemAnimation on State<DraggableMenuItem> {
  Vector2 get _originPosition => widget.itemBox2D.originPosition;

  void _initLoadingAnimationController(DraggableMenuItemState state) {}
}
