import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class PullStudentData extends ChangeNotifier {
  String _email = "Loading...";
  String _idnumber = "Loading...";
  String _coruse = "Loading...";
  String _name = "Loading...";
  bool _isLoading = true;

  String get email => _email;
  String get idnumber => _idnumber;
  String get course => _coruse;
  String get name => _name;
  bool get isLoading => _isLoading;

  Future<void> fetchStudentData() async {
    _isLoading = true;

    final currentStudent = FirebaseAuth.instance.currentUser;

    if (currentStudent == null) {
      _email = 'Not logged in';
      _idnumber = 'No ID number found';
      _coruse = 'No course found';
      _name = 'No name found';
      _isLoading = false;
      notifyListeners(); // listen for any changes that might occur incase currentStudent isn't null
      return;
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("ccs_students")
          .where("email", isEqualTo: currentStudent!.email)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final studentData = snapshot.docs.first.data();
        _email = studentData["email"] ?? "N/A";
        _idnumber = studentData["idnumber"] ?? "N/A";
        _coruse = studentData["course"] ?? "N/A";
        _name = studentData["name"] ?? "N/A";
      }
    } catch (e) {
      if (kDebugMode) {
        print("An error occured while retreiving student data: $e");
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
