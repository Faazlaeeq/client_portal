import 'package:client_portal/Database/firebase_service.dart';
import 'package:client_portal/screens/Auth/login_screen.dart';
import 'package:client_portal/screens/FileManage/documents_screen.dart';
import 'package:client_portal/screens/main/main_screen.dart';
import 'package:client_portal/screens/profile/profile_screen.dart';

import 'package:flutter/material.dart';

class RoutesManager {
  static const String loginRoute = "/";
  static const String homeRoute = "/home";
  static const String documentsRoute = "/documents";
  static const String profileRoute = "/profile";

  Route generateRoute(RouteSettings settings) {
    final FirebaseAuthService firebaseAuthService = FirebaseAuthService();

    switch (settings.name) {
      case ("/"):
        return MaterialPageRoute(
          builder: (context) => LoginScreen(),
        );

      case ("/home"):
        if (firebaseAuthService.auth.currentUser == null) {
          return MaterialPageRoute(
            builder: (context) => LoginScreen(),
          );
        }
        return MaterialPageRoute(
          builder: (context) => MainScreen(),
        );
      case ("/documents"):
        return MaterialPageRoute(
          builder: (context) => DocumentsScreen(),
        );

      case ("/profile"):
        return MaterialPageRoute(
          builder: (context) => ProfileScreen(),
        );

      default:
        return MaterialPageRoute(builder: (context) => LoginScreen());
    }
  }
}
