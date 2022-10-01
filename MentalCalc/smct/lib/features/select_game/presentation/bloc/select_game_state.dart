part of 'select_game_bloc.dart';

@immutable
class SelectGameState extends Equatable {
  final GameType gameType;
  final GameMode gameMode;

  const SelectGameState({required this.gameType, required this.gameMode});

  factory SelectGameState.initial() {
    return const SelectGameState(
        gameType: GameType.Timer, gameMode: GameMode.Summation);
  }

  SelectGameState copyWith({GameType? gameType, GameMode? gameMode}) {
    return SelectGameState(
        gameType: gameType ?? this.gameType,
        gameMode: gameMode ?? this.gameMode);
  }

  @override
  List<Object> get props => [gameType, gameMode];
}
