import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class PullStudentData extends ChangeNotifier {
  String _email = "Loading...";
  String _idnumber = "Loading...";
  String _course = "Loading...";
  String _name = "Loading...";
  bool _isLoading = true;

  // Subscription to listen for Firebase Auth state changes
  late final StreamSubscription<User?> _authStateChangesSubscription;

  String get email => _email;
  String get idnumber => _idnumber;
  String get course => _course;
  String get name => _name;
  bool get isLoading => _isLoading;

  // Constructor: Set up the auth state listener
  PullStudentData() {
    _authStateChangesSubscription =
        FirebaseAuth.instance.authStateChanges().listen((user) {
      // When auth state changes (user logs in or out), re-fetch data
      if (user != null) {
        // User is logged in, fetch their data
        fetchStudentData();
      } else {
        // User is logged out, clear the data
        clearStudentData();
      }
    });
    // Also call fetchStudentData initially in case a user is already logged in on app start
    // This handles the initial state without waiting for the first authStateChanges event.
    fetchStudentData();
  }

  Future<void> fetchStudentData() async {
    _isLoading = true;
    notifyListeners(); // Notify listeners that loading has started

    final currentStudent = FirebaseAuth.instance.currentUser;

    if (currentStudent == null) {
      _email = 'Not logged in';
      _idnumber = 'No ID number found';
      _course = 'No course found';
      _name = 'No name found';
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("ccs_students")
          .where("uid",
              isEqualTo: currentStudent.uid) // Use UID for more reliable lookup
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final studentData = snapshot.docs.first.data();
        _email = studentData["email"] ?? "N/A";
        _idnumber = studentData["idnumber"] ?? "N/A";
        _course = studentData["course"] ?? "N/A";
        _name = studentData["name"] ?? "N/A";
      } else {
        // Handle case where user is authenticated but no student data found in Firestore
        _email = currentStudent.email ?? 'N/A (No data)';
        _idnumber = 'No ID number found';
        _course = 'No course found';
        _name = 'No name found';
        if (kDebugMode) {
          print("No student data found for UID: ${currentStudent.uid}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("An error occurred while retrieving student data: $e");
      }
      _email = 'Error loading data';
      _idnumber = 'Error loading data';
      _course = 'Error loading data';
      _name = 'Error loading data';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearStudentData() {
    _email = "Not logged in";
    _idnumber = "No ID number found";
    _course = "No course found";
    _name = "No name found";
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _authStateChangesSubscription.cancel(); // Cancel the stream subscription
    super.dispose();
  }
}
