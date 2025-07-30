import 'package:flutter/material.dart';
import 'dart:async';
import '../services/chat_service.dart';

class AIChatbotScreen extends StatefulWidget {
  @override
  _AIChatbotScreenState createState() => _AIChatbotScreenState();
}

class _AIChatbotScreenState extends State<AIChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  String _thinkingText = "Thinking";
  int _dotCount = 0;
  String _selectedModel = "Mistral 7B"; // Default model selection

  // Available models (for future expansion)
  final List<String> _models = ["Mistral 7B", "Mistral Large 2", "Model Y"];

  void _startThinkingAnimation() {
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (!_isLoading) {
        timer.cancel();
        return;
      }
      setState(() {
        _dotCount = (_dotCount + 1) % 4;
        _thinkingText = "Thinking" + "." * _dotCount;
      });
    });
  }

  // Send message and receive streaming response
  void _sendMessage() async {
    final userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "text": userMessage});
      _messages.add({"role": "bot", "text": ""}); // Bot starts typing
      _isLoading = true;
      _controller.clear();
      _startThinkingAnimation();
    });

    try {
      final stream = await ChatService.sendAIMessage(userMessage);
      await for (var chunk in stream) {
        if (mounted) {
          setState(() {
            _messages.last["text"] = (_messages.last["text"] ?? "") + chunk;
          });
        }
      }
    } catch (e) {
      setState(() {
        _messages.last["text"] = "Error: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AI Chatbot")),
      body: Column(
        children: [
          // ✅ Greeting Message
          Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              "🤖 Feel free to ask!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey),
            ),
          ),

          // ✅ Chat Messages
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isLoading) {
                  return _buildThinkingIndicator();
                }
                final msg = _messages[index];
                final isUser = msg["role"] == "user";
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blueAccent.withOpacity(0.7) : Colors.green.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg["text"]!,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),

          // ✅ Input Section with Model Selection
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                // Model Selection Dropdown
                DropdownButton<String>(
                  value: _selectedModel,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedModel = newValue!;
                    });
                  },
                  items: _models.map<DropdownMenuItem<String>>((String model) {
                    return DropdownMenuItem<String>(
                      value: model,
                      child: Text(model),
                    );
                  }).toList(),
                ),
                SizedBox(width: 8),

                // Input Field
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Ask something...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                // Send Button
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThinkingIndicator() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            child: Icon(Icons.android, color: Colors.white),
            backgroundColor: Colors.green,
          ),
          SizedBox(width: 8),
          Text(
            _thinkingText,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
