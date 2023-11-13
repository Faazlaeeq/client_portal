import 'package:client_portal/logic/auth/auth_bloc.dart';
import 'package:client_portal/logic/auth/auth_state.dart';
import 'package:client_portal/routes/routes_manager.dart';
import 'package:client_portal/widgets/mysnackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Login Screen",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                SizedBox(height: 20),
                Form(
                    child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 300),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            final emailRegex = RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                caseSensitive: false);
                            if (!emailRegex.hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Email",
                            suffixIcon: Icon(Icons.email),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          autovalidateMode: AutovalidateMode
                              .onUserInteraction, // added to hide the password text
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Password",
                            suffixIcon: Icon(Icons.lock),
                          ),
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            String? value = emailController.text;

                            if (value.isEmpty) {
                              MySnackbar.showErrorSnackbar(
                                  context, 'Please enter your email');
                              return;
                            }
                            final emailRegex = RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                caseSensitive: false);
                            if (!emailRegex.hasMatch(value)) {
                              MySnackbar.showErrorSnackbar(
                                  context, 'Please enter a valid email');
                              return;
                            }

                            context
                                .read<AuthCubit>()
                                .forgotPassword(emailController.text);
                          },
                          child: Text("Forgot Password?")),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlinedButton(
                          onPressed: () async {
                            String email = emailController.text;
                            String password = passwordController.text;

                            context.read<AuthCubit>().login(email, password);
                          },
                          child: BlocConsumer<AuthCubit, AuthState>(
                            listener: (context, state) {
                              if (state is AuthLoaded) {
                                MySnackbar.showSucessSnackbar(
                                    context, "Login Success");
                                Navigator.of(context)
                                    .pushNamed(RoutesManager.homeRoute);
                              } else if (state is AuthError) {
                                MySnackbar.showErrorSnackbar(
                                    context, "Login Failed");
                              } else if (state is AuthForgotPassword) {
                                MySnackbar.showSucessSnackbar(
                                    context, "Password reset email sent");
                              }
                            },
                            builder: (context, state) {
                              if (state is AuthLoading) {
                                return Center(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                      height: 10,
                                      width: 10,
                                      child: CircularProgressIndicator()),
                                ));
                              }

                              return Text("Log in");
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ))
              ]),
        ),
      )),
    );
  }
}
