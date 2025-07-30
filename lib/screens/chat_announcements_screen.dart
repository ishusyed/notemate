import 'package:flutter/material.dart';

class ChatAnnouncementsScreen extends StatelessWidget {
  final List<Map<String, String>> announcements = [
    {
      "title": "Exam Schedule Released",
      "message": "The mid-term exam schedule has been released. Check your portal for details.",
      "time": "10:00 AM"
    },
    {
      "title": "Holiday Notice",
      "message": "College will remain closed on Friday due to a public holiday.",
      "time": "Yesterday"
    },
    {
      "title": "New Lecture Notes Uploaded",
      "message": "Lecture notes for Data Structures are now available.",
      "time": "2 days ago"
    },
    {
      "title": "Workshop Announcement",
      "message": "A workshop on AI and ML will be conducted this Saturday at 2 PM.",
      "time": "4 days ago"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Announcements", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: announcements.length,
        itemBuilder: (context, index) {
          final announcement = announcements[index];
          return Card(
            color: Colors.grey[900],
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(
                announcement["title"]!,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              subtitle: Text(
                announcement["message"]!,
                style: TextStyle(color: Colors.white70),
              ),
              trailing: Text(
                announcement["time"]!,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        },
      ),
    );
  }
}
