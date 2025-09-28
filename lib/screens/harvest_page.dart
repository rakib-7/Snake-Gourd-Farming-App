import 'package:flutter/material.dart';
import 'package:snake_gourd/services/tts_service.dart';
import 'package:snake_gourd/widgets/info_card.dart';

// HarvestPage-কে একটি StatefulWidget-এ রূপান্তর করা হয়েছে
class HarvestPage extends StatefulWidget {
  const HarvestPage({super.key});

  @override
  State<HarvestPage> createState() => _HarvestPageState();
}

class _HarvestPageState extends State<HarvestPage> {
  // পেজের সব লেখা একটি স্ট্রিং-এ একত্রিত করা হয়েছে
  final String _combinedText =
      'ফসল সংগ্রহ। সংগ্রহের সঠিক সময়। বীজ বপনের প্রায় ৬০-৭০ দিনের মধ্যে চিচিঙ্গা ফল সংগ্রহের উপযোগী হয়। ফল কচি অবস্থায় সংগ্রহ করা উচিত, কারণ বেশি পরিপক্ক হলে এটি শক্ত ও আঁশযুক্ত হয়ে যায়। সংগ্রহ পদ্ধতি। ধারালো ছুরি বা ব্লেড দিয়ে ফলের বোঁটা কেটে সংগ্রহ করতে হবে। টানাটানি করে ছিঁড়লে গাছের ক্ষতি হতে পারে। সপ্তাহে ২-৩ বার ফল সংগ্রহ করা যায়। ফলন। জাত এবং সঠিক পরিচর্যার উপর নির্ভর করে প্রতি হেক্টরে প্রায় ২৫-৩৫ টন পর্যন্ত ফলন হতে পারে।';

  @override
  void dispose() {
    // পেজ থেকে বের হওয়ার সময় TTS বন্ধ করা
    TtsService.instance.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ফসল সংগ্রহ')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          InfoCard(
            title: 'সংগ্রহের সঠিক সময়',
            imagePath: 'assets/images/collect.png',
            description: 'বীজ বপনের প্রায় ৬০-৭০ দিনের মধ্যে চিচিঙ্গা ফল সংগ্রহের উপযোগী হয়। ফল কচি অবস্থায় সংগ্রহ করা উচিত, কারণ বেশি পরিপক্ক হলে এটি শক্ত ও আঁশযুক্ত হয়ে যায়।',
          ),
          InfoCard(
            title: 'সংগ্রহ পদ্ধতি',
            description: 'ধারালো ছুরি বা ব্লেড দিয়ে ফলের বোঁটা কেটে সংগ্রহ করতে হবে। টানাটানি করে ছিঁড়লে গাছের ক্ষতি হতে পারে। সপ্তাহে ২-৩ বার ফল সংগ্রহ করা যায়।',
          ),
          InfoCard(
            title: 'ফলন',
            description: 'জাত এবং সঠিক পরিচর্যার উপর নির্ভর করে প্রতি হেক্টরে প্রায় ২৫-৩৫ টন পর্যন্ত ফলন হতে পারে।',
          ),
        ],
      ),
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: TtsService.instance.isSpeaking,
        builder: (context, isSpeaking, child) {
          return FloatingActionButton.extended(
            onPressed: () {
              TtsService.instance.toggleSpeak(_combinedText);
            },
            label: Text(isSpeaking ? 'থামুন' : 'শুনুন'),
            icon: Icon(isSpeaking ? Icons.stop_rounded : Icons.volume_up_rounded),
          );
        },
      ),
    );
  }
}
