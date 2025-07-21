import 'package:ccs_compass/authenticate/final_authenticate.dart';
import 'package:ccs_compass/authenticate/login_page.dart';
import 'package:ccs_compass/authenticate/register_page.dart';
import 'package:ccs_compass/test.dart';
import 'package:ccs_compass/util/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print("Error in initializing firebase on main: $e");
  }

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FinalAuthenticate(),
  ));
}
