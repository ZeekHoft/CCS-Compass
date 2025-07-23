import 'package:ccs_compass/pages/announcement/create_announcement.dart';
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
      body: Column(
        children: [
          Center(
            child: const Text("Announcements"),
          ),
          Row(
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreateAnnouncement()));
                  },
                  child: const Icon(Icons.add_circle_rounded))
            ],
          )
        ],
      ),
    );
  }
}
