import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/utilities/dialogs/loading_dialog.dart';
import '../services/auth/auth_exceptions.dart';
import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_state.dart';
import '../utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  CloseDialog? _closeDialogHandle;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        // TODO: implement listener
        if (state is AuthStateLoggedOut) {
          final closeDialog = _closeDialogHandle;
          if (!state.isLoading && closeDialog != null) {
            closeDialog();
            _closeDialogHandle = null;
          } else if (state.isLoading && closeDialog == null) {
            _closeDialogHandle = showLoadingDialog(
              context: context,
              text: 'Loading...',
            );
          }

          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(
                context, 'Cannot find the user with entered credentials!');
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context, 'Wrong credentials');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Authetication error');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(10, 50, 10, 30),
                  child: Image(
                    image: AssetImage('assets/icon/icon.png'),
                    width: 100,
                    height: 100,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'email',
                      filled: true,
                      fillColor: Colors.cyan[50],
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      fillColor: Colors.cyan[50],
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: () async {
                      final email = _email.text;
                      final password = _password.text;
                      context.read<AuthBloc>().add(
                            AuthEventLogIn(
                              email,
                              password,
                            ),
                          );

                      //     Without Bloc
                      //   try {
                      //

                      //      await AuthService.firebase().logIn(
                      //         email: email, password: password
                      //     );
                      //      final user = AuthService.firebase().currentUser;
                      //      if(user?.isEmailVerified??false){
                      //        Navigator.of(context)
                      //            .pushNamedAndRemoveUntil(
                      //          notesRoute, (route) => false,
                      //        );
                      //      }else{
                      //        Navigator.of(context)
                      //            .pushNamedAndRemoveUntil(
                      //          verifyEmailRoute, (route) => false,
                      //        );
                      //     }
                      //
                      //   } on UserNotFoundAuthException {
                      //     await showErrorDialog(context, 'User not found');
                      //   } on WrongPasswordAuthException {
                      //     await showErrorDialog(context, 'Wrong Password');
                      //   } on GenericAuthException {
                      //     await showErrorDialog(context, 'Authentication Error');
                      //   }
                    },
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.lightBlue[200],
                      elevation: 4.5,
                      shadowColor: Colors.lightBlue[50],
                    ),
                    child: const Text('Login'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: TextButton(
                    onPressed: () {
                      context
                          .read<AuthBloc>()
                          .add(const AuthEventForgotPassword());

                      //Without bloc
                      // Navigator.of(context)
                      //     .pushNamedAndRemoveUntil(registerRoute, (route) => false);
                    },
                    style: TextButton.styleFrom(
                      primary: Colors.lightBlue,
                    ),
                    child: const Text('I forgot my password'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: TextButton(
                    onPressed: () {
                      context
                          .read<AuthBloc>()
                          .add(const AuthEventShouldRegister());

                      //Without bloc
                      // Navigator.of(context)
                      //     .pushNamedAndRemoveUntil(registerRoute, (route) => false);
                    },
                    child: const Text('Not register yet? Register here!'),
                    style: TextButton.styleFrom(
                      primary: Colors.lightBlue,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
