part of 'draggable_item.dart';

abstract class BaseMenuItemAction<T> extends StatefulWidget {
  final MenuItem<T>? item;
  final double radius;
  const BaseMenuItemAction({
    required this.item,
    required this.radius,
    super.key,
  });

  @override
  State<BaseMenuItemAction<T>> createState();
}

abstract class BaseMenuItemActionState<T, W extends BaseMenuItemAction<T>>
    extends State<W> {
  bool _isPressed = false;
  late final MenuBox2DController<T> _controller;

  @override
  void initState() {
    super.initState();
    _controller = context.read<MenuBox2DController<T>>();
  }

  @override
  void didUpdateWidget(W oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.item != oldWidget.item && mounted) {
      setState(() {});
    }
  }
}

class ElevationMenuItem<T> extends BaseMenuItemAction<T> {
  const ElevationMenuItem({
    required super.item,
    required super.radius,
    super.key,
  });

  @override
  State<ElevationMenuItem<T>> createState() => _ElevationMenuItemState<T>();
}

class _ElevationMenuItemState<T>
    extends BaseMenuItemActionState<T, ElevationMenuItem<T>> {
  void _onTap() {
    _updateIsPressed(true);
    if (widget.item?.onPressed != null) {
      widget.item!.onPressed!.call(widget.item!.data);
    }
  }

  void _updateIsPressed(bool value) {
    setState(() => _isPressed = value);
  }

  void _onTapUp(_) {
    Future<void>.delayed(Durations.short2).then((_) {
      _updateIsPressed(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _updateIsPressed(true),
      onTap: _onTap,
      onTapUp: _onTapUp,
      onTapCancel: () => _updateIsPressed(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        transform: Matrix4.translationValues(0, _isPressed ? 2.0 : 0, 0),
        child: Container(
          width: widget.radius * 2,
          height: widget.radius * 2,
          padding: _controller.configuration.itemPadding,
          decoration: _buildBoxDecoration(),
          child: widget.item?.itemBuilder(context, widget.item!.data),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() {
    if (_controller.configuration.decorationBuilder != null) {
      return _controller.configuration.decorationBuilder!(
        widget.item!.data,
        _isPressed,
      );
    }
    return BoxDecoration(
      color: (widget.item?.enabled ?? true) ? Colors.white : Colors.black12,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(_isPressed ? 13 : 26),
          blurRadius: _isPressed ? 5 : 10,
          spreadRadius: _isPressed ? 1 : 2,
          offset: Offset(0, _isPressed ? 1 : 2),
        ),
      ],
    );
  }
}
