import 'dart:developer';

import 'package:client_portal/Database/firebase_service.dart';
import 'package:client_portal/controllers/MenuAppController.dart';
import 'package:client_portal/responsive.dart';
import 'package:client_portal/screens/dashboard/dashboard_screen.dart';
import 'package:client_portal/screens/main/components/side_menu.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            Expanded(
                // It takes 5/6 part of the screen
                flex: 5,
                child: Container(
                    child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text("Upload Documents"),
                        subtitle: Text(
                            "only .xlsx, .csv, .pdf, .doc files are allowed"),
                        trailing: TextButton(
                            onPressed: () async {
                              var _paths;
                              try {
                                // Pick files using FilePicker
                                _paths = (await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowMultiple: false,
                                  onFileLoading: (FilePickerStatus status) =>
                                      print(status),
                                  allowedExtensions: [
                                    'png',
                                    'jpg',
                                    'jpeg',
                                    'heic'
                                  ],
                                ))
                                    ?.files;
                              } on PlatformException catch (e) {
                                log('Unsupported operation' + e.toString());
                              } catch (e) {
                                log(e.toString());
                              }

                              if (_paths != null) {
                                FireStorageService().uploadToFirebaseStorage(
                                    _paths!.first.bytes!, _paths!.first.name);
                              } else {
                                print("No file selected");
                              }
                            },
                            child: Text("Upload")),
                      ),
                    ],
                  ),
                ))),
          ],
        ),
      ),
    );
  }
}
