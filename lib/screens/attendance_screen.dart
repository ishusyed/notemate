import 'package:flutter/material.dart';

class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final TextEditingController rollNumberController = TextEditingController();

  // Dummy Attendance Data (Replace this with backend data when ready)
  final Map<String, Map<String, int>> attendanceData = {
    "12345": {"present": 18, "absent": 2},
    "67890": {"present": 15, "absent": 5},
    "11223": {"present": 20, "absent": 0},
  };

  Map<String, int>? studentAttendance;
  double? attendancePercentage;

  void fetchAttendance() {
    String rollNumber = rollNumberController.text.trim();
    if (attendanceData.containsKey(rollNumber)) {
      setState(() {
        studentAttendance = attendanceData[rollNumber]!;
        int totalDays = studentAttendance!["present"]! + studentAttendance!["absent"]!;
        attendancePercentage = (studentAttendance!["present"]! / totalDays) * 100;
      });
    } else {
      setState(() {
        studentAttendance = null;
        attendancePercentage = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No attendance record found for Roll Number: $rollNumber")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Attendance", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Enter Roll Number",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 20),

            // Roll Number Input
            TextField(
              controller: rollNumberController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Roll Number",
                labelStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.purpleAccent),
                ),
              ),
            ),
            SizedBox(height: 15),

            // Submit Button
            ElevatedButton(
              onPressed: fetchAttendance,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purpleAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text("Get Attendance", style: TextStyle(color: Colors.black)),
            ),

            SizedBox(height: 20),

            // Attendance Table
            if (studentAttendance != null)
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: Colors.purpleAccent, blurRadius: 10)],
                ),
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text("Attendance Summary",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    Divider(color: Colors.white70),
                    Table(
                      border: TableBorder.all(color: Colors.white),
                      columnWidths: {
                        0: FlexColumnWidth(2),
                        1: FlexColumnWidth(1),
                        2: FlexColumnWidth(1),
                        3: FlexColumnWidth(1),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(color: Colors.purpleAccent.withOpacity(0.3)),
                          children: [
                            _buildTableCell("Roll Number", bold: true),
                            _buildTableCell("Present", bold: true),
                            _buildTableCell("Absent", bold: true),
                            _buildTableCell("Percentage", bold: true),
                          ],
                        ),
                        TableRow(
                          children: [
                            _buildTableCell(rollNumberController.text),
                            _buildTableCell("${studentAttendance!['present']}"),
                            _buildTableCell("${studentAttendance!['absent']}"),
                            _buildTableCell("${attendancePercentage!.toStringAsFixed(2)}%"),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Helper function to create a table cell
  Widget _buildTableCell(String text, {bool bold = false}) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
