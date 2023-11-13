import 'package:client_portal/logic/Home/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SideMenu extends StatelessWidget {
  SideMenu({
    Key? key,
  }) : super(key: key);
  final Map<String, dynamic> routeName = {
    "Home": [HomeRouteDashboard(), Icons.dashboard],
    "Documents": [HomeRouteDocuments(), Icons.document_scanner_outlined],
    "Profile": [HomeRouteProfile(), Icons.person_outline],
  };

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Center(
              child: Text(
                "Client Portal",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
          ListView.builder(
            itemBuilder: (context, index) {
              return DrawerListTile(
                title: routeName.keys.elementAt(index),
                icon: routeName.values.elementAt(index)[1],
                routeName: routeName.values.elementAt(index)[0],
              );
            },
            itemCount: routeName.length,
            shrinkWrap: true,
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.routeName,
    required this.icon,
  }) : super(key: key);

  final String title;
  final HomeState routeName;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        context.read<HomeBloc>().pushRoute(routeName);
      },
      leading: Icon(
        icon,
        color: Colors.white54,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}
