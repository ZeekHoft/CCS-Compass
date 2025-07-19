import 'package:ccs_compass/pages/register_page.dart';
import 'package:ccs_compass/util/firebase_options.dart';
import 'package:flutter/material.dart';

Future main() async {
  try {
    DefaultFirebaseOptions.currentPlatform;
  } catch (e) {
    print("Error in initializing firebase on main: $e");
  }

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: RegisterPage(),
  ));
}
