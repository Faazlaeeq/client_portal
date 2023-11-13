import 'dart:html' as html;

import 'package:client_portal/Database/firebase_service.dart';
import 'package:client_portal/constants.dart';
import 'package:client_portal/logic/file/files_bloc.dart';
import 'package:client_portal/models/DocFile_model.dart';
import 'package:client_portal/screens/dashboard/components/header.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class DocumentsScreen extends StatefulWidget {
  DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  final FireStoreService fireStoreService = FireStoreService("files");
  final firebaseStorage = FireStorageService();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header("Documents"),
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                tileColor: secondaryColor,
                leading: Icon(Icons.upload_file),
                title: Text("Upload Documents"),
                subtitle: Text(
                  "only .xlsx, .csv, .pdf, .doc files are allowed",
                  style: TextStyle(color: Colors.white54),
                ),
                trailing: SizedBox(
                  width: 200,
                  child: OutlinedButton(onPressed: () {
                    context.read<FilesBloc>().uploadFile();
                  }, child: BlocBuilder<FilesBloc, FilesState>(
                    builder: ((context, state) {
                      if (state is FilesLoading) {
                        return Row(
                          children: [
                            SizedBox(
                              child: CircularProgressIndicator.adaptive(
                                  strokeCap: StrokeCap.round),
                              height: 10,
                              width: 10,
                            ),
                            SizedBox(width: defaultPadding / 2),
                            Text("Uploading.."),
                          ],
                        );
                      } else {
                        return Text("Upload");
                      }
                    }),
                  )),
                ),
              ),
            ),
            SizedBox(height: defaultPadding),
            Padding(
              padding: const EdgeInsets.all(defaultPadding / 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Uploaded Documents",
                      style: Theme.of(context).textTheme.titleLarge),
                  Spacer(),
                  IconButton(
                      onPressed: () {
                        setState(() {});
                      },
                      icon: Icon(Icons.refresh))
                ],
              ),
            ),
            StreamBuilder(
              stream: fireStoreService.retriveData(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data?.docs != null) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocFileModel file = DocFileModel.fromJson(
                            snapshot.data!.docs[index].data()
                                as Map<String, dynamic>);
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding,
                              vertical: defaultPadding / 2),
                          child: ListTile(
                            enableFeedback: true,
                            enabled: true,
                            leading: Icon(Icons.file_copy),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            contentPadding: EdgeInsets.all(10),
                            tileColor: secondaryColor,
                            title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    file.name,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(file.date),
                                  Text(file.user)
                                ]),
                            subtitle: Text(double.parse(file.size) > 1000
                                ? (double.parse(file.size) / 1000)
                                        .toStringAsFixed(2) +
                                    " MB"
                                : double.parse(file.size).toStringAsFixed(2) +
                                    " KB"),
                            trailing: SizedBox(
                              width: 100,
                              child: Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        showDeleteConfirmationDialog(context,
                                            snapshot.data!.docs[index].id);
                                      },
                                      icon: Icon(Icons.delete)),
                                  IconButton(
                                    onPressed: () async {
                                      final ref = firebaseStorage.fstorage
                                          .ref()
                                          .child(file.name);

                                      final String url =
                                          await ref.getDownloadURL();

                                      downloadFile(url, file.name);
                                    },
                                    icon: Icon(Icons.download),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: ListTile(
                      leading: Icon(Icons.file_copy),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      tileColor: secondaryColor,
                      title: Text(
                        "No Files",
                      ),
                      subtitle: Text("Upload files to see here"),
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  void downloadFile(String fileUrl, String fileName) {
    final anchor = html.AnchorElement(href: fileUrl)
      ..target = 'blank'
      ..download = fileName
      ..click();
  }

  Future<void> showDeleteConfirmationDialog(
      BuildContext context, String documentId) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this item?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                fireStoreService.deleteData(documentId);
                Navigator.of(context).pop(); // Close the dialog after deletion
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
