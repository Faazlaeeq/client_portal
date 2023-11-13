import 'package:client_portal/Database/firebase_service.dart';
import 'package:client_portal/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'profile_state.dart';

class ProfileBloc extends Cubit<ProfileState> {
  FirebaseAuthService _authService = FirebaseAuthService();
  FireStoreService _storageService = FireStoreService("users");
  String? _uid;

  ProfileBloc(super.initialState) {
    _uid = _authService.auth.currentUser?.uid;
  }

  // loadProfile() async {
  //   emit(ProfileLoading());
  //   if (_uid != null) {
  //     User user;
  //     try {
  //       user = await _storageService.retriveDataMap();
  //       emit(ProfileLoaded());
  //     } catch (e) {
  //       print("Error on Profile Load :$e");
  //       emit(ProfileError(error: e.toString()));
  //     }
  //   }

  //   emit(ProfileLoaded());
  // }

  addProfile(User user) async {
    emit(ProfileLoading());
    try {
      await _storageService.insertData(user.toJson());
      emit(ProfileLoaded());
    } catch (e) {
      print("Error on Profile Load :$e");
      emit(ProfileError(error: e.toString()));
    }
  }
}
