import 'dart:ui';

import 'package:forge2d/forge2d.dart';

extension Vector2Extension on Vector2 {
  Offset toOffset() {
    return Offset(x, y);
  }
}
