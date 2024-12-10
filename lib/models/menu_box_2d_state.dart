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
}
