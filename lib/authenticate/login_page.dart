import 'package:ccs_compass/pages/home.dart';
import 'package:ccs_compass/authenticate/register_page.dart';
import 'package:ccs_compass/util/check_email_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final Function()? ontap;
  const LoginPage({super.key, this.ontap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool validEmail = false;

  void navigateToHome() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Home()));
  }

  void navigateToRegisteration() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const RegisterPage()));
  }

  void authenticateStudent() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      if (mounted) {
        Navigator.of(context).pop(); // Pop the loading dialog
        navigateToHome();
      }
    } on FirebaseAuthException catch (e) {
      String message;
      if (mounted) {
        Navigator.of(context).pop();
      }

      if (e.code == 'user-not-found') {
        message = ('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        message = ('Wrong password provided for that user.');
      } else if (e.code == 'invalid-email') {
        message = ('The email address is not valid.');
      } else {
        message =
            ('Firebase Auth Error: ${e.message} If not registered create an account.');
      }
      errorMessage(message);
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Pop the loading dialog
        navigateToHome();
      }
      errorMessage("Unexpected Error Occurred: ${e.toString()}");
    }
  }

  void errorMessage(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Center(child: Text(message)),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Ok"))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
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

                //password
                TextFormField(
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

                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                          onPressed: (authenticateStudent),
                          child: const Text("Login"))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                  child: Center(
                    child: Text('Some content placed here'),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: (navigateToRegisteration),
                        child: const Text("Register Here"))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
