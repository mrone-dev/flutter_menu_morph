import 'package:example/example_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_menu_morph/flutter_menu_morph.dart';

import 'car_category_mixin.dart';

/// Fetch data from BE
class ExampleScreen1 extends StatefulWidget {
  final MenuMorphType type;
  final LoadingAnimationStyle style;
  const ExampleScreen1({
    required this.type,
    required this.style,
    super.key,
  });

  @override
  State<ExampleScreen1> createState() => _ExampleScreen1State();
}

class _ExampleScreen1State extends State<ExampleScreen1> with CarCategoryMixin {
  late MenuBox2DController<CarCategory> _menuController;

  @override
  MenuBox2DController<CarCategory> get menuController => _menuController;

  void _onMenuCreated(
    MenuBox2DController<CarCategory> controller,
  ) async {
    _menuController = controller;

    // fetch data
    Future.delayed(const Duration(seconds: 5)).then((_) {
      _menuController.updateMenuBoardData(getExampleData(widget.type));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return MenuBoard<CarCategory>(
              onMenuCreated: _onMenuCreated,
              boardSizePixels: constraints.biggest,
              configuration: MenuBoardConfiguration(
                type: widget.type,
                loadingConfiguration: LoadingConfiguration(
                  style: widget.style,
                  duration: const Duration(seconds: 1),
                ),
                parentRadius: 60,
                childRadius: 50,
                decorationBuilder: getBoxDecoration,
              ),
            );
          },
        ),
      ),
    );
  }
}
