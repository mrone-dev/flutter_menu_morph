part of 'draggable_item.dart';

class BaseDraggableItem<T> extends StatefulWidget {
  final MenuItemBox2D itemBox2D;
  final MenuItem<T>? item;
  final int index;
  const BaseDraggableItem({
    required this.itemBox2D,
    required this.index,
    this.item,
    super.key,
  });

  @override
  State<BaseDraggableItem<T>> createState() => BaseDraggableItemState<T>();
}

class BaseDraggableItemState<T> extends State<BaseDraggableItem<T>>
    with
        TickerProviderStateMixin,
        _ShakeItemAnimationMixin,
        _BaseLoadingItemAnimation {
  late final MenuBox2DController _controller;

  MenuItemBox2D get _itemBox2D => widget.itemBox2D;

  MenuItem? get _item => widget.item;

  @override
  bool get isParent => throw UnimplementedError();

  @override
  int get itemIndex => throw UnimplementedError();

  @override
  void initState() {
    super.initState();
    _controller = context.read<MenuBox2DController<T>>();
    _initShakeAnimationController(this);
    _initLoadingAnimationController(
      this,
      config: _controller.configuration.loadingConfiguration,
      hasInitialData: widget.item != null,
    );
  }

  @override
  void dispose() {
    _shakeAnimationCtrl.dispose();
    _loadingAnimationCtrl?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant BaseDraggableItem<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item != widget.item && mounted) {
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
        // child: hasLoadingAnimation || _item != null
        child: hasLoadingAnimation || _item != null
            ? _buildGestureItem()
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildGestureItem() {
    return IgnorePointer(
      ignoring: isAnimating,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: hasLoadingAnimation
            ? _buildTransformScale(
                child: _buildMenuItem(),
              )
            : _buildNoLoadingAnimation(child: _buildMenuItem()),
      ),
    );
  }

  Widget _buildMenuItem() {
    return Container(
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
      child: widget.item?.itemBuilder(context, widget.item!.data),
    );
  }
}
