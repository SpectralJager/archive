import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'token_state.dart';

class TokenCubit extends Cubit<TokenState> {
  TokenCubit() : super(TokenInitial());
}

TokenCubit tokenCubit = TokenCubit();
