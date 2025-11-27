import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chat_app/features/auth/domain/entities/user_data.dart';
import 'package:chat_app/features/auth/domain/usecase/login_usecase.dart';
import 'package:chat_app/features/auth/domain/usecase/sign_in_usecase.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase _userLogin;
  final SignInUsecase _userSignIn;
  AuthBloc({required LoginUsecase userLogin, required SignInUsecase userSignIn})
    : _userLogin = userLogin,
      _userSignIn = userSignIn,
      super(AuthInitial()) {
    on<AuthLogin>(authLogin);
    on<AuthSignIn>(authSignIn);
  }

  FutureOr<void> authLogin(AuthLogin event, Emitter<AuthState> emit) async {
    log(event.email);
    final res = await _userLogin.authRepository.loginWithEmailandPassword(
      email: event.email,
      password: event.pasword,
    );
    res.fold(
      (l) => emit(LoginFailed(message: l.message)),
      (r) => emit(LoginSuccess(user: r)),
    );
  }

  FutureOr<void> authSignIn(AuthSignIn event, Emitter<AuthState> emit) async {
    log(event.name);
    final res = await _userSignIn.authRepository.signInWithEmailAndPassword(
      name: event.name,
      email: event.email,
      password: event.password,
    );
    res.fold(
      (l) => emit(SignInFailed(message: l.message)),
      (r) => emit(SignInSuccess(user: r)),
    );
  }
}
