import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smct/features/game/domain/entity/game_entity.dart';
import 'package:smct/features/game/presentation/bloc/game_bloc.dart';

class GameCompliteView extends StatelessWidget {
  const GameCompliteView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var game = context.select((GameBloc bloc) => bloc.state.gameEntity);
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Your points: ${game.score}',
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
              const SizedBox(
                height: 40,
              ),
              FloatingActionButton.extended(
                heroTag: null,
                onPressed: () {
                  context
                      .read<GameBloc>()
                      .add(GameRestart(GameEntity.initial()));
                },
                elevation: 0,
                label: const Text('Try again'),
                icon: const Icon(Icons.play_arrow),
              ),
              const SizedBox(
                height: 10,
              ),
              FloatingActionButton.extended(
                heroTag: null,
                onPressed: () {
                  Navigator.pop(context);
                },
                label: const Text('back'),
                icon: const Icon(Icons.arrow_back),
                elevation: 0,
                backgroundColor: Theme.of(context).colorScheme.background,
                foregroundColor: Theme.of(context).colorScheme.onBackground,
              ),
            ],
          ),
        )
      ],
    );
  }
}
