// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:smct/core/constants/constants.dart';
import 'package:smct/features/game/domain/entity/game_entity.dart';
import 'package:smct/features/game/domain/usecase/game_usecase.dart';
import 'package:smct/features/game/domain/usecase/ticker_usecase.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final GameType gameType;
  final GameMode gameMode;
  late final GameUsecase gameUsecase;

  static const int time = 3 * 60;
  static const int health = 3;
  static const int deltaPoint = 1;
  StreamSubscription<int>? _tickerSubscription;

  TextEditingController textEditingController = TextEditingController(text: '');

  GameBloc({required this.gameType, required this.gameMode})
      : super(GameRun(
            gameEntity: GameEntity.initial(), health: health, time: time)) {
    init();

    on<GameSubmitAnswer>(_onSubmit);
    on<GameFinish>(_onFinish);
    on<TimerTick>(_onTick);
    on<GameRestart>(_onStart);
  }

  void init() {
    switch (gameType) {
      case GameType.Survive:
        gameUsecase = SurviveGameUsecase();
        break;
      case GameType.Endurence:
        gameUsecase = EnduranceGameUsecase();
        _tickerSubscription =
            const Ticker().tick(ticks: state.time).listen((duration) {
          print(duration);
          add(TimerTick(duration));
        });
        break;
      case GameType.Timer:
        gameUsecase = TimerGameUsecase();
        _tickerSubscription =
            const Ticker().tick(ticks: state.time).listen((duration) {
          add(TimerTick(duration));
        });
        break;
    }
    emit(GameRun(
      gameEntity: gameUsecase.generateValues(state.gameEntity, gameMode),
      health: state.health,
      time: state.time,
    ));
  }

  void _onSubmit(GameSubmitAnswer event, Emitter<GameState> emit) {
    var health = state.health;
    var time = state.time;
    var answer = int.parse(event.answer);
    switch (gameType) {
      case GameType.Survive:
        var temp = gameUsecase.submitAnswer(
          gameEntity: state.gameEntity,
          gameMode: gameMode,
          answer: answer,
          deltaPoint: deltaPoint,
          args: health,
        );
        health = temp['health'];
        emit(health != 0
            ? GameRun(
                gameEntity: temp['gameEntity'],
                health: health,
                time: time,
              )
            : GameComplite(
                gameEntity: temp['gameEntity'],
                health: state.health,
                time: state.health));
        break;
      case GameType.Endurence:
        var temp = gameUsecase.submitAnswer(
          gameEntity: state.gameEntity,
          gameMode: gameMode,
          answer: answer,
          deltaPoint: deltaPoint,
          args: time,
        );
        emit(
          GameRun(
            gameEntity: temp['gameEntity'],
            health: health,
            time: temp['time'],
          ),
        );
        _tickerSubscription?.cancel();
        print(state.time);
        _tickerSubscription =
            const Ticker().tick(ticks: state.time).listen((duration) {
          print('$duration new');
          add(TimerTick(duration));
        });
        break;
      case GameType.Timer:
        var temp = gameUsecase.submitAnswer(
          gameEntity: state.gameEntity,
          gameMode: gameMode,
          answer: answer,
          deltaPoint: deltaPoint,
          args: time,
        );
        emit(
          GameRun(
            gameEntity: temp['gameEntity'],
            health: health,
            time: temp['time'],
          ),
        );
        break;
    }
    textEditingController.text = '';
  }

  void _onFinish(GameFinish event, Emitter<GameState> emit) =>
      throw UnimplementedError();

  void _onTick(TimerTick event, Emitter<GameState> emit) {
    if (event.duration != 0) {
      emit(GameRun(
        gameEntity: state.gameEntity,
        health: state.health,
        time: event.duration,
      ));
    } else {
      _tickerSubscription?.cancel();
      emit(
        GameComplite(
            gameEntity: state.gameEntity,
            time: state.time,
            health: state.health),
      );
    }
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _onStart(GameRestart event, Emitter<GameState> emit) {
    emit(GameRun(
        gameEntity: gameUsecase.generateValues(event.gameEntity, gameMode),
        health: health,
        time: time));
    _tickerSubscription?.cancel();
    _tickerSubscription =
        const Ticker().tick(ticks: state.time).listen((duration) {
      print(duration);
      add(TimerTick(duration));
    });
  }
}
