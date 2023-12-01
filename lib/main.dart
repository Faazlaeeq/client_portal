import 'package:client_portal/Database/firebase_service.dart';
import 'package:client_portal/Theme/app_theme_data.dart';
import 'package:client_portal/controllers/MenuAppController.dart';
import 'package:client_portal/logic/Home/home_bloc.dart';
import 'package:client_portal/logic/Theme/theme_bloc.dart';
import 'package:client_portal/logic/auth/auth_bloc.dart';
import 'package:client_portal/logic/auth/auth_state.dart';
import 'package:client_portal/logic/auth/user_bloc.dart';
import 'package:client_portal/logic/file/files_bloc.dart';
import 'package:client_portal/logic/setting/setting_bloc.dart';
import 'package:client_portal/routes/routes_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final themeBloc = ThemeBloc();
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
         
          BlocProvider<UserBloc>(create: (context) => UserBloc()),
          BlocProvider<SettingBloc>(
            create: (context) => SettingBloc(SettingInit()),
          ),
          BlocProvider<ThemeBloc>(
            create: (context) => themeBloc,
          ),
        ],
        child: BlocBuilder<ThemeBloc, bool>(
            bloc: themeBloc,
            builder: (context, state) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Client Portal',
                theme: lightTheme,
                darkTheme: darkTheme,
                themeMode: state ? ThemeMode.dark : ThemeMode.light,
                initialRoute: FirebaseAuthService().auth.currentUser == null
                    ? RoutesManager.loginRoute
                    : RoutesManager.homeRoute,
                onGenerateRoute: (settings) =>
                    RoutesManager().generateRoute(settings),
              );
            }));
  }
}
