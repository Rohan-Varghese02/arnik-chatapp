import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chat_app/features/auth/domain/entities/user_data.dart';
import 'package:chat_app/features/auth/domain/usecase/google_sign_in_usecase.dart';
import 'package:chat_app/features/auth/domain/usecase/login_usecase.dart';
import 'package:chat_app/features/auth/domain/usecase/sign_in_usecase.dart';
import 'package:chat_app/core/usecase/usecase.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase _userLogin;
  final SignInUsecase _userSignIn;
  final GoogleSignInUsecase _googleSignIn;
  AuthBloc({
    required LoginUsecase userLogin,
    required SignInUsecase userSignIn,
    required GoogleSignInUsecase googleSignIn,
  })  : _userLogin = userLogin,
        _userSignIn = userSignIn,
        _googleSignIn = googleSignIn,
        super(AuthInitial()) {
    on<AuthLogin>(authLogin);
    on<AuthSignIn>(authSignIn);
    on<GoogleSignInRequested>(googleSignInHandler);
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
    final res = await _userSignIn(
      UserSigninParams(
        name: event.name,
        email: event.email,
        password: event.password,
        photoUrl: event.photoUrl,
      ),
    );
    res.fold(
      (l) => emit(SignInFailed(message: l.message)),
      (r) => emit(SignInSuccess(user: r)),
    );
  }

  FutureOr<void> googleSignInHandler(
    GoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(GoogleSignInLoading());
    final res = await _googleSignIn(NoParams());
    res.fold(
      (l) => emit(GoogleSignInFailed(message: l.message)),
      (r) => emit(GoogleSignInSuccess(user: r)),
    );
  }
}
