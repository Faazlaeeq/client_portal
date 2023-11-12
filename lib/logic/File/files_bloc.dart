import 'package:client_portal/Database/firebase_service.dart';
import 'package:client_portal/models/DocFile_model.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'files_state.dart';

class FilesBloc extends Cubit<FilesState> {
  FilesBloc(FilesInitial initial) : super(initial);

  FireStoreService _fireStoreService = FireStoreService("files");
  FireStorageService _fireStorageService = FireStorageService();
  FirebaseAuthService _firebaseService = FirebaseAuthService();

  void uploadFile() async {
    try {
      emit(FilesLoading());
      var paths = (await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: ['doc', 'docx', 'pdf', 'xlsx', 'csv'],
      ))
          ?.files;

      try {
        String filename = paths!.first.name;
        var uploadReference = await _fireStorageService.uploadToFirebaseStorage(
            paths.first.bytes!, filename);

        if (uploadReference != null) {
          var metadata = await uploadReference.getMetadata();

          double size = metadata.size! / 1024;
          String type = metadata.contentType!;

          DocFileModel fileModel = DocFileModel(
              name: filename,
              path: await uploadReference.getDownloadURL(),
              type: type,
              size: size.toString(),
              date: DateTime.now().toIso8601String().split('T')[0],
              user: _firebaseService.auth.currentUser!.email!.toString());

          _fireStoreService.insertData(fileModel.toJson());

          emit(FilesUploaded(filename: filename));
        }
      } catch (e) {
        print("Error on Firebase Upload :$e");
        emit(FilesError(error: e.toString()));
      }
    } catch (e) {
      print("Error on File Picker :$e");
      emit(FilesError(error: e.toString()));
    }
  }
}
