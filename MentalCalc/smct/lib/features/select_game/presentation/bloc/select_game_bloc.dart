import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:smct/core/constants/constants.dart';

part 'select_game_event.dart';
part 'select_game_state.dart';

class SelectGameBloc extends Bloc<SelectGameEvent, SelectGameState> {
  SelectGameBloc() : super(SelectGameState.initial()) {
    on<ChangeGameMode>(_changeGameMode, transformer: droppable());
    on<ChangeGameType>(_changeGameType, transformer: droppable());
    on<SubmitGameSettings>(_submitGameSettings, transformer: droppable());
  }

  FutureOr<void> _changeGameMode(
      ChangeGameMode event, Emitter<SelectGameState> emit) {
    emit(state.copyWith(gameMode: event.gameMode));
  }

  FutureOr<void> _changeGameType(
      ChangeGameType event, Emitter<SelectGameState> emit) {
    emit(state.copyWith(gameType: event.gameType));
  }

  FutureOr<void> _submitGameSettings(
      SubmitGameSettings event, Emitter<SelectGameState> emit) {
    Navigator.of(event.ctx).pushNamed(
      '/game',
      arguments: {
        'gameType': state.gameType,
        'gameMode': state.gameMode,
      },
    );
  }
}
