import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../models/menu_item.dart';
import '../data/app_data.dart'; // Assuming you have this file for content

class DetailPage extends StatefulWidget {
  final MenuItem item;
  const DetailPage({super.key, required this.item});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final FlutterTts flutterTts = FlutterTts();
  bool _isSpeaking = false;
  late final String _content;

  @override
  void initState() {
    super.initState();
    // This assumes you have an AppData class with a static getContent method
    // If not, you'll need to pass the content directly or fetch it differently.
    _content = AppData.getContent(widget.item.title);
    _initializeTts();
  }

  Future<void> _initializeTts() async {
    await flutterTts.setLanguage("bn-BD");
    flutterTts.setCompletionHandler(() => setState(() => _isSpeaking = false));
    flutterTts.setErrorHandler((_) => setState(() => _isSpeaking = false));
  }

  Future<void> _toggleSpeak() async {
    if (_isSpeaking) {
      await flutterTts.stop();
      setState(() => _isSpeaking = false);
    } else {
      if (_content.isNotEmpty) {
        var result = await flutterTts.speak(_content);
        if (result == 1) setState(() => _isSpeaking = true);
      }
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Provide a default color if the item's color is null
    final itemColor = widget.item.color ?? Theme.of(context).primaryColor;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(widget.item.title, style: const TextStyle(fontSize: 18)),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [itemColor, itemColor.withOpacity(0.7)], // Use the safe color
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(widget.item.icon, size: 80, color: Colors.white.withOpacity(0.8)),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                _content,
                textAlign: TextAlign.justify,
                style: const TextStyle(fontSize: 18, height: 1.8, color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _toggleSpeak,
        label: Text(_isSpeaking ? 'থামুন' : 'শুনুন', style: const TextStyle(fontWeight: FontWeight.bold)),
        icon: Icon(_isSpeaking ? Icons.stop_rounded : Icons.volume_up_rounded),
        backgroundColor: _isSpeaking ? Colors.red.shade400 : Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }
}



