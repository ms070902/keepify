import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/extentions/buildcontext/loc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import '../services/auth/auth_exceptions.dart';
import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_state.dart';
import '../utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

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
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, context.loc.register_error_weak_password);
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(context, context.loc.register_error_email_already_in_use);
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, context.loc.register_error_generic);
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, context.loc.register_error_invalid_email);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.loc.register),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(10, 50, 10, 20),
                  child: Image(
                    image: AssetImage('assets/icon/icon.png'),
                    width: 100,
                    height: 100,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    autofocus: true,
                    keyboardType: TextInputType.emailAddress,
                    decoration:  InputDecoration(
                      labelText: context.loc.email_text_field_placeholder,
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
                    decoration:  InputDecoration(
                      labelText: context.loc.password_text_field_placeholder,
                      filled: true,
                      fillColor: Colors.cyan[50],
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                          onPressed: () async {
                            final email = _email.text;
                            final password = _password.text;
                            context.read<AuthBloc>().add(
                                  AuthEventRegister(email, password),
                                );
                            //Without bloc
                            // try {
                            //   await AuthService.firebase().createUser(
                            //       email: email, password: password
                            //   );
                            //   AuthService.firebase().sendEmailVerification();
                            //   Navigator.of(context).pushNamed(verifyEmailRoute);
                            // } on WeakPasswordAuthException {
                            //   await showErrorDialog(context, 'Weak Password');
                            // } on EmailAlreadyInUseAuthException {
                            //   await showErrorDialog(context, 'Email is already in use');
                            // } on InvalidEmailAuthException {
                            //   await showErrorDialog(
                            //       context, 'This is an invalid email address');
                            // } on GenericAuthException {
                            //   await showErrorDialog(context, 'Registration failed ');
                            // }
                          },
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Colors.lightBlue[200],
                            elevation: 4.5,
                            shadowColor: Colors.lightBlue[50],
                          ),
                          child: Text(context.loc.register),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                            onPressed: () {
                              context.read<AuthBloc>().add(
                                    const AuthEventLogOut(),
                                  );
                              //Without bloc
                              // Navigator.of(context)
                              //     .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                            },
                            style: TextButton.styleFrom(
                              primary: Colors.lightBlue,
                            ),
                            child: Text(context.loc.register_view_already_registered)),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
