import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';

import '../services/auth/bloc/auth_bloc.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify email'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
        child: Column(
          children: [
            const Text(
              "We've sent you an email verification. Please open it to verify your account.",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "If you haven't received a verification email yet, press the button below else press Restart button to continue login.",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
                onPressed: () async {
                  context.read<AuthBloc>().add(
                        const AuthEventSendEmailVerification(),
                      );
                  //Without Bloc
                  // AuthService.firebase().sendEmailVerification();
                },
                style: TextButton.styleFrom(
                  primary: Colors.lightBlue,
                ),
                child: const Text('Resend email verification')),
            TextButton(
              onPressed: () async {
                context.read<AuthBloc>().add(
                      const AuthEventLogOut(),
                    );
                //Without Bloc
                // await AuthService.firebase().logOut();
                // Navigator.of(context).pushNamedAndRemoveUntil(
                //   registerRoute,
                //   (route) => false,
                // );
              },
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.lightBlue[200],
                elevation: 4.5,
                shadowColor: Colors.lightBlue[50],
              ),
              child: const Text('Restart'),
            ),
          ],
        ),
      ),
    );
  }
}
