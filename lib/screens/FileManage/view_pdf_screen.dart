import 'package:client_portal/Database/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class ViewPDFScreen extends StatelessWidget {
  ViewPDFScreen(this.documentName, {super.key});

  final FireStoreService fireStoreService = FireStoreService("files");
  final firebaseStorage = FireStorageService();
  late PdfController pdfController;
  final String documentName;

  bool pdfLoaded = false;

  isPdf() {
    if (documentName.contains(".pdf")) {
      return true;
    }
    return false;
  }

  loadPdf() async {
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
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text(documentName),
            ),
            body: !isPdf()
                ? Center(
                    child: Text("This is not a PDF file"),
                  )
                : FutureBuilder(
                    future: loadPdf(),
                    builder: (context, snapshot) {
                      return pdfLoaded
                          ? PdfView(
                              controller: pdfController,
                              pageSnapping: true,
                              scrollDirection: Axis.vertical,
                              physics: BouncingScrollPhysics(),
                            )
                          : Center(
                              child: CircularProgressIndicator(),
                            );
                    },
                  )));
  }
}
