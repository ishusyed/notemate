import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../services/upload_note_screen.dart';
import 'upload_note_screen.dart';
import 'view_notes_screen.dart';
import 'attendance_screen.dart';
import 'ai_chatbot_screen.dart';
import 'notes_bot_screen.dart';
import 'chat_announcements_screen.dart';
import 'user_info_screen.dart'; // Add this

class HomeScreen extends StatelessWidget {
  final String email = "user@example.com";
  final String mobile = "9876543210";
  final String rollNumber = "21A91A1234";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Home",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.account_circle, color: Colors.white, size: 32),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserInfoScreen(
                            email: email,
                            mobile: mobile,
                            rollNumber: rollNumber,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Greeting Card
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purpleAccent.withOpacity(0.6),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage('assets/profile.png'),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Hi, User!!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Search for Materials",
                        hintStyle: TextStyle(color: Colors.white70),
                        prefixIcon: Icon(Icons.search, color: Colors.purpleAccent),
                        filled: true,
                        fillColor: Colors.black,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: Colors.purpleAccent,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              Text(
                "Explore Features",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _buildFeatureTile(context, "Notes", "assets/notes.png", ViewNotesScreen()),
                  _buildFeatureTile(context, "Attendance", "assets/attendance.png", AttendanceScreen()),
                  _buildFeatureTile(context, "AI Chatbot", "assets/chatbot.png", AIChatbotScreen()),
                  _buildFeatureTile(context, "Notes Bot", "assets/pdf_bot.jpg", NotesBotScreen()),
                  _buildFeatureTile(context, "Upload Notes", "assets/upload_notes.png", UploadNoteScreen(teacherId: "some_teacher_id")),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.purpleAccent,
        unselectedItemColor: Colors.white70,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatAnnouncementsScreen()),
            );
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 28), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.sticky_note_2, size: 28), label: "Notes"),
          BottomNavigationBarItem(
            icon: Badge(
              label: Text("2"),
              child: Icon(Icons.chat, size: 28),
            ),
            label: "Chats",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle, size: 28), label: "Account"),
        ],
      ),
    );
  }

  Widget _buildFeatureTile(BuildContext context, String title, String imagePath, Widget screen) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => screen)),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.purpleAccent.withOpacity(0.8),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(imagePath, height: 80, width: 80, fit: BoxFit.cover),
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
