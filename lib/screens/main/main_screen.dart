import 'package:client_portal/controllers/MenuAppController.dart';
import 'package:client_portal/logic/Home/home_bloc.dart';
import 'package:client_portal/responsive.dart';
import 'package:client_portal/screens/FileManage/documents_screen.dart';
import 'package:client_portal/screens/dashboard/dashboard_screen.dart';
import 'package:client_portal/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/side_menu.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuAppController>().scaffoldKey,
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
                }
                return DashboardScreen();
              }),
            ),
          ],
        ),
      ),
    );
  }
}
