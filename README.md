# Flutter Menu Morph
This package for Flutter. This package idea was inspired by Glovo application.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

```dart
const like = 'sample';
```

## TODO list
  - [x] MVP version
  ### Menu morph
  - [x] Hexagon
  - [x] Triangle
  - [x] Rectangle
  ### Animation
  - [x] Animation after the item goes back to origin position
  - [ ] Options to add more animation type after the item goes back to origin position
  - [x] Item initialize animation or loading animation when fetching menu list
      - [x] Style 1: parent only
      - [x] Style 2: parent then children sequentially (have delay)
      - [x] Style 3: parent and children start animation at the same time
  - [x] Customize animation (weight, duration, curve)
  ### Menu actions
  - [ ] Add "on press" CTA
  - [ ] Handle nested categories
  - [ ] Disabled item
  ### Shape
  - [ ] Allow to add custom shape instead of circle
  ### Responsive
  - [ ] Handle device rotation
  - [x] Responsive UI (item's radius, spacing)
## TO VERIFY
  - [x] Already has data (without fetch data from BE) then starts animation once.
## Add more animation style