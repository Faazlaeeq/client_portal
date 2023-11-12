import 'package:client_portal/screens/Auth/login_screen.dart';
import 'package:client_portal/screens/FileManage/documents_screen.dart';
import 'package:client_portal/screens/main/main_screen.dart';

import 'package:flutter/material.dart';

class RoutesManager {
  static const String loginRoute = "/";
  static const String homeRoute = "/home";
  static const String documentsRoute = "/documents";

  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case ("/"):
        return MaterialPageRoute(
          builder: (context) => LoginScreen(),
        );

      case ("/home"):
        return MaterialPageRoute(
          builder: (context) => MainScreen(),
        );
      case ("/documents"):
        return MaterialPageRoute(
          builder: (context) => DocumentsScreen(),
        );
      default:
        return MaterialPageRoute(builder: (context) => LoginScreen());
    }
  }
}
