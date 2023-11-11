import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState {}

class AuthInit extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoaded extends AuthState {
  UserCredential? userCredential;

  AuthLoaded(this.userCredential);
}
