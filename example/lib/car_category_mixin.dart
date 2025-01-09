import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_menu_morph/flutter_menu_morph.dart';
import 'package:svg_flutter/svg_flutter.dart';

import 'example_data_model.dart';

mixin CarCategoryMixin<T extends StatefulWidget> on State<T> {
  MenuBox2DController<CarCategory> get menuController;
  bool _isParent = true;

  void enable() {
    if (_isParent) {
      menuController.enableParent();
    } else {
      menuController.enableChildren();
    }
  }

  void disable() {
    if (_isParent) {
      menuController.disableParent();
    } else {
      menuController.disableChildren();
    }
  }

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
      children: [...categories.map((e) => _getMenuItem(e, true))],
    );
  }

  MenuItem<CarCategory> _getMenuItem(CarCategory category,
      [bool enabled = true]) {
    return MenuItem(
      data: category,
      enabled: enabled,
      itemBuilder: (_, category) {
        return _buildCategory(category);
      },
      onPressed: (data) {
        debugPrint('clicked $data');
      },
    );
  }

  BoxDecoration getBoxDecoration(
    CarCategory category,
    bool isPressed,
  ) {
    return BoxDecoration(
      color: category.enabled ? Colors.white : Colors.black12,
      shape: BoxShape.circle,
    );
  }

  Widget buildStatusButtons() {
    return SizedBox(
      height: 64.0,
      child: Row(
        children: [
          Checkbox(
            value: _isParent,
            onChanged: (value) {
              setState(() {
                _isParent = value!;
              });
            },
          ),
          Text('Parent'),
          SizedBox(width: 16.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            onPressed: enable,
            child: Text(
              'Enable',
              style: const TextStyle(color: Colors.black),
            ),
          ),
          SizedBox(width: 16.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            onPressed: disable,
            child: Text(
              'Disable',
              style: const TextStyle(color: Colors.black),
            ),
          )
        ],
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
