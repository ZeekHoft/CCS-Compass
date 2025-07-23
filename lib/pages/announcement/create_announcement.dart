import 'package:ccs_compass/pages/home/home_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateAnnouncement extends StatefulWidget {
  const CreateAnnouncement({super.key});

  @override
  State<CreateAnnouncement> createState() => _CreateAnnouncementState();
}

class _CreateAnnouncementState extends State<CreateAnnouncement> {
  final titleEventController = TextEditingController();
  final announcedByController = TextEditingController();
  final dateEventController = TextEditingController();
  final contextEventController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Corrected function to navigate to HomeLayout and replace the current route
  void navigateToHomeLayout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const HomeLayout(),
      ),
    );
  }

  // Function to handle making an announcement
  void makeAnnouncement() async {
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
      await FirebaseFirestore.instance.collection("ccs_announcements").add({
        "dater": dateEventController.text.trim(), // Date of event
        "announcer": announcedByController.text.trim(),
        "event": titleEventController.text.trim(), // Title of event
        "context": contextEventController.text.trim(),
      });
      if (mounted) {
        Navigator.of(context).pop(); // Dismiss the loading indicator
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Announcement made successfully!')),
      );
      navigateToHomeLayout(); // Navigate to home after successful announcement
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Dismiss the loading indicator on error
      }
      errorMessage("Failed to make announcement: $e");
    }
  }

  // Function to show an error message dialog
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
    return PopScope(
      // This handles the system back button or implicit back arrow
      canPop: false, // Prevent the default pop behavior
      onPopInvoked: (didPop) {
        if (didPop) {
          return; // If the system already handled the pop, do nothing
        }
        navigateToHomeLayout(); // Navigate to HomeLayout when back is pressed
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Create Announcement"),
            actions: [
              // This button now consistently navigates back to HomeLayout
              ElevatedButton(
                onPressed: navigateToHomeLayout,
                child: const Icon(Icons.exit_to_app),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(
                20.0), // Use EdgeInsets.all for consistency
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        TextFormField(
                          // Changed TextField to TextFormField for validation
                          controller: dateEventController,
                          readOnly:
                              true, // Make it read-only so date picker is the only input
                          decoration: const InputDecoration(
                            icon: Icon(Icons.calendar_month_rounded),
                            border: OutlineInputBorder(),
                            label: Text("Select Date"),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          onTap: () async {
                            DateTime? pickeddate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2025),
                              lastDate: DateTime(2100),
                            );

                            if (pickeddate != null) {
                              setState(() {
                                dateEventController.text =
                                    DateFormat('yyyy-MM-dd').format(pickeddate);
                              });
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please select a date";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          controller: announcedByController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text("Announcer Name"),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: "Enter full name",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter announcer name";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          controller: titleEventController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text("Event Title"),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: "Name of event this day",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter event name";
                            }
                            if (value.length < 5) {
                              return "Too short for event name, need at least 5 characters";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Expanded(
                          // Use Expanded here to make the TextFormField take available space
                          child: TextFormField(
                            textAlignVertical: TextAlignVertical.top,
                            controller: contextEventController,
                            maxLines: null, // Allows multiple lines
                            expands:
                                true, // Allows the field to expand vertically
                            keyboardType: TextInputType.multiline,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text("Event Context"),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              hintText: "Information about this event",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter event context";
                              }
                              if (value.length < 10) {
                                return "Too short for event context, need at least 10 characters";
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed:
                                    makeAnnouncement, // Call the makeAnnouncement function
                                child: const Text("Add Announcement"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    dateEventController.dispose();
    announcedByController.dispose();
    titleEventController.dispose();
    contextEventController.dispose();
    super.dispose();
  }
}
