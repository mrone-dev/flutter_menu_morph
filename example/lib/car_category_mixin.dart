import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_menu_morph/flutter_menu_morph.dart';
import 'package:svg_flutter/svg_flutter.dart';

import 'example_data_model.dart';

mixin CarCategoryMixin {
  MenuBoardData<CarCategory> getExampleData() {
    return MenuBoardData(
      parent: _getMenuItem(CarCategory.parent()),
      children: [
        _getMenuItem(CarCategory.child1()),
        _getMenuItem(CarCategory.child2()),
        _getMenuItem(CarCategory.child3()),
        _getMenuItem(CarCategory.child4()),
        _getMenuItem(CarCategory.child5()),
        _getMenuItem(CarCategory.child6()),
      ],
    );
  }

  MenuItem<CarCategory> _getMenuItem(CarCategory category) {
    return MenuItem(
      data: category,
      itemBuilder: (_, category) {
        return _buildCategory(category);
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
