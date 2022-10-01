import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class GameEntity extends Equatable {
  final Scope leftScope, rightScope;
  final int leftValue, rightValue;
  final int score;
  final int lvl;

  const GameEntity({
    required this.leftScope,
    required this.rightScope,
    required this.leftValue,
    required this.rightValue,
    required this.score,
    required this.lvl,
  });

  factory GameEntity.initial() {
    return const GameEntity(
      leftScope: Scope(100, 10),
      rightScope: Scope(10, 1),
      leftValue: 0,
      rightValue: 0,
      score: 0,
      lvl: 1,
    );
  }

  GameEntity copyWith({
    Scope? leftScope,
    Scope? rightScope,
    int? leftValue,
    int? rightValue,
    int? score,
    int? lvl,
  }) {
    return GameEntity(
      leftScope: leftScope ?? this.leftScope,
      rightScope: rightScope ?? this.rightScope,
      leftValue: leftValue ?? this.leftValue,
      rightValue: rightValue ?? this.rightValue,
      score: score ?? this.score,
      lvl: lvl ?? this.lvl,
    );
  }

  @override
  List<Object?> get props =>
      [leftScope, rightScope, leftValue, rightValue, score, lvl];
}

@immutable
class Scope {
  final int max, min;

  const Scope(this.max, this.min);

  Scope copyWith({int? max, int? min}) {
    return Scope(
      max ?? this.max,
      min ?? this.min,
    );
  }
}
