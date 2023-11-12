import 'package:client_portal/Database/firebase_service.dart';
import 'package:client_portal/logic/auth/auth_state.dart';
import 'package:bloc/bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(AuthState initState) : super(initState);

  void login(String email, String password) async {
    emit(AuthLoading());

    try {
      var userCredential = await FirebaseAuthService().signIn(email, password);
      emit(AuthLoaded(userCredential));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
