import 'package:client_portal/Database/firebase_service.dart';
import 'package:client_portal/constants.dart';
import 'package:client_portal/controllers/MenuAppController.dart';
import 'package:client_portal/logic/Home/home_bloc.dart';
import 'package:client_portal/logic/auth/auth_bloc.dart';
import 'package:client_portal/logic/auth/auth_state.dart';
import 'package:client_portal/logic/auth/user_bloc.dart';
import 'package:client_portal/logic/file/files_bloc.dart';
import 'package:client_portal/routes/routes_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
            create: (context) => AuthCubit(AuthInit()),
          ),
          BlocProvider<FilesBloc>(
            create: (context) => FilesBloc(FilesInitial()),
          ),
          BlocProvider<HomeBloc>(
            create: (context) => HomeBloc(),
          ),
          BlocProvider<MenuAppController>(
            create: (context) => MenuAppController(),
          ),
          BlocProvider<UserBloc>(create: (context) => UserBloc()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Client Portal',
          theme: ThemeData.dark().copyWith(
              scaffoldBackgroundColor: bgColor,
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                  seedColor: primaryColor,
                  surface: secondaryColor,
                  surfaceTint: Colors.transparent,
                  brightness: Brightness.dark),
              textTheme:
                  GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
                      .apply(
                          bodyColor: Colors.white, displayColor: Colors.white),
              canvasColor: secondaryColor,
              listTileTheme: ListTileThemeData().copyWith(
                tileColor: secondaryColor,
                selectedColor: primaryColor.withOpacity(.4),
                iconColor: Colors.white70,
                textColor: Colors.white.withOpacity(.9),
              ),
              drawerTheme: DrawerThemeData(
                  backgroundColor: secondaryColor,
                  surfaceTintColor: Colors.transparent)),
          initialRoute: FirebaseAuthService().auth.currentUser == null
              ? RoutesManager.loginRoute
              : RoutesManager.homeRoute,
          onGenerateRoute: (settings) =>
              RoutesManager().generateRoute(settings),
        ));
  }
}
