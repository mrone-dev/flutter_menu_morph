import 'package:forge2d/forge2d.dart';

import 'menu_item.dart';

enum MenuStateStatus {
  pending,
  completed,
}

class MenuState<T> {
  final MenuItemBox2D parentBox;
  final Map<int, MenuItemBox2D> childrenBox;

  /// if you are waiting for fetching data from BE
  /// initialData must be [null] then animation will be start automatically
  /// when you have data, please call [updateMenuBoardData]
  final MenuBoardData<T>? initialData;

  MenuState({
    required this.parentBox,
    required this.childrenBox,
    this.initialData,
  }) {
    _data = initialData;
  }
  MenuBoardData<T>? _data;

  bool get hasData => _data != null;

  MenuItem<T>? get parent => _data?.parent;

  List<MenuItem<T>> get children => _data?.children ?? [];

  void updateMenuBoardData(MenuBoardData<T> data) {
    _data = data;
  }

  void enableParent() {
    updateMenuBoardData(_data!.enableParent());
  }

  void disableParent() {
    updateMenuBoardData(_data!.disableParent());
  }

  /// if [indexes] is empty -> apply for all children
  void enableChildren([List<int> indexes = const []]) {
    updateMenuBoardData(_data!.enableChildren(indexes));
  }

  /// if [indexes] is empty -> apply for all children
  void disableChildren([List<int> indexes = const []]) {
    updateMenuBoardData(_data!.disableChildren(indexes));
  }

  MenuState<T> updateItemPositions(
    Vector2 parentPosition,
    List<Vector2> childrenPositions, [
    double? parentRadius,
    double? childRadius,
  ]) {
    var updatedChildrenBox = Map<int, MenuItemBox2D>.from(childrenBox);
    for (var i = 0; i < childrenPositions.length; i++) {
      updatedChildrenBox.update(
        i,
        (value) => value.updatePositionAndRadius(
          childrenPositions.elementAt(i),
          childRadius,
        ),
      );
    }

    return MenuState<T>(
      parentBox:
          parentBox.updatePositionAndRadius(parentPosition, parentRadius),
      childrenBox: updatedChildrenBox,
      initialData: this.initialData,
    );
  }
}
