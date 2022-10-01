import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smct/core/constants/constants.dart';
import 'package:smct/features/game/presentation/bloc/game_bloc.dart';

class GameBody extends StatelessWidget {
  GameBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = context.read<GameBloc>().state;
    var leftValue = state.gameEntity.leftValue;
    var rightValue = state.gameEntity.rightValue;
    var sign;
    switch (context.read<GameBloc>().gameMode) {
      case GameMode.Summation:
        sign = '+';
        break;
      case GameMode.Subtraction:
        sign = '-';
        break;
      case GameMode.Multiplication:
        sign = '*';
        break;
      case GameMode.Division:
        sign = '/';
        break;
    }
    return Column(
      children: [
        Text(
          "$leftValue $sign $rightValue",
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(
            horizontal: 80,
          ),
          margin: EdgeInsets.only(top: 10),
          child: TextFormField(
            controller: context.watch<GameBloc>().textEditingController,
            enabled: false,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
            decoration: InputDecoration(
              prefixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Answer: ',
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
