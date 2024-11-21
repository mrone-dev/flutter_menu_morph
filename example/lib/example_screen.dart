import 'package:auto_size_text/auto_size_text.dart';
import 'package:example/example_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_menu_morph/flutter_menu_morph.dart';
import 'package:svg_flutter/svg_flutter.dart';

class ExampleScreen extends StatefulWidget {
  const ExampleScreen({super.key});

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  late MenuBox2DController _menuController;

  void _onMenuCreated(MenuBox2DController controller) async {
    _menuController = controller;

    // fetch data
    Future.delayed(const Duration(seconds: 2)).then((_) {
      _menuController.updateMenuBoardData<CarCategory>(
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
          return MenuBoard(
            onMenuCreated: _onMenuCreated,
            configuration: MenuBoardConfiguration(
              boardSizePixels: constraints.biggest,
              type: MenuMorphType.hexagon,
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
