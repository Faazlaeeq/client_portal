import 'package:client_portal/Database/firebase_service.dart';
import 'package:client_portal/logic/Theme/theme_bloc.dart';
import 'package:client_portal/logic/setting/setting_bloc.dart';
import 'package:client_portal/screens/dashboard/components/header.dart';
import 'package:client_portal/widgets/mysnackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final _passController = TextEditingController();
  final _repassController = TextEditingController();
  final firestore = FireStoreService("users");
  final auth = FirebaseAuthService();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passController.dispose();
    _repassController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocListener<SettingBloc, SettingState>(
            listener: (context, state) {
              if (state is SettingLoaded) {
                debugPrint("SettingLoaded");
                MySnackbar.showSucessSnackbar(context, "Password updated");
              }
              if (state is SettingError) {
                debugPrint("SettingError");
                MySnackbar.showErrorSnackbar(context, state.error);
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Header("Setting"),
                SizedBox(height: 64),
                Text("Change Password",
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          // color: Colors.white70,
                          fontWeight: FontWeight.bold,
                        )),
                SizedBox(height: 16),
                Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _passController,
                          decoration: InputDecoration(
                            labelText: "Password",
                            suffixIcon: Icon(Icons.lock),
                          ),
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                            controller: _repassController,
                            decoration: InputDecoration(
                              labelText: "Re-Password",
                              suffixIcon: Icon(Icons.lock),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value != _passController.text) {
                                return 'Password not matched';
                              }
                              return null;
                            }),
                      ],
                    )),
                SizedBox(height: 16),
                OutlinedButton(
                    onPressed: () async {
                      if (formKey.currentState?.validate() != null) {
                        context
                            .read<SettingBloc>()
                            .updatePassword(_passController.text);
                      }
                    },
                    child: Text('Save')),
                SizedBox(height: 64),
                Text("Change Theme",
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          // color: Colors.white70,
                          fontWeight: FontWeight.bold,
                        )),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text("Dark Mode",
                        style: Theme.of(context).textTheme.bodyLarge),
                    Spacer(),
                    Switch(
                      value: context.watch<ThemeBloc>().state,
                      onChanged: (value) {
                        context.read<ThemeBloc>().changeTheme();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
