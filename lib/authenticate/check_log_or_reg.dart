import 'package:ccs_compass/authenticate/login_page.dart';
import 'package:ccs_compass/authenticate/register_page.dart';
import 'package:flutter/material.dart';

class CheckLogOrReg extends StatefulWidget {
  const CheckLogOrReg({super.key});

  @override
  State<CheckLogOrReg> createState() => _CheckLogOrRegState();
}

class _CheckLogOrRegState extends State<CheckLogOrReg> {
  bool showLoginPage = true;
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        ontap: togglePages,
      );
    } else {
      return RegisterPage(onTap: togglePages);
    }
  }
}
