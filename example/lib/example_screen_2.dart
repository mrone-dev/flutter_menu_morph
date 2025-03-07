import 'package:flutter/material.dart';
import 'package:flutter_menu_morph/flutter_menu_morph.dart';

import 'car_category_mixin.dart';
import 'example_data_model.dart';

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

class _ExampleScreen2State extends State<ExampleScreen2> with CarCategoryMixin {
  late MenuBox2DController<CarCategory> _menuController;

  @override
  MenuBox2DController<CarCategory> get menuController => _menuController;

  void _onMenuCreated(
    MenuBox2DController<CarCategory> controller,
  ) async {
    _menuController = controller;
  }

  MenuBoardData<CarCategory> _getInitialData() {
    return getExampleData(widget.type);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          buildStatusButtons(),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(16.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return MenuBoard<CarCategory>(
                    onMenuCreated: _onMenuCreated,
                    initialData: _getInitialData(),
                    boardSizePixels: constraints.biggest,
                    configuration: MenuBoardConfiguration(
                      type: widget.type,
                      loadingConfiguration: LoadingConfiguration(
                        style: widget.style,
                        duration: const Duration(seconds: 1),
                      ),
                      parentRadius: 60,
                      childRadius: 50,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
