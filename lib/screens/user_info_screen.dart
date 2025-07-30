import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserInfoScreen extends StatelessWidget {
  final String email;
  final String mobile;
  final String rollNumber;

  const UserInfoScreen({
    required this.email,
    required this.mobile,
    required this.rollNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("User Info", style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoTile("Email", email),
            _buildInfoTile("Mobile", mobile),
            _buildInfoTile("Roll Number", rollNumber),
            Spacer(),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Logout',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return ListTile(
      leading: Icon(Icons.info, color: Colors.purpleAccent),
      title: Text(
        label,
        style: TextStyle(color: Colors.white70, fontSize: 14),
      ),
      subtitle: Text(
        value,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
