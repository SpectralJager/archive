import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smct/core/constants/constants.dart';
import 'package:smct/features/game/domain/usecase/game_usecase.dart';
import 'package:smct/features/game/presentation/bloc/game_bloc.dart';
import 'package:smct/features/game/presentation/widgets/game_body.dart';
import 'package:smct/features/game/presentation/widgets/game_nubpad.dart';

import 'complete_view.dart';
import 'game_header.dart';

class GamePage extends StatelessWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return BlocProvider(
      create: (ctx) => GameBloc(
        gameMode: args['gameMode'],
        gameType: args['gameType'],
      ),
      child: const _GameView(),
    );
  }
}

class _GameView extends StatelessWidget {
  const _GameView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = context.watch<GameBloc>().state;
    // GameRunning view
    Widget view = Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const GameHeader(),
            Expanded(child: SizedBox()),
            GameBody(),
            Expanded(child: SizedBox()),
            NumPad(),
          ],
        ),
      ),
    );
    if (state is GameComplite) {
      // GameComplite view
      // print('complite');
      view = const GameCompliteView();
    }
    return PageTransitionSwitcher(
      duration: const Duration(seconds: 1),
      transitionBuilder: (child, primaryAnimation, secondaryAnimation) =>
          SharedAxisTransition(
        animation: primaryAnimation,
        secondaryAnimation: secondaryAnimation,
        transitionType: SharedAxisTransitionType.horizontal,
        child: child,
      ),
      child: view,
    );
  }
}
