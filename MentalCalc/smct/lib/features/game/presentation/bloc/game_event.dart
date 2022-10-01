part of 'game_bloc.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

class GameRestart extends GameEvent {
  final GameEntity gameEntity;

  const GameRestart(this.gameEntity);
}

class GameSubmitAnswer extends GameEvent {
  final String answer;
  const GameSubmitAnswer(this.answer);
}

class GameFinish extends GameEvent {}

class TimerTick extends GameEvent {
  final int duration;

  const TimerTick(this.duration);
}
