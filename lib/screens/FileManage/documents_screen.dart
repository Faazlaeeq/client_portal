import 'package:client_portal/screens/FileManage/view_pdf_screen.dart';
import 'package:client_portal/widgets/mysnackbar.dart';
import 'package:pdfx/pdfx.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:client_portal/Database/firebase_service.dart';
import 'package:client_portal/constants.dart';
import 'package:client_portal/logic/file/files_bloc.dart';
import 'package:client_portal/models/DocFile_model.dart';
import 'package:client_portal/screens/dashboard/components/header.dart';

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
                // tileColor: secondaryColor,
                leading: Icon(Icons.upload_file),
                title: Text("Upload Documents"),
                subtitle: Text(
                  "only .xlsx, .csv, .pdf, .doc files are allowed",
                  style: Theme.of(context).textTheme.labelSmall,
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
              stream: fireStoreService.retriveDatabyEmail(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data?.docs != null) {
                  if (snapshot.data?.docs.length == 0) {
                    return Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: ListTile(
                        leading: Icon(Icons.file_copy),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        // tileColor: secondaryColor,
                        title: Text(
                          "No Files",
                        ),
                        subtitle: Text("Upload files to see here"),
                      ),
                    );
                  } else {
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
                              onTap: () async {
                                final ref = firebaseStorage.fstorage
                                    .ref()
                                    .child(file.name);
                                try {
                                  await ref.getDownloadURL();
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          ViewPDFScreen(file.name)));
                                } catch (e) {
                                  MySnackbar.showErrorSnackbar(
                                      context, "File not found");
                                }
                              },
                              enableFeedback: true,
                              enabled: true,
                              leading: Icon(Icons.file_copy),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              contentPadding: EdgeInsets.all(10),
                              // tileColor: secondaryColor,
                              title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      file.name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(file.date),
                                    Text(file.user)
                                  ]),
                              subtitle: calculateFileSize(file),
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
                  }
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: Container(child: CircularProgressIndicator()),
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
    html.AnchorElement(href: fileUrl)
      ..target = 'blank'
      ..download = fileName
      ..click();
  }

  Text calculateFileSize(DocFileModel file) {
    try {
      return Text(double.parse(file.size) > 1000
          ? (double.parse(file.size) / 1000).toStringAsFixed(2) + " MB"
          : double.parse(file.size).toStringAsFixed(2) + " KB");
    } catch (e) {
      return Text("");
    }
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

  Future<void> showPdfDialog(BuildContext context, String documentName) async {
    late PdfController pdfController;

    bool pdfLoaded = false;
    try {
      final ref = firebaseStorage.fstorage.ref(documentName);
      final pdfBytes = await ref.getData();

      if (pdfBytes != null) {
        final pdfDocument = PdfDocument.openData(pdfBytes);
        pdfController = PdfController(document: pdfDocument);
        await pdfController.loadDocument(pdfDocument);
        pdfLoaded = true;
      }
    } catch (e) {
      print('Error loading PDF from Firebase: $e');
    }

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('PDF View'),
          content: pdfLoaded
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: PdfView(
                    controller: pdfController,
                    renderer: (PdfPage page) => page.render(
                      width: page.width * 2,
                      height: page.height * 2,
                      backgroundColor: '#FFFFFF',
                    ),
                  ),
                )
              : Text("Cant load pdf"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }
}
