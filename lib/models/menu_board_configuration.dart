import 'package:flutter/material.dart';

enum MenuMorphType {
  hexagon(6),
  triangle(3),
  rectangle(4);

  const MenuMorphType(this.count);
  final int count;
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
  final Size boardSizePixels;
  final double parentRadius;
  final double childRadius;
  final EdgeInsetsGeometry padding;
  final LoadingConfiguration loadingConfiguration;

  final bool isDebug;

  const MenuBoardConfiguration({
    required this.type,
    required this.boardSizePixels,

    /// [parentRadius] will be prioritized.
    required this.parentRadius,
    required this.childRadius,
    this.padding = const EdgeInsets.all(16.0),
    this.loadingConfiguration = LoadingConfiguration.style1,

    /// will enable [world.drawDebugData]
    this.isDebug = false,
  });

  LoadingAnimationStyle get loadingAnimationStyle => loadingConfiguration.style;
}

class LoadingConfiguration {
  final LoadingAnimationStyle style;
  final Duration duration;

  const LoadingConfiguration({
    required this.style,
    required this.duration,
  });

  static const style1 = LoadingConfiguration(
    style: LoadingAnimationStyle.style1,
    duration: Duration(seconds: 1),
  );
}
