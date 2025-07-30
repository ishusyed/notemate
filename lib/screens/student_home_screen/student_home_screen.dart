import 'package:flutter/material.dart';
import '../services/view_notes_screen.dart';
import '../services/attendance_screen.dart';
import '../services/ai_chatbot_screen.dart';
import '../services/notes_bot_screen.dart';
import '../services/user_info_screen.dart';
import '../services/chat_announcements_screen.dart';

class StudentHomeScreen extends StatelessWidget {
  final String email;
  final String mobile;
  final String rollNumber;

  StudentHomeScreen({required this.email, required this.mobile, required this.rollNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            _buildHeader(context),
            const SizedBox(height: 20),
            _buildGreetingCard(),
            const SizedBox(height: 20),
            _buildFeatures(context),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Home", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
        IconButton(
          icon: const Icon(Icons.account_circle, color: Colors.white, size: 32),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => UserInfoScreen(email: email, mobile: mobile, rollNumber: rollNumber),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildGreetingCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.purpleAccent.withOpacity(0.6), blurRadius: 20)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              CircleAvatar(backgroundImage: AssetImage('assets/profile.png')),
              SizedBox(width: 10),
              Text("Hi, Student!", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              hintText: "Search for Materials",
              hintStyle: TextStyle(color: Colors.white70),
              prefixIcon: Icon(Icons.search, color: Colors.purpleAccent),
              filled: true,
              fillColor: Colors.black,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.purpleAccent, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatures(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Explore Features", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildFeatureTile(context, "Notes", "assets/notes.png", ViewNotesScreen()),
            _buildFeatureTile(context, "Attendance", "assets/attendance.png", AttendanceScreen()),
            _buildFeatureTile(context, "AI Chatbot", "assets/chatbot.png", AIChatbotScreen()),
            _buildFeatureTile(context, "Notes Bot", "assets/pdf_bot.jpg", NotesBotScreen()),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureTile(BuildContext context, String title, String imagePath, Widget screen) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.purpleAccent.withOpacity(0.8), blurRadius: 15)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 80, width: 80, fit: BoxFit.cover),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.purpleAccent,
      unselectedItemColor: Colors.white70,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        if (index == 2) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => ChatAnnouncementsScreen()));
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home, size: 28), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.sticky_note_2, size: 28), label: "Notes"),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat, size: 28),
          label: "Chats",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.account_circle, size: 28), label: "Account"),
      ],
    );
  }
}
