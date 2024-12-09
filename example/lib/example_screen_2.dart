import 'package:flutter/material.dart';
import 'package:flutter_menu_morph/flutter_menu_morph.dart';

/// Data is ready, no needs to load from BE
class ExampleScreen2 extends StatefulWidget {
  final MenuMorphType type;
  final LoadingAnimationStyle style;
  const ExampleScreen2({
    required this.type,
    required this.style,
    super.key,
  });

  @override
  State<ExampleScreen2> createState() => _ExampleScreen2State();
}

class _ExampleScreen2State extends State<ExampleScreen2> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
