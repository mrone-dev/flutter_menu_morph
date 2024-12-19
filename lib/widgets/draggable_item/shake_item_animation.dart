part of 'draggable_item.dart';

const int _shakeDuration = 1000;
const List<(double, double)> _steps = [
  // (radius, weight - % of duration)
  (0.5, 0.4),
  (0.4, 0.25),
  (0.3, 0.2),
  (0.2, 0.1),
  (0.1, 0.05),
];

mixin _ShakeItemAnimationMixin<T> on State<BaseDraggableItem<T>> {
  late final AnimationController _shakeAnimationCtrl;
  late Animation<Vector2> _shakeAnimation;

  Vector2 get _originPosition => widget.itemBox2D.originPosition;

  void startShakeAnimation() {
    _setUpShakeAnimation();
    _shakeAnimationCtrl.forward();
  }

  void stopShakeAnimation() {
    if (_shakeAnimationCtrl.isAnimating) {
      _shakeAnimationCtrl.stop();
    }
  }

  void _initShakeAnimationController(BaseDraggableItemState state) {
    _shakeAnimationCtrl = AnimationController(
      vsync: state,
      duration: const Duration(milliseconds: _shakeDuration),
    );

    _shakeAnimationCtrl.addListener(() {
      if (_shakeAnimationCtrl.isCompleted) {
        _shakeAnimationCtrl.reset();
      }
    });
  }

  void _setUpShakeAnimation() {
    _shakeAnimation = TweenSequence(
      _steps.fold<List<TweenSequenceItem<Vector2>>>(
        [],
        (value, step) => value..addAll(_createTweenSequenceItem(step)),
      ),
    ).animate(
      CurvedAnimation(
        parent: _shakeAnimationCtrl,
        curve: Curves.linear,
      ),
    );
  }

  // 1 step will be have 2 moves
  // move out then move to origin position
  List<TweenSequenceItem<Vector2>> _createTweenSequenceItem(
    (double, double) step,
  ) {
    Vector2 position =
        _getRandomPositionInCircle(step.$1 * widget.itemBox2D.radius);
    var weight = (step.$2 / 2) / _shakeDuration;
    return [
      TweenSequenceItem<Vector2>(
        tween: Tween<Vector2>(
          begin: _originPosition,
          end: _originPosition + position,
        ).chain(CurveTween(curve: Curves.linear)),
        weight: weight,
      ),
      TweenSequenceItem<Vector2>(
        tween: Tween<Vector2>(
          begin: _originPosition + position,
          end: _originPosition,
        ).chain(CurveTween(curve: Curves.fastOutSlowIn)),
        weight: weight,
      ),
    ];
  }

  Vector2 _getRandomPositionInCircle(double radius) {
    var random = math.Random();
    var theta = random.nextDouble() * 2 * math.pi; // Random angle
    var r = math.sqrt(random.nextDouble()) * radius; // Random radius

    var x = r * math.cos(theta);
    var y = r * math.sin(theta);
    return Vector2(x, y);
  }
}
