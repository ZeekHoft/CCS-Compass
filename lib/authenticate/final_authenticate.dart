import 'package:ccs_compass/authenticate/check_log_or_reg.dart';
import 'package:ccs_compass/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FinalAuthenticate extends StatelessWidget {
  const FinalAuthenticate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const Home();
            } else {
              return const CheckLogOrReg();
            }
          }),
    );
  }
}
