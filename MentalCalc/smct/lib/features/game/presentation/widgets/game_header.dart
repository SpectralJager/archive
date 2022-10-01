import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smct/features/game/domain/usecase/game_usecase.dart';
import 'package:smct/features/game/presentation/bloc/game_bloc.dart';

class GameHeader extends StatelessWidget {
  const GameHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = context.watch<GameBloc>().state;
    var score = state.gameEntity.score;
    Widget indicator = Text(
      "${state.time}",
      style: Theme.of(context)
          .textTheme
          .headlineLarge!
          .copyWith(color: Theme.of(context).colorScheme.onBackground),
    );
    if (context.read<GameBloc>().gameUsecase is SurviveGameUsecase) {
      indicator = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < state.health; i++)
            Icon(
              Icons.heart_broken,
              size: 38,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
        ],
      );
    }
    return Column(
      children: [
        Container(
          height: 64,
          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton.small(
                heroTag: null,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.clear),
              ),
              Text(
                "$score points",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(),
          child: indicator,
        ),
      ],
    );
  }
}
