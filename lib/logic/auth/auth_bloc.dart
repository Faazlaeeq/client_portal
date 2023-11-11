import 'package:client_portal/Database/firebase_service.dart';
import 'package:client_portal/logic/auth/auth_state.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(AuthState initState) : super(initState);

  void login(String email, String password) async {
    emit(AuthLoading());

    var userCredential = await FirebaseAuthService().signIn(email, password);
    emit(AuthLoaded(userCredential));
  }
}
