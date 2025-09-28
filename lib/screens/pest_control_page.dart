import 'package:flutter/material.dart';
import 'package:snake_gourd/services/tts_service.dart';
import 'package:snake_gourd/widgets/info_card.dart';

// PestControlPage-কে একটি StatefulWidget-এ রূপান্তর করা হয়েছে
class PestControlPage extends StatefulWidget {
  const PestControlPage({super.key});

  @override
  State<PestControlPage> createState() => _PestControlPageState();
}

class _PestControlPageState extends State<PestControlPage> {
  // পেজের সব লেখা একটি স্ট্রিং-এ একত্রিত করা হয়েছে
  final String _combinedText =
      'পোকামাকড় ও দমন। চিচিঙ্গার সাধারণ পোকামাকড় ও দমন ব্যবস্থা। চিচিঙ্গা চাষে বিভিন্ন ধরণের পোকার আক্রমণ হতে পারে। সঠিক সময়ে পোকা শনাক্ত করে কার্যকর ব্যবস্থা গ্রহণ করলে ফলন অনেকাংশে বাড়ানো সম্ভব। মাছিপোকা। ক্ষতির লক্ষণ: পূর্ণাঙ্গ মাছিপোকা কচি ফলের গায়ে ছিদ্র করে ডিম পাড়ে। ডিম ফুটে কীড়া বের হয়ে ফলের নরম অংশ খেয়ে নষ্ট করে ফেলে। আক্রান্ত ফল হলুদ হয়ে পচে যায় এবং অকালে ঝরে পড়ে। দমন ব্যবস্থা: পরিষ্কার-পরিচ্ছন্ন চাষাবাদ করতে হবে। আক্রান্ত ফল সংগ্রহ করে মাটিতে পুঁতে ফেলতে হবে। ফেরোমন ফাঁদ ব্যবহার করা সবচেয়ে কার্যকর ও পরিবেশবান্ধব একটি পদ্ধতি। জাবপোকা। ক্ষতির লক্ষণ: এই পোকা গাছের পাতা, কচি ডগা ও ফুলের রস চুষে খায়, যার ফলে পাতা কুঁকড়ে যায় এবং গাছ দুর্বল হয়ে পড়ে। এদের শরীর থেকে নিঃসৃত মধুরস পাতায় জমা হয়ে কালো ছত্রাক জন্মায়। দমন ব্যবস্থা: আক্রমণ কম হলে সাবান মিশ্রিত পানি স্প্রে করা যেতে পারে। জৈব কীটনাশক হিসেবে নিম তেল ব্যবহার করা যায়। আক্রমণের মাত্রা বেশি হলে বিশেষজ্ঞের পরামর্শে ইমিডাক্লোপ্রিড জাতীয় কীটনাশক প্রয়োগ করতে হবে। পামকিন বিটল। ক্ষতির লক্ষণ: পূর্ণবয়স্ক পোকা চারা গাছের পাতা ও ফুল ছিদ্র করে খায়, যা গাছের ব্যাপক ক্ষতি করে। কীড়া বা লার্ভা মাটির নিচে গাছের শিকড় খেয়ে গাছের বৃদ্ধি ব্যাহত করে। দমন ব্যবস্থা: সকালে বা বিকালে যখন পোকাগুলো অলস থাকে, তখন হাত দিয়ে ধরে মেরে ফেলতে হবে। জমিতে ছাই ছিটিয়ে দিলে পোকার আক্রমণ কমে। আক্রমণ شدید হলে সাইপারমেথ্রিন গ্রুপের কীটনাশক ব্যবহার করা যেতে পারে।';

  @override
  void dispose() {
    // পেজ থেকে বের হওয়ার সময় TTS বন্ধ করা
    TtsService.instance.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('পোকামাকড় ও দমন'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.brown.shade700, Colors.brown.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'চিচিঙ্গার সাধারণ পোকামাকড় ও দমন ব্যবস্থা',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.brown),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'চিচিঙ্গা চাষে বিভিন্ন ধরণের পোকার আক্রমণ হতে পারে। সঠিক সময়ে পোকা শনাক্ত করে কার্যকর ব্যবস্থা গ্রহণ করলে ফলন অনেকাংশে বাড়ানো সম্ভব।',
              style: TextStyle(fontSize: 16, height: 1.6),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 24),

