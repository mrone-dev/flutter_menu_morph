import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_menu_morph/flutter_menu_morph.dart';
import 'package:svg_flutter/svg_flutter.dart';

import 'example_data_model.dart';

mixin CarCategoryMixin {
  MenuBoardData<CarCategory> getExampleData(MenuMorphType type) {
    var categories = switch (type) {
      MenuMorphType.hexagon => [
          CarCategory.child1(),
          CarCategory.child2(),
          CarCategory.child3(),
          CarCategory.child4(),
          CarCategory.child5(),
          CarCategory.child6(),
        ],
      MenuMorphType.triangle => [
          CarCategory.child1(),
          CarCategory.child2(),
          CarCategory.child3(),
        ],
      MenuMorphType.rectangle => [
          CarCategory.child1(),
          CarCategory.child2(),
          CarCategory.child3(),
          CarCategory.child4(),
        ],
    };

    return MenuBoardData(
      parent: _getMenuItem(CarCategory.parent()),
      children: [...categories.map((e) => _getMenuItem(e))],
    );
  }

  MenuItem<CarCategory> _getMenuItem(CarCategory category) {
    return MenuItem(
      data: category,
      itemBuilder: (_, category) {
        return _buildCategory(category);
      },
      onPressed: (data) {
        debugPrint('clicked $data');
      },
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
