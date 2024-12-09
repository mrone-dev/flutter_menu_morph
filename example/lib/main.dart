import 'package:flutter/material.dart';
import 'package:flutter_menu_morph/flutter_menu_morph.dart';

import 'example_screen_1.dart';
import 'example_screen_2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MenuMorphType _selectedType = MenuMorphType.hexagon;
  LoadingAnimationStyle _selectedAnimationType = LoadingAnimationStyle.style1;

  void _onChangedMorphType(MenuMorphType type) {
    setState(() {
      _selectedType = type;
    });
  }

  void _onChangedAnimationType(LoadingAnimationStyle style) {
    setState(() {
      _selectedAnimationType = style;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTypeCheckboxes(),
            const SizedBox(height: 24.0),
            _buildAnimationTypeCheckboxes(),
            const SizedBox(height: 48.0),
            const Text('Scenario'),
            const SizedBox(height: 16.0),
            _buildButton(
              text: 'Fetch data from BE',
              child: ExampleScreen1(
                type: _selectedType,
                style: _selectedAnimationType,
              ),
            ),
            const SizedBox(height: 16.0),
            _buildButton(
              text: 'Already have data',
              child: ExampleScreen2(
                type: _selectedType,
                style: _selectedAnimationType,
              ),
            ),
            const SizedBox(height: 16.0)
          ],
        ),
      ),
    );
  }

  Widget _buildTypeCheckboxes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var type in MenuMorphType.values) ...[
          _buildCheckBox(
            value: type == _selectedType,
            onChanged: (isSelected) {
              if (isSelected ?? false) {
                _onChangedMorphType(type);
              }
            },
          ),
          Text(type.name),
          const Spacer(),
        ]
      ],
    );
  }

  Widget _buildAnimationTypeCheckboxes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var type in LoadingAnimationStyle.values) ...[
          _buildCheckBox(
            value: type == _selectedAnimationType,
            onChanged: (isSelected) {
              if (isSelected ?? false) {
                _onChangedAnimationType(type);
              }
            },
          ),
          Text(type.name),
          const Spacer(),
        ]
      ],
    );
  }

  Widget _buildCheckBox<T>({
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Checkbox(
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildButton({
    required String text,
    required Widget child,
  }) {
    return Builder(
      builder: (context) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => child));
          },
          child: Text(
            text,
            style: const TextStyle(color: Colors.black),
          ),
        );
      },
    );
  }
}
