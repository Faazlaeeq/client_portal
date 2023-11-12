import 'package:client_portal/Database/firebase_service.dart';
import 'package:client_portal/constants.dart';
import 'package:client_portal/controllers/MenuAppController.dart';
import 'package:client_portal/logic/auth/auth_bloc.dart';
import 'package:client_portal/logic/auth/auth_state.dart';
import 'package:client_portal/logic/auth/user_bloc.dart';
import 'package:client_portal/logic/file/files_bloc.dart';
import 'package:client_portal/routes/routes_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.init();
  UserBloc userBloc = UserBloc();
  FirebaseAuthService().auth.authStateChanges().listen((User? user) {
    userBloc.setUser(user);
  });

  runApp(MyApp(userBloc));
}

class MyApp extends StatelessWidget {
  final UserBloc userBloc;
  MyApp(this.userBloc, {Key? key}) : super(key: key);

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
      ],
      child: MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => MenuAppController(),
            ),
          ],
          child: BlocBuilder(
              builder: (context, state) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Client Portal',
                  theme: ThemeData.dark().copyWith(
                    scaffoldBackgroundColor: bgColor,
                    textTheme: GoogleFonts.poppinsTextTheme(
                            Theme.of(context).textTheme)
                        .apply(
                            bodyColor: Colors.white,
                            displayColor: Colors.white),
                    canvasColor: secondaryColor,
                    listTileTheme: ListTileThemeData().copyWith(
                      tileColor: secondaryColor,
                      selectedColor: primaryColor.withOpacity(.4),
                      iconColor: Colors.white70,
                      textColor: Colors.white.withOpacity(.9),
                    ),
                  ),
                  initialRoute: (state != null)
                      ? RoutesManager.homeRoute
                      : RoutesManager.loginRoute,
                  onGenerateRoute: (settings) =>
                      RoutesManager().generateRoute(settings),
                );
              },
              bloc: userBloc)),
    );
  }
}
