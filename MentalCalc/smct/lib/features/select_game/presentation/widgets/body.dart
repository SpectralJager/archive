import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smct/core/constants/constants.dart';
import 'package:smct/features/select_game/presentation/bloc/select_game_bloc.dart';

class Body extends StatelessWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const _SelectGameType(),
        const _SelectGameMode(),
      ],
    );
  }
}

class _SelectGameType extends StatelessWidget {
  const _SelectGameType({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 32, top: 32),
      child: CupertinoSlidingSegmentedControl<GameType>(
        children: {
          for (var item in GameType.values)
            item: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                item.name,
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                      color:
                          item == context.watch<SelectGameBloc>().state.gameType
                              ? Theme.of(context).colorScheme.onPrimaryContainer
                              : Theme.of(context).colorScheme.onPrimary,
                    ),
              ),
            ),
        },
        onValueChanged: (gameType) {
          context.read<SelectGameBloc>().add(ChangeGameType(gameType!));
        },
        groupValue: context.watch<SelectGameBloc>().state.gameType,
        thumbColor: Theme.of(context).colorScheme.primaryContainer,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class _SelectGameMode extends StatelessWidget {
  const _SelectGameMode({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: GameMode.values.length,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemBuilder: (ctx, index) {
            var gameMode = GameMode.values[index];
            return GestureDetector(
              onTap: () =>
                  context.read<SelectGameBloc>().add(ChangeGameMode(gameMode)),
              child: SvgPicture.asset(
                'assets/svg/${gameMode.name.toLowerCase()}.svg',
                color:
                    gameMode == context.watch<SelectGameBloc>().state.gameMode
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.secondary,
              ),
            );
          }),
    );
  }
}
