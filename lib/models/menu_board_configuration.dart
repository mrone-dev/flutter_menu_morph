import 'package:flutter/material.dart';
import 'dart:math' as math;

typedef BoxDecorationBuilder<T> = BoxDecoration Function(
  T data,
  bool isPressed,
);

enum MenuMorphType {
  hexagon(6),
  triangle(3),
  rectangle(4);

  const MenuMorphType(this.count);
  final int count;

  List<double> get angles => switch (this) {
        hexagon => [
            0, // right
            math.pi / 3, // top-right
            2 * math.pi / 3, // top-left
            math.pi, // left
            4 * math.pi / 3, // bottom-left
            5 * math.pi / 3, // bottom-right
          ],
        triangle => [
            -math.pi / 2, // top
            math.pi / 6, // bottom-right
            5 * math.pi / 6, // bottom-left
          ],
        rectangle => [
            -math.pi / 2, // top
            0, // right
            math.pi / 2, // bottom
            math.pi, // left
          ],
      };
}

enum LoadingAnimationStyle {
  /// parent only
  /// it means only display parent animation
  style1,

  /// parent then children sequentially (have delay)
  style2,

  /// parent and children start animation at the same time
  style3,
}

class MenuBoardConfiguration<T> {
  final MenuMorphType type;

  /// [parentRadius] will be prioritized.
  final double parentRadius;

  /// [childRadius] will be verify again
  final double childRadius;
  final LoadingConfiguration loadingConfiguration;

  /// space between parent and child
  final double space;
  final bool startAnimationAfterRotation;
  final BoxDecorationBuilder<T>? decorationBuilder;

  /// will enable [world.drawDebugData]
  final bool isDebug;

  const MenuBoardConfiguration({
    required this.type,
    required this.parentRadius,
    required this.childRadius,
    this.loadingConfiguration = LoadingConfiguration.style1,
    this.space = 16.0,
    this.startAnimationAfterRotation = false,
    this.decorationBuilder,
    this.isDebug = false,
  });

  LoadingAnimationStyle get loadingAnimationStyle => loadingConfiguration.style;
}

class LoadingConfiguration {
  final LoadingAnimationStyle style;
  final Duration duration;
  final List<TweenSequenceItem<double>> initialTweenSequenceItems;
  final int delayStart;

  const LoadingConfiguration({
    required this.style,
    required this.duration,
    this.initialTweenSequenceItems = const [],
    this.delayStart = 200,
  });

  List<TweenSequenceItem<double>> get tweenSequenceItems =>
      initialTweenSequenceItems.isNotEmpty
          ? initialTweenSequenceItems
          : _default;

  static const LoadingConfiguration style1 = LoadingConfiguration(
    style: LoadingAnimationStyle.style1,
    duration: Duration(seconds: 1),
  );

  static final List<TweenSequenceItem<double>> _default = [
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
  ];
}
