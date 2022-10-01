import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smct/features/select_game/presentation/bloc/select_game_bloc.dart';

import 'body.dart';

class SelectGamePage extends StatelessWidget {
  const SelectGamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => SelectGameBloc(),
      child: const _SelectGameView(),
    );
  }
}

class _SelectGameView extends StatelessWidget {
  const _SelectGameView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        centerTitle: true,
        title: Text(
          'Game properties',
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.play_arrow),
        label: const Text('Start'),
        onPressed: () =>
            context.read<SelectGameBloc>().add(SubmitGameSettings(context)),
      ),
      body: const Body(),
    );
  }
}
