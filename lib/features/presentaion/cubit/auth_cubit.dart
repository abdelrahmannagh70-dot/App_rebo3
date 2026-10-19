import 'package:app3/features/auth/data/repo/auth_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  final AuthRepo authRepo = AuthRepo();

  Future<void> login({required String email, required String password}) async {
    emit(LoginLoadingState());

    final response = await authRepo.login(email: email, password: password);

    if (response) {
      emit(LoginSuccessState());
    } else {
      emit(LoginErrorState());
    }
  }
}
