import 'package:client_portal/logic/files_bloc.dart';
import 'package:client_portal/responsive.dart';
import 'package:client_portal/screens/main/components/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                          "only .xlsx, .csv, .pdf, .doc files are allowed",
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: TextButton(onPressed: () {
                          context.read<FilesBloc>().uploadFile();
                        }, child: BlocBuilder<FilesBloc, FilesState>(
                          builder: ((context, state) {
                            if (state is FilesLoading) {
                              return Row(
                                children: [
                                  Text("Uploading.."),
                                  CircularProgressIndicator()
                                ],
                              );
                            } else {
                              return Text("Upload");
                            }
                          }),
                        )),
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
