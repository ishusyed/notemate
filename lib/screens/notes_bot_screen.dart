import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../services/chat_service.dart';

class NotesBotScreen extends StatefulWidget {
  @override
  _NotesBotScreenState createState() => _NotesBotScreenState();
}

class _NotesBotScreenState extends State<NotesBotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;

  // 📨 Send message to chatbot
  void _sendMessage() async {
    final userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "text": userMessage});
      _isLoading = true;
      _controller.clear();
    });

    final response = await ChatService.sendNotesMessage(userMessage);

    setState(() {
      _messages.add({
        "role": "bot",
        "text": response["response"],
        "pdf_data": response["pdf_data"],
      });
      _isLoading = false;
    });
  }

  // 📂 Upload PDF file
  void _uploadPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      final response = await ChatService.uploadPDF(file);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response["message"] ?? "Upload Failed!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notes Bot")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg["role"] == "user";

                return Column(
                  crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    // 💬 Display Text Message
                    Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.blue[100] : Colors.green[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(msg["text"]),
                    ),
                    // 📄 Display PDF Viewer (if available)
                    if (msg["pdf_data"] != null)
                      Container(
                        height: 300,
                        child: SfPdfViewer.memory(
                          base64Decode(msg["pdf_data"]),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          if (_isLoading) LinearProgressIndicator(),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                // 📂 Upload Button
                IconButton(
                  icon: Icon(Icons.upload_file, color: Colors.blue),
                  onPressed: _uploadPDF,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Ask for a PDF...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
