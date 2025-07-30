import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class UploadNoteScreen extends StatefulWidget {
  final String teacherId;

  UploadNoteScreen({required this.teacherId});

  @override
  _UploadNoteScreenState createState() => _UploadNoteScreenState();
}

class _UploadNoteScreenState extends State<UploadNoteScreen> {
  File? _selectedFile;
  bool _isUploading = false;
  final TextEditingController _titleController = TextEditingController();

  // 📂 Pick a PDF file from the file manager
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'], // Allow only PDF files
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  // 🔼 Upload PDF to FastAPI server
  Future<void> _uploadPDF() async {
    if (_selectedFile == null || _titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a PDF and enter a title first")),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.29.2:8000/upload_pdf'), // ✅ Removed "?title=..."
    );

    request.fields['title'] = _titleController.text; // ✅ Send title as form-data
    request.files.add(
      await http.MultipartFile.fromPath('file', _selectedFile!.path),
    );

    print("Sending request to server...");

    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        print("✅ Upload successful!");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("File uploaded successfully!")),
        );
      } else {
        print("❌ Upload failed: ${response.statusCode}");
        print("Response: $responseBody"); // Debugging
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Upload failed: ${response.reasonPhrase}")),
        );
      }
    } catch (e) {
      print("⚠️ Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Network error: Could not reach the server!")),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Notes"),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Enter Title & Select a PDF to Upload",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // 📌 Title Input Field
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Enter Note Title",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: _pickFile,
              icon: Icon(Icons.file_upload),
              label: Text("Pick PDF from Device"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purpleAccent,
              ),
            ),

            SizedBox(height: 20),

            _selectedFile != null
                ? Text("Selected: ${_selectedFile!.path.split('/').last}")
                : Text("No file selected", style: TextStyle(color: Colors.red)),

            Spacer(),

            ElevatedButton(
              onPressed: _isUploading ? null : _uploadPDF,
              child: _isUploading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Upload PDF"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
