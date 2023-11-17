import 'package:client_portal/Database/firebase_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'setting_state.dart';

class SettingBloc extends Cubit<SettingState> {
  FirebaseAuthService _authService = FirebaseAuthService();

  SettingBloc(super.initialState) {
    emit(SettingInit());
  }

  void updatePassword(String password) async {
    emit(SettingLoading());
    try {
      await _authService.updatePassword(password);
      emit(SettingLoaded());
    } catch (e) {
      emit(SettingError(error: e.toString()));
    }
  }
}
