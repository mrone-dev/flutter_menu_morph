part of 'draggable_menu_item.dart';

const _delayStartDefault = 200;

mixin LoadingMenuItemAnimation<T> on State<DraggableMenuItem<T>> {
  AnimationController? _loadingAnimationCtrl;
  late final Animation<double> _loadingAnimation;

  int get _itemIndex => widget.index;

  bool get _isParent => _itemIndex == MenuBox2DController.parentIndex;

  bool get hasLoadingAnimation => _loadingAnimationCtrl != null;

  void _stopLoadingAnimation() {
    _loadingAnimationCtrl?.stop();
  }

  void _initLoadingAnimationController(
    DraggableMenuItemState state,
    LoadingAnimationStyle style,
  ) {
    switch (style) {
      case LoadingAnimationStyle.style1 when _isParent:
      case LoadingAnimationStyle.style2:
        _setUpAnimationByStyle(state, true);
        break;
      case LoadingAnimationStyle.style3:
        _setUpAnimationByStyle(state);
        break;
      default:
    }
  }

  void _setUpAnimationByStyle(
    DraggableMenuItemState state, [
    bool delay = false,
  ]) {
    _loadingAnimationCtrl = AnimationController(
      vsync: state,
      duration: const Duration(seconds: 1),
    );
    var delayedAnimation = _DelayedCurvedAnimation(
      controller: _loadingAnimationCtrl!,
      delayStart: delay ? _getDelayStartByItemIndex() : Duration.zero,
      curve: Curves.linear,
    );
    _loadingAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.85)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 35.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.85, end: 1.0)
            .chain(CurveTween(curve: Curves.bounceOut)),
        weight: 65.0,
      ),
    ]).animate(delayedAnimation);
    _loadingAnimationCtrl?.repeat();
  }

  Duration _getDelayStartByItemIndex() {
    return _isParent
        ? Duration.zero
        : Duration(milliseconds: _delayStartDefault * _itemIndex);
  }

  Widget _buildTransformScale({required Widget child}) {
    return AnimatedBuilder(
      animation: _loadingAnimation,
      builder: (context, child) {
        return Transform.scale(scale: _loadingAnimation.value, child: child);
      },
      child: child,
    );
  }
}

class _DelayedCurvedAnimation extends CurvedAnimation {
  _DelayedCurvedAnimation({
    required AnimationController controller,
    Duration delayStart = Duration.zero,
    Duration delayEnd = Duration.zero,
    Curve curve = Curves.linear,
  }) : super(
          parent: controller,
          curve: _calcInterval(controller, delayStart, delayEnd, curve),
        );

  static Interval _calcInterval(
    AnimationController controller,
    Duration delayStart,
    Duration delayEnd,
    Curve curve,
  ) {
    var animationStartDelayRatio =
        delayStart.inMicroseconds / controller.duration!.inMicroseconds;
    var animationEndDelayRatio =
        delayEnd.inMicroseconds / controller.duration!.inMicroseconds;
    return Interval(
      animationStartDelayRatio,
      1 - animationEndDelayRatio,
      curve: curve,
    );
  }
}
