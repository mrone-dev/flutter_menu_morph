# Flutter Menu Morph

This Flutter package is inspired by the Glovo application. It leverages forge2d to handle physics-based interactions.

## Features

- Morphing menu items with customizable shapes and configurations.
- Physics-based animations and interactions.
- Support for various menu types (e.g., hexagon, triangle).
- Highly customizable design and behavior options.

![ScreenRecording2025-01-09at16 54 52-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/7d1ae52b-8303-4629-a5e8-84b54fbb899f)

## Usage

### Import the Package

```dart
import 'package:flutter_menu_morph/flutter_menu_morph.dart';
```

### Basic Usage

Use `LayoutBuilder` to obtain the largest available size, or provide your custom `Size`:

```dart
LayoutBuilder(
  builder: (context, constraints) {
    return MenuBoard<CarCategory>(
      onMenuCreated: (controller) {
        // Callback when the controller is created
      },
      boardSizePixels: constraints.biggest, // Use the largest size or your custom size
      configuration: MenuBoardConfiguration(
        type: MenuMorphType.hexagon,
        loadingConfiguration: LoadingConfiguration(
          style: LoadingAnimationStyle.style1,
          initialTweenSequenceItems: [], // Default TweenSequence will be applied if empty
          duration: const Duration(seconds: 1),
        ),
        parentRadius: 60.0,
        childRadius: 50.0,
        // BoxDecoration builder
        decorationBuilder: (
          CarCategory category,
          bool isPressed,
        ) {
          return BoxDecoration(
            color: category.enabled ? Colors.white : Colors.black12,
            shape: BoxShape.circle,
          );
        },
      ),
    );
  },
);
```

### Prepare `MenuBoardData`

Prepare `MenuBoardData` for `initialData`. Here’s an example using the `MenuMorphType.triangle` type (total children = 3):

```dart
MenuBoardData(
  parent: MenuItem(
      data: const CarCategory('Car', 'assets/icons/car.svg'),
      itemBuilder: (context, data) =>
          Container(), // Your custom widget builder
      enabled: true,
      onPressed: (data) {
        // Parent item onPressed
      }),
  children: [
    MenuItem(
      data: const CarCategory('Honda', 'assets/icons/honda.svg'),
      itemBuilder: (context, data) =>
          Container(), // Your custom widget builder
      enabled: true,
      onPressed: (data) {
        // Child item onPressed
      },
    ),
    MenuItem(
      data: const CarCategory('Lexus', 'assets/icons/lexus.svg'),
      itemBuilder: (context, data) =>
          Container(),
      enabled: true,
      onPressed: (data) { },
    ),
    MenuItem(
      data: const CarCategory('Maybach', 'assets/icons/maybach.svg'),
      itemBuilder: (context, data) =>
          Container(),
      enabled: true,
      onPressed: (data) { },
    ),
  ],
)
```
### Controlling Menu Items
`Enable` or `disable` parent:

```dart
menuController.enableParent();
menuController.disableParent();
```

`Enable` or `disable` children:
Note:  if `indexes` is empty, the action will apply to all children.

```dart
menuController.enableChildren(indexes);
menuController.disableChildren(indexes);
```

## Examples

Explore the examples provided to understand different use cases:

- `example_screen_1.dart`: Fetches data from a backend.
- `example_screen_2.dart`: Uses preloaded data.
- `car_category_mixin.dart`: Handles example data and customization.

## Contributing

Welcome feature requests and bug reports on [GitHub](https://github.com/mrone-dev/flutter_menu_morph/issues).

## Planned Improvements:

- [ ] Add more animation options after items return to their original positions.
- [ ] Support for nested categories.
- [ ] Allow custom shapes (not just circles).
- [ ] Enable dynamic scaling between parent and children (instead of fixed radius).
- [ ] Add more pressing effects for MenuItem widgets.
- [ ] Enhance contact management.
- [ ] Provide a default builder for _getMenuItem.
- [ ] Improve handling of configuration changes.
