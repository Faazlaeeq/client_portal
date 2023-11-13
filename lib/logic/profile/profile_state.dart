part of 'profile_bloc.dart';

abstract class ProfileState {}

class ProfileInit extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {}

class ProfileError extends ProfileState {
  final String error;
  ProfileError({required this.error});
}
