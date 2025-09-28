import 'package:flutter/material.dart';
import 'package:snake_gourd/services/tts_service.dart';
import 'package:snake_gourd/widgets/info_card.dart';

class VarietiesPage extends StatelessWidget {
  const VarietiesPage({super.key});

  // পৃষ্ঠার ডেটাগুলোকে একটি লিস্টে নিয়ে আসা হয়েছে
  final List<Map<String, String>> _varietiesData = const [
    {
      'title': 'দেশি জাত',
      'imagePath': 'assets/images/varietis.jpg', // জাতের ছবি
      'description': 'এটি সবচেয়ে প্রচলিত জাত। ফল মাঝারি লম্বা, হালকা সবুজ রঙের এবং স্বাদে সুস্বাদু। এটি বাংলাদেশের আবহাওয়ায় খুব ভালোভাবে জন্মায়।',
    },
    {
      'title': 'বারি চিচিঙ্গা-১',
      'description': 'বাংলাদেশ কৃষি গবেষণা ইনস্টিটিউট (BARI) উদ্ভাবিত একটি উচ্চ ফলনশীল জাত। ফল লম্বা, সোজা এবং গাঢ় সবুজ রঙের হয়। এটি ভাইরাস রোগ প্রতিরোধী।',
    },
    {
      'title': 'মুনজেরিন ১ চিচিঙ্গা(হাইব্রিড)',
      'description': 'মুনজেরিন ১ চিচিংগা জাতটি ভাইরাসরোগ সহনশীল। ফলের ওজন হয়ে থাকে ২৫০ -৩০০ গ্রাম। ফসল সংগ্রহ ৫০ থেকে ৫৫ দিনে। এটি ছাদ বাগান বা বাড়ির আঙ্গিনায় লাগানোর উপযোগী জাত।',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // TtsService এর ইনস্ট্যান্স নিন
    final ttsService = TtsService.instance;

    // পৃষ্ঠার সকল কার্ডের লেখা একসাথে যোগ করুন
    final fullPageText = _varietiesData
        .map((data) => "${data['title']}. ${data['description']}")
        .join('\n\n');

    return Scaffold(
      appBar: AppBar(
        title: const Text('চিচিঙ্গার জাত'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _varietiesData.length,
        itemBuilder: (context, index) {
          final cardData = _varietiesData[index];
          // InfoCard উইজেট ব্যবহার করে ডেটা প্রদর্শন
          return InfoCard(
            title: cardData['title']!,
            imagePath: cardData['imagePath'],
            description: cardData['description']!,
          );
        },
      ),
      // পৃষ্ঠার নিচে একটি মাত্র TTS বাটন যোগ করা হয়েছে
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: ttsService.isSpeaking,
        builder: (context, isSpeaking, child) {
          return FloatingActionButton.extended(
            onPressed: () => ttsService.toggleSpeak(fullPageText),
            label: Text(isSpeaking ? 'থামুন' : 'শুনুন'),
            icon: Icon(isSpeaking ? Icons.stop_rounded : Icons.volume_up_rounded),
          );
        },
      ),
    );
  }
}

