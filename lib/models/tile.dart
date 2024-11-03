import 'package:equatable/equatable.dart';

import 'position.dart';

class Tile extends Equatable {
  /// Value representing the correct position of [Tile] in a menu list.
  final int value;

  /// The correct 2D [Position] of the [Tile]. All tiles must be in their
  /// correct position to complete the puzzle.
  final Position correctPosition;

  /// The current 2D [Position] of the [Tile].
  final Position currentPosition;

  const Tile({
    required this.value,
    required this.correctPosition,
    required this.currentPosition,
  });

  Tile changePosition(Position newPosition) {
    return _copyWith(currentPosition: newPosition);
  }

  Tile _copyWith({required Position currentPosition}) {
    return Tile(
      value: value,
      correctPosition: correctPosition,
      currentPosition: currentPosition,
    );
  }

  @override
  List<Object?> get props => [correctPosition, currentPosition];
}
