import 'package:ccs_compass/pages/home.dart';
import 'package:ccs_compass/util/check_email_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final _formKey = GlobalKey<FormState>();

  bool validEmail = false;
  bool validId = false;

  void registerStudent() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      } catch (e) {
        // Catch dynamic to handle web-specific issues
        String message = 'An unexpected error occurred.';
        if (e is FirebaseAuthException) {
          // This block will be executed if 'e' is indeed a FirebaseAuthException
          // This is the robust way to handle it for all platforms, including web
          if (e.code == 'weak-password') {
            message = 'The password provided is too weak.';
          } else if (e.code == 'email-already-in-use') {
            message = 'The account already exists for that email.';
          } else if (e.code == 'invalid-email') {
            message = 'The email address is not valid.';
          } else {
            message = 'Firebase Auth Error: ${e.message}';
          }
          print("Firebase Auth Error: ${e.code} - ${e.message}");
        } else {
          // Fallback for any other unexpected errors, including those on web
          // that might not directly cast to FirebaseAuthException initially.
          message = 'An unexpected error occurred: ${e.toString()}';
          print("General Error: $e");
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Email"),
                        hintText: "Enter CPU Email"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please Enter Your CPU Email";
                      }
                      if (!validateEmailAddress(value)) {
                        return "Invalid email format (e.g., @cpu.edu)";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      final isValid = validateEmailAddress(value);
                      setState(() {
                        validEmail = isValid;
                      });
                    }),

                const SizedBox(
                  height: 5.0,
                ),

                //ID number
                TextFormField(
                    inputFormatters: [LengthLimitingTextInputFormatter(10)],
                    controller: idNumberController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("ID"),
                      hintText: "Enter ID Number: 99-9999-99",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter Your ID number";
                      }
                      if (!validateIDNumber(value)) {
                        // Use your utility function here
                        return "Invalid ID format 99-9999-99";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      final isValid = validateIDNumber(value);
                      setState(() {
                        validId = isValid;
                      });
                    }),

                const SizedBox(
                  height: 5.0,
                ),

                //password
                TextFormField(
                  inputFormatters: [LengthLimitingTextInputFormatter(10)],
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Password"),
                    hintText: "Enter Password",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter password";
                    }
                    if (value.length < 10) {
                      return "Password too short must be atleast 10 characters";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 40.0,
                  child: ElevatedButton(
                      onPressed: () {
                        registerStudent();
                      },
                      child: Text("Register Student")),
                )
              ],
            ),
          )),
    ));
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    idNumberController.dispose();
    courseController.dispose();
    super.dispose();
  }
}
