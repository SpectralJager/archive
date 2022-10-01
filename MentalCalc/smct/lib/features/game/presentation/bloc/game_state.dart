part of 'game_bloc.dart';

abstract class GameState extends Equatable {
  const GameState(
      {required this.health, required this.time, required this.gameEntity});

  final GameEntity gameEntity;
  final int health;
  final int time;

  @override
  List<Object> get props => [gameEntity, health, time];
}

class GameRun extends GameState {
  const GameRun({
    required super.gameEntity,
    required super.health,
    required super.time,
  });
}

class GameComplite extends GameState {
  const GameComplite(
      {required super.health, required super.time, required super.gameEntity});
}
