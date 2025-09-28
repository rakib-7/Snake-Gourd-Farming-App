import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChashiBotPage extends StatefulWidget {
  const ChashiBotPage({super.key});
  @override
  State<ChashiBotPage> createState() => _ChashiBotPageState();
}

class _ChashiBotPageState extends State<ChashiBotPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  // ⚠️ গুরুত্বপূর্ণ: এখানে আপনার আসল Gemini API Key বসান
  final String apiKey = "AIzaSyDxfqNegZkn5j6JSqJR40A7rGYhMxPjwxk";

  Future<void> _sendMessage(String message) async {
    if (apiKey == "YOUR_GEMINI_API_KEY") {
      setState(() {
        _messages.insert(0, {"role": "user", "text": message});
        _messages.insert(0, {"role": "bot", "text": "দুঃখিত, API Key সেট করা হয়নি।"});
      });
      return;
    }
    setState(() {
      _messages.insert(0, {"role": "user", "text": message});
      _isLoading = true;
    });

    final url = Uri.parse("https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey");
    final history = _messages.reversed.map((msg) {
      return {
        "role": msg["role"] == "bot" ? "model" : "user",
        "parts": [{"text": msg["text"] ?? ""}]
      };
    }).toList();

    try {
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "contents": history // এখানে শুধু বর্তমান বার্তা না পাঠিয়ে সম্পূর্ণ ইতিহাস পাঠানো হচ্ছে
          }));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data["candidates"]?[0]?["content"]?["parts"]?[0]?["text"] ?? "কোনো উত্তর পাওয়া যায়নি।";
        setState(() => _messages.insert(0, {"role": "bot", "text": reply}));
      } else {
        setState(() => _messages.insert(0, {"role": "bot", "text": "ত্রুটি হয়েছে: ${response.body}"}));
      }
    } catch (e) {
      setState(() => _messages.insert(0, {"role": "bot", "text": "ত্রুটি হয়েছে, ইন্টারনেট সংযোগ পরীক্ষা করুন।"}));
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("চাষি বট"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal.shade700, Colors.teal.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg["role"] == "user";
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.green[200] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(msg["text"] ?? "", style: const TextStyle(fontSize: 16, color: Colors.black87)),
                  ),
                );
              },
            ),
          ),
          if (_isLoading) const LinearProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(hintText: "আপনার প্রশ্ন লিখুন...", border: OutlineInputBorder()),
                    onSubmitted: (text) => _handleSend(),
                  )),
              const SizedBox(width: 8),
              IconButton.filled(
                icon: const Icon(Icons.send),
                onPressed: _handleSend,
                style: IconButton.styleFrom(backgroundColor: Colors.green),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      _controller.clear();
      _sendMessage(text);
    }
  }
}

