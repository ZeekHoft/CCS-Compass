import 'package:ccs_compass/pages/announcement/create_announcement.dart';
import 'package:ccs_compass/util/firebase_options.dart';
import 'package:ccs_compass/util/pull_student_data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print("Error in initializing firebase on main: $e");
  }

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
          create: (context) => PullStudentData()..fetchStudentData())
    ],
    child: const MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: FinalAuthenticate(),
      home: CreateEvent(),
    ),
  ));
}
