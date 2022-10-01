part of 'select_game_bloc.dart';

abstract class SelectGameEvent extends Equatable {
  const SelectGameEvent();

  @override
  List<Object> get props => [];
}

class ChangeGameType extends SelectGameEvent {
  final GameType gameType;

  const ChangeGameType(this.gameType);
}

class ChangeGameMode extends SelectGameEvent {
  final GameMode gameMode;

  const ChangeGameMode(this.gameMode);
}

class SubmitGameSettings extends SelectGameEvent {
  final BuildContext ctx;

  const SubmitGameSettings(this.ctx);
}
