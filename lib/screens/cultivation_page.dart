import 'package:flutter/material.dart';
import 'package:snake_gourd/services/tts_service.dart';
import 'package:snake_gourd/widgets/info_card.dart';

class CultivationPage extends StatelessWidget {
  const CultivationPage({super.key});

  // পৃষ্ঠার ডেটাগুলোকে একটি লিস্টে নিয়ে আসা হয়েছে
  final List<Map<String, String>> _cultivationData = const [
    {
      'title': 'জমি তৈরি ও বীজ বপন',
      'imagePath': 'assets/images/cultivate.png',
      'description': 'চিচিঙ্গা চাষের জন্য দোআঁশ বা বেলে দোআঁশ মাটি সবচেয়ে উপযোগী। জমিতে ৪-৫টি চাষ ও মই দিয়ে মাটি ঝরঝরে করে নিতে হবে। এরপর ২ মিটার চওড়া বেড তৈরি করে মাদায় বীজ বপন করতে হয়। প্রতি মাদায় ২-৩টি বীজ বপন করা ভালো। জাত ও আবহাওয়া ভেদে চিচিঙ্গার জীবনকাল পাঁচ-ছয় মাস (কমবেশী হতে পারে)। বাংলাদেশে চিচিঙ্গা প্রধানত খরিফ মৌসুমেই হয়ে থাকে। ফেব্রুয়ারি থেকে শুরু করে জুন পর্যন্ত চিচিঙ্গার বীজ বপন করা যায়। চিচিঙ্গা চাষের জন্য হেক্টর প্রতি ৪-৫ কেজি (১৬-২০ গ্রাম/শতাংশ) বীজের প্রয়োজন হয়।',
    },
    {
      'title': 'সারের পরিমাণ ও প্রয়োগ',
      'description': '''চিচিঙ্গার জমিতে নিম্নোক্ত হারে সার (শতাংশ প্রতি) প্রয়োগ করা যেতে পারে:
• ৮০ কেজি গোবর
• ৭০০ গ্রাম টিএসপি
• ৬০০ গ্রাম এমওপি
• ৪০০ গ্রাম জিপসাম
• ৫০ গ্রাম দস্তাসার
• ৪০ গ্রাম বোরাক্স এবং ৫০ গ্রাম ম্যাগনেসিয়াম অক্সাইড মাটির সঙ্গে মিশিয়ে দিতে হবে

চিচিঙ্গা চাষাবাদের জমি তৈরির সময় অর্ধেক গোবর মিশিয়ে চাষ দিতে হবে। বাকি অর্ধেক সার বীজ বোনা বা চারা লাগানোর ১০ দিন আগে মাদার মাটিতে মিশিয়ে দিতে হবে।''',
    },
    {
      'title': 'সেচ ও পরিচর্যা',
      'description': 'শুকনো মৌসুমে জমিতে প্রয়োজন অনুযায়ী সেচ দিতে হবে। প্রতিটি সেচের পর মাটির উপরিভাগ আলগা করে দিতে হবে। জমির আগাছা নিয়মিত পরিষ্কার করতে হবে এবং গাছের গোড়ায় মাটি তুলে দিতে হবে।',
    },
    {
      'title': 'মাচা তৈরি',
      'description': '''বাউনী দেয়া চিচিঙ্গার চাষের প্রধান পরিচর্যা। মাচায় চাষ করলে চিচিঙ্গার ফলন বেশী ও ফলের গুনগত মানও অনেক ভালো হয়।
• চারা ২০-২৫ সেমি উঁচু হতেই ১.০-১.৫ মিটার উঁচু মাচা তৈরি করতে হবে।''',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // TtsService এর ইনস্ট্যান্স নিন
    final ttsService = TtsService.instance;

    // পৃষ্ঠার সকল কার্ডের লেখা একসাথে যোগ করুন
    final fullPageText = _cultivationData
        .map((data) => "${data['title']}. ${data['description']}")
        .join('\n\n');

    return Scaffold(
      appBar: AppBar(
        title: const Text('চাষাবাদ পদ্ধতি'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _cultivationData.length,
        itemBuilder: (context, index) {
          final cardData = _cultivationData[index];
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

