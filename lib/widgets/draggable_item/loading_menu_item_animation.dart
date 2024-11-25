part of 'draggable_menu_item.dart';

mixin LoadingMenuItemAnimation<T> on State<DraggableMenuItem<T>> {
  late final AnimationController _loadingAnimationCtrl;
  late final Animation<double> _loadingAnimation;
  Vector2 get _originPosition => widget.itemBox2D.originPosition;

  void _initLoadingAnimationController(DraggableMenuItemState state) {
    _loadingAnimationCtrl = AnimationController(vsync: state);
    // var delayedAnimation = _DelayedCurvedAnimation(
    //   controller: _loadingAnimationCtrl,
    //   delayStart: delay,
    //   curve: Curves.linear,
    // );
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
