import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smct/features/game/presentation/widgets/game_page.dart';
import 'package:smct/features/select_game/presentation/widgets/select_game_page.dart';

final routes = {
  '/': (ctx) => const SelectGamePage(),
  '/game': (context) => const GamePage(),
};
