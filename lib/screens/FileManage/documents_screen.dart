import 'package:client_portal/Database/firebase_service.dart';
import 'package:client_portal/constants.dart';
import 'package:client_portal/logic/file/files_bloc.dart';
import 'package:client_portal/models/DocFile_model.dart';
import 'package:client_portal/responsive.dart';
import 'package:client_portal/screens/dashboard/components/header.dart';
import 'package:client_portal/screens/main/components/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DocumentsScreen extends StatelessWidget {
  DocumentsScreen({super.key});
  final FireStoreService fireStoreService = FireStoreService("files");
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
                          trailing: OutlinedButton(onPressed: () {
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
                      SizedBox(height: defaultPadding),
                      Text("Uploaded Documents",
                          style: Theme.of(context).textTheme.headlineSmall),
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
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      tileColor: secondaryColor,
                                      title: Text(
                                        file.name,
                                      ),
                                      subtitle: Text(double.parse(file.size)
                                              .toStringAsFixed(2) +
                                          " KB"),
                                      trailing: ConstrainedBox(
                                        constraints: BoxConstraints.loose(
                                            Size.fromWidth(200)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text("Author: abc"),
                                                  Text("${file.date}"),
                                                ]),
                                            IconButton(
                                              icon: Icon(Icons.delete),
                                              onPressed: () {
                                                fireStoreService.deleteData(
                                                    snapshot
                                                        .data!.docs[index].id);
                                              },
                                            )
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
                ))),
          ],
        ),
      ),
    );
  }
}
