import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class ChatService {
  // 🔹 Replace with your FastAPI backend IP
  static const String _baseUrl = "http://192.168.29.2:8000";

  // --------------------------
  // 🤖 AI Chatbot (Streaming)
  // --------------------------
  static Future<Stream<String>> sendAIMessage(String message) async {
    try {
      final request = http.Request("POST", Uri.parse("$_baseUrl/ai-chat"));
      request.headers["Content-Type"] = "application/json";
      request.body = jsonEncode({"prompt": message});

      final response = await http.Client().send(request);

      if (response.statusCode == 200) {
        return response.stream
            .transform(utf8.decoder) // Decode bytes to text
            .transform(const LineSplitter()); // Split lines properly
      } else {
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Connection failed: $e");
    }
  }

  // --------------------------
  // 📂 Notes Chat (PDF Retrieval)
  // --------------------------
  static Future<Map<String, dynamic>> sendNotesMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/notes-chat"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"prompt": message}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          "response": data["response"],
          "pdf_data": data["pdf_data"], // Base64 encoded PDF data
          "pdf_name": data["pdf_name"], // Filename
        };
      } else {
        return {"response": "Error: ${response.statusCode}", "pdf_data": null, "pdf_name": null};
      }
    } catch (e) {
      return {"response": "Connection failed: $e", "pdf_data": null, "pdf_name": null};
    }
  }


  // --------------------------
  // 📤 Upload PDF to Server
  // --------------------------
  static Future<Map<String, dynamic>> uploadPDF(File pdfFile) async {
    try {
      var request = http.MultipartRequest("POST", Uri.parse("$_baseUrl/upload_pdf"));
      request.files.add(await http.MultipartFile.fromPath("file", pdfFile.path, filename: basename(pdfFile.path)));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"error": "Failed to upload PDF"};
      }
    } catch (e) {
      return {"error": "Connection failed: $e"};
    }
  }
}
