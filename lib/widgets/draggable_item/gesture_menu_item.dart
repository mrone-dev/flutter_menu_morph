part of 'draggable_item.dart';

abstract class BaseMenuItemAction extends StatefulWidget {
  final double radius;
  final Widget? child;
  final VoidCallback? onPressed;
  const BaseMenuItemAction({
    required this.radius,
    required this.onPressed,
    this.child,
    super.key,
  });

  @override
  State<BaseMenuItemAction> createState();
}

abstract class BaseMenuItemActionState<T extends BaseMenuItemAction>
    extends State<T> {
  bool _isPressed = false;
}

class ElevationMenuItem extends BaseMenuItemAction {
  const ElevationMenuItem({
    required super.radius,
    required super.onPressed,
    super.child,
    super.key,
  });

  @override
  State<ElevationMenuItem> createState() => _ElevationMenuItemState();
}

class _ElevationMenuItemState
    extends BaseMenuItemActionState<ElevationMenuItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTap: () {
        setState(() => _isPressed = true);
        widget.onPressed?.call();
      },
      onTapUp: (_) {
        Future<void>.delayed(Durations.short2).then((_) {
          setState(() => _isPressed = false);
        });
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        transform: Matrix4.translationValues(0, _isPressed ? 2.0 : 0, 0),
        child: Container(
          width: widget.radius * 2,
          height: widget.radius * 2,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(_isPressed ? 13 : 26),
                blurRadius: _isPressed ? 5 : 10,
                spreadRadius: _isPressed ? 1 : 2,
                offset: Offset(0, _isPressed ? 1 : 2),
              ),
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
