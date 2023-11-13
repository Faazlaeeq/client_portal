import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MenuAppController extends Cubit<dynamic> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  MenuAppController() : super(0);

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
  void controlMenu() {
    debugPrint("Drawer State out");

    debugPrint(
        "Drawer State: ${_scaffoldKey.currentState?.isDrawerOpen ?? 'cant get'}");
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      debugPrint("Drawer State in");
      _scaffoldKey.currentState!.openDrawer();
    }
  }
}
