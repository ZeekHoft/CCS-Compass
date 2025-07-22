import 'package:ccs_compass/pages/announcement/council_announcements.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final titleEventController = TextEditingController();
  final announcedByController = TextEditingController();
  final dateEventController = TextEditingController();
  final contextEventController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void navigateToAnnouncement() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const CouncilAnnouncements()));
  }

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
        "dater": titleEventController.text.trim(),
        "announcer": announcedByController.text.trim(),
        "event": dateEventController.text.trim(),
        "context": contextEventController.text.trim()
      });
      if (mounted) {
        Navigator.of(context).pop();
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Announcement made successfully!')),
      );
      navigateToAnnouncement();
    } catch (e) {
      errorMessage("Failed to make announcement: $e");
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
      body: Padding(
        padding: const EdgeInsetsGeometry.all(20.0),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      TextField(
                        controller: dateEventController,
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
                              lastDate: DateTime(2100));

                          if (pickeddate != null) {
                            setState(() {
                              dateEventController.text =
                                  DateFormat('yyyy-MM-dd').format(pickeddate);
                            });
                          }
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
                            hintText: "Enter full name"),
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
                            hintText: "Name of event this day"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter event name";
                          }
                          if (value.length < 5) {
                            return "Too short for event name, , need atlest 5 characters";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        height: 250,
                        child: TextFormField(
                          textAlignVertical: TextAlignVertical.top,
                          controller: contextEventController,
                          maxLines: null,
                          expands: true,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text(
                                "Event Context",
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              hintText: "Information about this event"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter event context";
                            }
                            if (value.length < 10) {
                              return "Too short for event context, need atlest 10 characters";
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
                                onPressed: (makeAnnouncement),
                                child: const Text("Add Announcement"))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )),
      ),
    ));
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
