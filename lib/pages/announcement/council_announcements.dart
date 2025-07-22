import 'package:flutter/material.dart';

class CouncilAnnouncements extends StatefulWidget {
  const CouncilAnnouncements({super.key});

  @override
  State<CouncilAnnouncements> createState() => _CouncilAnnouncementsState();
}

class _CouncilAnnouncementsState extends State<CouncilAnnouncements> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Announcements"),
      ),
    );
  }
}
