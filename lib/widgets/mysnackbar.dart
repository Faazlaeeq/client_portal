import 'package:flutter/material.dart';

class MySnackbar {
  static void showSucessSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.green[900])),
        backgroundColor: Colors.greenAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }

  static void showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text("Error: $message", style: TextStyle(color: Colors.red[900])),
        backgroundColor: Colors.red[300],
        duration: Duration(seconds: 5),
      ),
    );
  }
}
