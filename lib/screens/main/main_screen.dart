import 'package:client_portal/Database/firebase_service.dart';
import 'package:client_portal/controllers/MenuAppController.dart';
import 'package:client_portal/logic/Home/home_bloc.dart';
import 'package:client_portal/responsive.dart';
import 'package:client_portal/routes/routes_manager.dart';
import 'package:client_portal/screens/FileManage/documents_screen.dart';
import 'package:client_portal/screens/dashboard/dashboard_screen.dart';
import 'package:client_portal/screens/profile/profile_screen.dart';
import 'package:client_portal/screens/setting/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/side_menu.dart';

class MainScreen extends StatelessWidget {
  final auth = FirebaseAuthService();
  final MenuAppController menubloc = MenuAppController();

  @override
  Widget build(BuildContext context) {
    if (auth.auth.currentUser == null) {
      Navigator.pushNamed(context, RoutesManager.loginRoute);
    }
    return BlocProvider(
      create: (context) => menubloc,
      child: Scaffold(
        key: menubloc.scaffoldKey,
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
                child:
                    BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
                  if (state is HomeRouteDashboard) {
                    return DashboardScreen();
                  } else if (state is HomeRouteDocuments) {
                    return DocumentsScreen();
                  } else if (state is HomeRouteProfile) {
                    return ProfileScreen();
                  } else if (state is HomeRouteSetting) {
                    return SettingScreen();
                  }
                  return DashboardScreen();
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
