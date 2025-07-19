import 'package:ccs_compass/util/check_email_format.dart';
import 'package:ccs_compass/util/credential_field.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final idNumberController = TextEditingController();
  final courseController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); //validate if all forms are filled in
  bool validEmail = false;
  bool validId = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _showCredentialForm(context)),
      ),
    ));
  }

  Widget _showCredentialForm(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            CredentialField(
              controller: emailController,
              hintText: "School Email",
              obscureText: false,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please Enter CPU Email";
                } else {
                  return null;
                }
              },
              onChangeFunc: (value) {
                final isValid = validateEmailAddress(value);
                setState(() {
                  validEmail = isValid;
                });
              },
            )
          ],
        ));
  }
}
