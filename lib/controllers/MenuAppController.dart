import 'package:flutter/material.dart';

class MenuAppController extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
  GlobalKey<FormState> keySearch = GlobalKey();
  void controlMenu() {
    debugPrint("Drawer State");

    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      debugPrint("Drawer State: ${_scaffoldKey.currentState!.isDrawerOpen}");
      _scaffoldKey.currentState!.openDrawer();
    }
  }
}
