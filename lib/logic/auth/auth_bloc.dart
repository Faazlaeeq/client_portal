import 'package:client_portal/Database/firebase_service.dart';
import 'package:client_portal/logic/auth/auth_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(AuthState initState) : super(initState);

  void login(String email, String password) async {
    emit(AuthLoading());

    try {
      var userCredential = await FirebaseAuthService().signIn(email, password);

      emit(AuthLoaded(userCredential));
    } catch (e) {
      debugPrint("Emitted AuthError: $e");
      emit(AuthError(e.toString()));
    }
  }

  void forgotPassword(String email) async {
    emit(AuthLoading());

    try {
      await FirebaseAuthService().sendPasswordResetEmail(email);
      emit(AuthForgotPassword());
    } catch (e) {
      debugPrint("Emitted AuthError: $e");
      emit(AuthError(e.toString()));
    }
  }
}
