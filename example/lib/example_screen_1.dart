import 'package:auto_size_text/auto_size_text.dart';
import 'package:example/example_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_menu_morph/flutter_menu_morph.dart';
import 'package:svg_flutter/svg_flutter.dart';

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

class _ExampleScreen1State extends State<ExampleScreen1> {
  late MenuBox2DController<CarCategory> _menuController;

  void _onMenuCreated(
    MenuBox2DController<CarCategory> controller,
  ) async {
    _menuController = controller;

    // fetch data
    Future.delayed(const Duration(seconds: 5)).then((_) {
      _menuController.updateMenuBoardData(
        MenuBoardData(
          parent: _getMenuItem(CarCategory.parent()),
          children: [
            _getMenuItem(CarCategory.child1()),
            _getMenuItem(CarCategory.child2()),
            _getMenuItem(CarCategory.child3()),
            _getMenuItem(CarCategory.child4()),
            _getMenuItem(CarCategory.child5()),
            _getMenuItem(CarCategory.child6()),
          ],
        ),
      );
    });
  }

  MenuItem<CarCategory> _getMenuItem(CarCategory category) {
    return MenuItem(
      data: category,
      itemBuilder: (_, category) {
        return _buildCategory(category);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return MenuBoard<CarCategory>(
            onMenuCreated: _onMenuCreated,
            configuration: MenuBoardConfiguration(
              boardSizePixels: constraints.biggest,
              type: widget.type,
              loadingAnimationStyle: widget.style,
              parentRadius: 60,
              childRadius: 50,
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategory(CarCategory category) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AutoSizeText(
          category.name,
          style: const TextStyle(
            fontSize: 16.0,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8.0),
        SvgPicture.asset(
          category.imagePath,
          width: 32.0,
          height: 32.0,
        ),
      ],
    );
  }
}
