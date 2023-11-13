import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Cubit<User?> {
  UserBloc() : super(null);

  void setUser(User? user, BuildContext context) {
    if (user != null) {
      emit(user);
    } else {
      emit(null);
    }
  }
}
