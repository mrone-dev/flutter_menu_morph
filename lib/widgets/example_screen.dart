import 'package:flutter/material.dart';

import 'menu_board.dart';
import '../models/menu_board_configuration.dart';

class ExampleScreen extends StatefulWidget {
  const ExampleScreen({super.key});

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return MenuBoard(
            configuration:
                MenuBoardConfiguration.hexagonExample(constraints.biggest),
          );
        },
      ),
    );
  }
}
