import 'dart:math';

import 'package:smct/core/constants/constants.dart';
import 'package:smct/features/game/domain/entity/game_entity.dart';

abstract class GameUsecase {
  GameEntity generateValues(GameEntity gameEntity, GameMode gameMode) {
    int left = _generateValue(gameEntity.leftScope);
    int right = _generateValue(gameEntity.rightScope);
    if (gameMode == GameMode.Division) {
      while (left % right != 0 || right == 1 || right == left) {
        left = _generateValue(gameEntity.leftScope);
        right = _generateValue(gameEntity.rightScope);
      }
    } else if (gameMode == GameMode.Subtraction) {
      while (left < right) {
        left = _generateValue(gameEntity.leftScope);
        right = _generateValue(gameEntity.rightScope);
      }
    }
    return gameEntity.copyWith(leftValue: left, rightValue: right);
  }

  int _generateValue(Scope scope) {
    return Random().nextInt(scope.max - scope.min) + scope.min;
  }

  GameEntity incrementPoints(GameEntity gameEntity, int deltaPoint) {
    return gameEntity.copyWith(
      score: gameEntity.score + deltaPoint,
    );
  }

  GameEntity decrementPoints(GameEntity gameEntity, int deltaPoint) {
    return gameEntity.copyWith(
      score: gameEntity.score - deltaPoint,
    );
  }

  GameEntity changeScope(GameEntity gameEntity) {
    Scope? leftScope, rightScope;
    switch (gameEntity.lvl % 2) {
      case 1:
        leftScope =
            Scope(gameEntity.leftScope.max * 10, gameEntity.leftScope.max);
        break;
      case 0:
        rightScope =
            Scope(gameEntity.rightScope.max * 10, gameEntity.rightScope.max);
        break;
    }
    return gameEntity.copyWith(
      leftScope: leftScope ?? gameEntity.leftScope,
      rightScope: rightScope ?? gameEntity.rightScope,
    );
  }

  GameEntity changeLvl(GameEntity gameEntity) {
    return gameEntity.copyWith(lvl: gameEntity.lvl + 1);
  }

  int result(GameEntity gameEntity, GameMode gameMode) {
    int temp;
    switch (gameMode) {
      case GameMode.Summation:
        temp = gameEntity.leftValue + gameEntity.rightValue;
        break;
      case GameMode.Subtraction:
        temp = gameEntity.leftValue - gameEntity.rightValue;
        break;
      case GameMode.Division:
        temp = (gameEntity.leftValue / gameEntity.rightValue).round();
        break;
      case GameMode.Multiplication:
        temp = (gameEntity.leftValue * gameEntity.rightValue).round();
        break;
    }
    return temp;
  }

  Map<String, dynamic> submitAnswer({
    required GameEntity gameEntity,
    required GameMode gameMode,
    required int answer,
    required int deltaPoint,
    required dynamic args,
  }) =>
      throw UnimplementedError();
}

class SurviveGameUsecase extends GameUsecase {
  @override
  Map<String, dynamic> submitAnswer({
    required GameEntity gameEntity,
    required GameMode gameMode,
    required int answer,
    required int deltaPoint,
    required dynamic args,
  }) {
    int health = args as int;
    print(answer == result(gameEntity, gameMode));
    if (answer == result(gameEntity, gameMode)) {
      gameEntity = incrementPoints(gameEntity, deltaPoint);
      if (gameEntity.score % (15 * gameEntity.lvl) == 0) {
        gameEntity = changeLvl(gameEntity);
        gameEntity = changeScope(gameEntity);
      }
    } else {
      // gameEntity = decrementPoints(gameEntity, deltaPoint);
      health = health - 1;
    }
    gameEntity = generateValues(gameEntity, gameMode);
    return {"gameEntity": gameEntity.copyWith(), "health": health};
  }
}

class TimerGameUsecase extends GameUsecase {
  @override
  Map<String, dynamic> submitAnswer({
    required GameEntity gameEntity,
    required GameMode gameMode,
    required int answer,
    required int deltaPoint,
    required dynamic args,
  }) {
    int time = args as int;
    if (answer == result(gameEntity, gameMode)) {
      gameEntity = incrementPoints(gameEntity, deltaPoint);
      if (gameEntity.score % (15 * gameEntity.lvl) == 0) {
        gameEntity = changeLvl(gameEntity);
        gameEntity = changeScope(gameEntity);
      }
    } else {}
    gameEntity = generateValues(gameEntity, gameMode);
    return {"gameEntity": gameEntity.copyWith(), "time": time};
  }
}

class EnduranceGameUsecase extends GameUsecase {
  @override
  Map<String, dynamic> submitAnswer({
    required GameEntity gameEntity,
    required GameMode gameMode,
    required int answer,
    required int deltaPoint,
    required dynamic args,
  }) {
    int time = args as int;
    if (answer == result(gameEntity, gameMode)) {
      gameEntity = incrementPoints(gameEntity, deltaPoint);
      if (gameEntity.score % (15 * gameEntity.lvl) == 0) {
        gameEntity = changeLvl(gameEntity);
        gameEntity = changeScope(gameEntity);
      }
      time += gameEntity.lvl * 2;
    } else {}
    gameEntity = generateValues(gameEntity, gameMode);
    return {"gameEntity": gameEntity.copyWith(), "time": time};
  }
}
