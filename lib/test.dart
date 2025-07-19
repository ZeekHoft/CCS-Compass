// import 'package:ccs_compass/pages/home.dart';
// import 'package:ccs_compass/util/check_email_format.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class RegisterPage extends StatefulWidget {
//   const RegisterPage({super.key});

//   @override
//   State<RegisterPage> createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage> {
//   final _formKey = GlobalKey<FormState>();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final idNumberController = TextEditingController();
//   final courseController = TextEditingController();

//   // You might not need these boolean flags if you're primarily relying on TextFormField's validator
//   // and the formKey. However, if you have other UI elements depending on validity, keep them.
//   bool validEmail = false;
//   bool validId = false;

//   void registerStudent() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         await FirebaseAuth.instance.createUserWithEmailAndPassword(
//           email: emailController.text.trim(),
//           password: passwordController.text.trim(),
//         );
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => Home()),
//         );
//       } catch (e) {
//         // Catch dynamic to handle web-specific issues
//         String message = 'An unexpected error occurred.';
//         if (e is FirebaseAuthException) {
//           // This block will be executed if 'e' is indeed a FirebaseAuthException
//           // This is the robust way to handle it for all platforms, including web
//           if (e.code == 'weak-password') {
//             message = 'The password provided is too weak.';
//           } else if (e.code == 'email-already-in-use') {
//             message = 'The account already exists for that email.';
//           } else if (e.code == 'invalid-email') {
//             message = 'The email address is not valid.';
//           } else {
//             message = 'Firebase Auth Error: ${e.message}';
//           }
//           print("Firebase Auth Error: ${e.code} - ${e.message}");
//         } else {
//           // Fallback for any other unexpected errors, including those on web
//           // that might not directly cast to FirebaseAuthException initially.
//           message = 'An unexpected error occurred: ${e.toString()}';
//           print("General Error: $e");
//         }

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(message)),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text("Register Student"),
//         ),
//         body: SingleChildScrollView(
//           scrollDirection: Axis.vertical,
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 TextFormField(
//                   controller: emailController,
//                   keyboardType: TextInputType.emailAddress,
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     label: Text("Email"),
//                     hintText: "Enter CPU Email (e.g., student@cpu.edu)",
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return "Please Enter Your CPU Email";
//                     }
//                     if (!validateEmailAddress(value)) {
//                       return "Invalid email format (e.g., @cpu.edu)";
//                     }
//                     return null;
//                   },
//                   onChanged: (value) {
//                     setState(() {
//                       validEmail = validateEmailAddress(value);
//                     });
//                   },
//                 ),
//                 const SizedBox(height: 15.0),
//                 TextFormField(
//                   inputFormatters: [LengthLimitingTextInputFormatter(10)],
//                   controller: idNumberController,
//                   keyboardType: TextInputType.number,
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     label: Text("ID Number"),
//                     hintText: "Enter ID Number: 99-9999-99",
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return "Please enter Your ID number";
//                     }
//                     if (!validateIDNumber(value)) {
//                       return "Invalid ID format (e.g., 99-9999-99)";
//                     }
//                     return null;
//                   },
//                   onChanged: (value) {
//                     setState(() {
//                       validId = validateIDNumber(value);
//                     });
//                   },
//                 ),
//                 const SizedBox(height: 15.0),
//                 TextFormField(
//                   controller: passwordController,
//                   obscureText: true,
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     label: Text("Password"),
//                     hintText: "Enter Password (min 6 characters)",
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return "Please enter password";
//                     }
//                     if (value.length < 6) {
//                       return "Password must be at least 6 characters long";
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20.0),
//                 SizedBox(
//                   width: double.infinity,
//                   height: 50.0,
//                   child: ElevatedButton(
//                     onPressed: registerStudent,
//                     style: ElevatedButton.styleFrom(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                     ),
//                     child: const Text(
//                       "Register Student",
//                       style: TextStyle(fontSize: 18),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     idNumberController.dispose();
//     courseController.dispose();
//     super.dispose();
//   }
// }
