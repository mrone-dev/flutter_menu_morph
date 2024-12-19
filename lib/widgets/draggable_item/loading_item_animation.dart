part of 'draggable_item.dart';

mixin _BaseLoadingItemAnimation<T> on State<BaseDraggableItem<T>> {
  AnimationController? _loadingAnimationCtrl;
  late final Animation<double> _loadingAnimation;
  late final LoadingConfiguration _config;

  /// style 1 flag: wait until parent's animation is finished
  /// then display child
  bool _isReady = false;

  bool _hasInitialData = false;

  int get itemIndex;

  bool get isParent;

  bool get hasLoadingAnimation => _loadingAnimationCtrl != null;

  bool get isAnimating => _loadingAnimationCtrl?.isAnimating ?? false;

  void _stopLoadingAnimation() {
    _loadingAnimationCtrl?.stop();
  }

  void _initLoadingAnimationController(
    BaseDraggableItemState state, {
    required LoadingConfiguration config,
    bool hasInitialData = false,
  }) {
    _config = config;
    _hasInitialData = hasInitialData;
    switch (_config.style) {
      case LoadingAnimationStyle.style1 when isParent:
      case LoadingAnimationStyle.style2:
        _setUpAnimationByStyle(state, true);
        break;
      case LoadingAnimationStyle.style3:
        _setUpAnimationByStyle(state);
        break;
      default:
    }

    if (hasInitialData) {
      _loadingAnimationCtrl?.forward();
    } else {
      _loadingAnimationCtrl?.repeat();
    }
  }

  void _setUpAnimationByStyle(
    BaseDraggableItemState state, [
    bool delay = false,
  ]) {
    var delayStart = delay ? _getDelayStartByItemIndex() : Duration.zero;
    _loadingAnimationCtrl = AnimationController(
      vsync: state,
      duration: _config.duration + delayStart,
    );
    var delayedAnimation = _DelayedCurvedAnimation(
      controller: _loadingAnimationCtrl!,
      delayStart: delayStart,
      curve: Curves.linear,
    );
    _loadingAnimation = TweenSequence<double>(_config.tweenSequenceItems)
        .animate(delayedAnimation);
  }

  Duration _getDelayStartByItemIndex() {
    return isParent
        ? Duration.zero
        : Duration(milliseconds: _config.delayStart * (itemIndex + 1));
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

  /// for style 1
  Widget _buildNoLoadingAnimation({required Widget child}) {
    return StatefulBuilder(
      builder: (context, setState) {
        if (!_isReady) {
          Future<void>.delayed(
            _hasInitialData ? _config.duration : Duration.zero,
          ).then((_) {
            setState(() {
              _isReady = true;
            });
          });
        }

        return AnimatedSwitcher(
          duration: _config.duration,
          child: _isReady ? child : const SizedBox.shrink(),
        );
      },
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
