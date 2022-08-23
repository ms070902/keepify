import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/extentions/buildcontext/loc.dart';
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
        title: Text(context.loc.verify_email),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
        child: Column(
          children: [
            Text(
             context.loc.verify_email_view_prompt,
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
                child: Text(context.loc.verify_email_send_email_verification)),
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
              child: Text(context.loc.restart),
            ),
          ],
        ),
      ),
    );
  }
}
