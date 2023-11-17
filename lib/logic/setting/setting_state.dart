part of 'setting_bloc.dart';

abstract class SettingState {}

class SettingInit extends SettingState {}

class SettingLoading extends SettingState {}

class SettingLoaded extends SettingState {}

class SettingError extends SettingState {
  final String error;
  SettingError({required this.error});
}
