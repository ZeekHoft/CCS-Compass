import "package:ccs_compass/pages/home.dart";
import "package:ccs_compass/util/check_email_format.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

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
  final studentNameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool validEmail = false;
  bool validId = false;

  void registerStudent() async {
    // Show loading dialog
    // showDialog(
    //   context: context,
    //   barrierDismissible:
    //       false, // Prevents dismissing the dialog by tapping outside
    //   builder: (context) {
    //     return const Center(
    //       child: CircularProgressIndicator(),
    //     );
    //   },
    // );
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        addStudentDetail(
            emailController.text.trim(),
            idNumberController.text.trim(),
            courseController.text.trim(),
            studentNameController.text.trim());
        if (mounted) {
          // Check if the widget is still in the tree
          Navigator.of(context).pop(); // Pop the loading dialog
        }
        checkStudentExist(
            emailController.text.trim(), idNumberController.text.trim());
      } catch (e) {
        // Catch dynamic to handle web-specific issues
        String message = "An unexpected error occurred.";
        if (e is FirebaseAuthException) {
          // This block will be executed if "e" is indeed a FirebaseAuthException
          // This is the robust way to handle it for all platforms, including web
          if (e.code == "weak-password") {
            message = "The password provided is too weak.";
          } else if (e.code == "email-already-in-use") {
            message = "The account already exists for that email.";
          } else if (e.code == "invalid-email") {
            message = "The email address is not valid.";
          } else {
            message = "Firebase Auth Error: ${e.message}";
          }
          errorMessage("Firebase Auth Error: ${e.code} - ${e.message}");
        } else {
          // Fallback for any other unexpected errors, including those on web
          // that might not directly cast to FirebaseAuthException initially.
          message = "An unexpected error occurred: ${e.toString()}";
          errorMessage("General Error: $e");
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    }
  }

  Future<bool> checkStudentExist(email, idnumber) async {
    return await FirebaseFirestore.instance
        .collection('ccs_students')
        .where('email', isEqualTo: email)
        .where('idnumber', isEqualTo: idnumber)
        .get()
        .then((value) => value.size > 0 ? true : false);
  }

  Future addStudentDetail(
      String email, String idnumber, String course, String name) async {
    bool result =
        await checkStudentExist(email.toString(), idnumber.toString());

    try {
      if (result == true) {
        errorMessage("User already exists in our database");
        Navigator.pop(context);
      } else {
        await FirebaseFirestore.instance.collection("ccs_students").add({
          "email": email,
          "idnumber": idnumber,
          "course": course,
          "name": name
        });
      }
    } catch (e) {
      errorMessage("error adding student in firestore $e");
    }

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Home()));
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
