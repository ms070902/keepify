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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'email',
                ),
              ),
              TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
              ),
              TextButton(
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
                child: const Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventForgotPassword());

                  //Without bloc
                  // Navigator.of(context)
                  //     .pushNamedAndRemoveUntil(registerRoute, (route) => false);
                },
                child: const Text('I forgot my password'),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventShouldRegister());

                  //Without bloc
                  // Navigator.of(context)
                  //     .pushNamedAndRemoveUntil(registerRoute, (route) => false);
                },
                child: const Text('Not register yet? Register here!'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
