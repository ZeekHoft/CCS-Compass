import "package:ccs_compass/authenticate/login_page.dart";
import "package:ccs_compass/util/check_email_format.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import 'package:ccs_compass/authenticate/final_authenticate.dart'; // Import FinalAuthenticate

class RegisterPage extends StatefulWidget {
  final Function? onTap;
  const RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final idNumberController = TextEditingController();
  final courseController = TextEditingController();
  final studentNameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool validEmail = false;
  bool validId = false;

  void navigateToLogin() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  void registerStudent() async {
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
      // Create user with email and password
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Add student details to Firestore
      await addStudentDetail(
          emailController.text.trim(),
          idNumberController.text.trim(),
          courseController.text.trim(),
          studentNameController.text.trim(),
          userCredential.user?.uid // Pass the UID from the newly created user
          );

      if (mounted) {
        Navigator.of(context).pop(); // Pop the loading dialog on success
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account made successfully!')),
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const FinalAuthenticate()),
        (Route<dynamic> route) => false, // Remove all previous routes
      );
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
      }

      String userFriendlyMessage =
          "An unexpected error occurred. Please try again.";
      String debugMessage = "General Error: $e";

      if (e is FirebaseAuthException) {
        debugMessage = "Firebase Auth Error: ${e.code} - ${e.message}";
        if (e.code == "weak-password") {
          userFriendlyMessage =
              "The password provided is too weak. Please choose a stronger one.";
        } else if (e.code == "email-already-in-use") {
          userFriendlyMessage =
              "This email is already registered. Please try logging in or use a different email.";
        } else if (e.code == "invalid-email") {
          userFriendlyMessage =
              "The email address is not valid. Please check the format.";
        } else {
          userFriendlyMessage = "Registration failed: ${e.message}";
        }
      } else {
        debugMessage = "General Error: ${e.toString()}";
      }

      // Show only the AlertDialog for errors, as it requires user acknowledgement
      errorMessage(userFriendlyMessage);
      print(
          debugMessage); // Uncomment to print detailed error to console for debugging
    }
  }

  Future addStudentDetail(String email, String idnumber, String course,
      String name, String? uid) async {
    try {
      await FirebaseFirestore.instance.collection("ccs_students").add({
        "email": email,
        "idnumber": idnumber,
        "course": course,
        "name": name,
        "uid": uid, // Use the UID passed from userCredential
      });
      // SnackBar is already shown in registerStudent for overall success
    } catch (e) {
      errorMessage("Error adding student in Firestore: $e");
    }
  }

  void errorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(message),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Dismiss the error dialog
              },
              child: const Text("Ok"),
            ),
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
                      obscureText: false, // Ensure email is not obscured
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
                    controller: passwordController,
                    obscureText: false,
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
                        return "Password too short, must be at least 10 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),

                  //course
                  TextFormField(
                    controller: courseController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Enter Course"),
                      hintText: "Enter Course BSCS, DMIA, BSIT, BLISS ",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter course";
                      }
                      if (value.length < 3) {
                        return "Invalid course";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),

                  //Name
                  TextFormField(
                    controller: studentNameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Enter Name"),
                      hintText: "Enter Full Name",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter name";
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              registerStudent();
                            },
                            child: const Text("Register Student")),
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
                          onPressed: (navigateToLogin),
                          child: const Text("Login Here"))
                    ],
                  ),
                ],
              ),
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
    studentNameController.dispose();
    super.dispose();
  }
}
