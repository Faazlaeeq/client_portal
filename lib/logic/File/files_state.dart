// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'files_bloc.dart';

abstract class FilesState extends Equatable {
  const FilesState();

  @override
  List<Object> get props => [];
}

class FilesInitial extends FilesState {}

class FilesLoading extends FilesState {}

class FilesUploaded extends FilesState {
  final String filename;
  FilesUploaded({
    required this.filename,
  });
}

class FilesError extends FilesState {
  final String error;
  FilesError({
    required this.error,
  });
}