            _buildPestCard(
              context,
              title: 'মাছিপোকা',
              symptoms: 'পূর্ণাঙ্গ মাছিপোকা কচি ফলের গায়ে ছিদ্র করে ডিম পাড়ে। ডিম ফুটে কীড়া বের হয়ে ফলের নরম অংশ খেয়ে নষ্ট করে ফেলে। আক্রান্ত ফল হলুদ হয়ে পচে যায় এবং অকালে ঝরে পড়ে।',
              control: 'পরিষ্কার-পরিচ্ছন্ন চাষাবাদ করতে হবে। আক্রান্ত ফল সংগ্রহ করে মাটিতে পুঁতে ফেলতে হবে। ফেরোমন ফাঁদ ব্যবহার করা সবচেয়ে কার্যকর ও পরিবেশবান্ধব একটি পদ্ধতি।',
              imagePath: 'assets/images/fruit_fly.jpg', // এই ছবিটি assets ফোল্ডারে যোগ করতে হবে
            ),

            _buildPestCard(
              context,
              title: 'জাবপোকা',
              symptoms: 'এই পোকা গাছের পাতা, কচি ডগা ও ফুলের রস চুষে খায়, যার ফলে পাতা কুঁকড়ে যায় এবং গাছ দুর্বল হয়ে পড়ে। এদের শরীর থেকে নিঃসৃত মধুরস পাতায় জমা হয়ে কালো ছত্রাক জন্মায়।',
              control: 'আক্রমণ কম হলে সাবান মিশ্রিত পানি স্প্রে করা যেতে পারে। জৈব কীটনাশক হিসেবে নিম তেল ব্যবহার করা যায়। আক্রমণের মাত্রা বেশি হলে বিশেষজ্ঞের পরামর্শে ইমিডাক্লোপ্রিড জাতীয় কীটনাশক প্রয়োগ করতে হবে।',
              imagePath: 'assets/images/aphids.jpg', // এই ছবিটি assets ফোল্ডারে যোগ করতে হবে
            ),

            _buildPestCard(
              context,
              title: 'পামকিন বিটল',
              symptoms: 'পূর্ণবয়স্ক পোকা চারা গাছের পাতা ও ফুল ছিদ্র করে খায়, যা গাছের ব্যাপক ক্ষতি করে। কীড়া বা লার্ভা মাটির নিচে গাছের শিকড় খেয়ে গাছের বৃদ্ধি ব্যাহত করে।',
              control: 'সকালে বা বিকালে যখন পোকাগুলো অলস থাকে, তখন হাত দিয়ে ধরে মেরে ফেলতে হবে। জমিতে ছাই ছিটিয়ে দিলে পোকার আক্রমণ কমে। আক্রমণ شدید হলে সাইপারমেথ্রিন গ্রুপের কীটনাশক ব্যবহার করা যেতে পারে।',
              imagePath: 'assets/images/pumpkin.jpg', // এই ছবিটি assets ফোল্ডারে যোগ করতে হবে
            ),
          ],
        ),
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

  // পোকামাকড় দেখানোর জন্য একটি কার্ড উইজেট
  Widget _buildPestCard(BuildContext context, {required String title, required String symptoms, required String control, String? imagePath}) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imagePath != null)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                imagePath,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox(height: 180, child: Center(child: Text('ছবি পাওয়া যায়নি'))),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  'ক্ষতির লক্ষণ:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
                ),
                const SizedBox(height: 4),
                Text(
                  symptoms,
                  style: const TextStyle(fontSize: 15, height: 1.5),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 12),
                const Text(
                  'দমন ব্যবস্থা:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                ),
                const SizedBox(height: 4),
                Text(
                  control,
                  style: const TextStyle(fontSize: 15, height: 1.5),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
