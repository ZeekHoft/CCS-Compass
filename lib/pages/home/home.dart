import 'package:ccs_compass/util/pull_student_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final pullStudentData = context.watch<PullStudentData>();
    if (pullStudentData.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // final email = pullStudentData.email;
    final idnumber = pullStudentData.idnumber;
    final course = pullStudentData.course;
    final name = pullStudentData.name;

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              Text(name),
              Text(idnumber),
              Text(course),
            ],
          ),
        ),
      ),
    );
  }
}
