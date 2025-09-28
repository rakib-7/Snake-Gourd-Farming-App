import 'package:flutter/material.dart';
import 'package:snake_gourd/services/tts_service.dart';
import 'package:snake_gourd/widgets/info_card.dart';

// PestDiseasePage-কে একটি StatefulWidget-এ রূপান্তর করা হয়েছে
class PestDiseasePage extends StatefulWidget {
  const PestDiseasePage({super.key});

  @override
  State<PestDiseasePage> createState() => _PestDiseasePageState();
}

class _PestDiseasePageState extends State<PestDiseasePage> {
  // পেজের সব লেখা একটি স্ট্রিং-এ একত্রিত করা হয়েছে
  final String _combinedText =
      'রোগবালাই ও প্রতিকার। চিচিঙ্গার সাধারণ রোগ ও প্রতিকার। চিচিঙ্গা গাছে বিভিন্ন ধরণের রোগবালাই ও পোকার আক্রমণ হতে পারে। সঠিক সময়ে এগুলোর লক্ষণ চিনে প্রতিকারমূলক ব্যবস্থা গ্রহণ করলে ফসলের বড় ধরণের ক্ষতি এড়ানো সম্ভব। পাউডারি মিলডিউ। লক্ষণ: এই রোগে পাতার উপর সাদা পাউডারের মতো আস্তরণ পড়ে। ধীরে ধীরে পুরো পাতায় ছড়িয়ে পড়ে এবং পাতা হলুদ হয়ে শুকিয়ে যায়, যার ফলে গাছের বৃদ্ধি ও ফলন মারাত্মকভাবে কমে যায়। প্রতিকার: আক্রান্ত পাতা ও ডগা সংগ্রহ করে পুড়িয়ে ফেলুন। সালফার জাতীয় ছত্রাকনাশক (যেমন: থিওভিট) অনুমোদিত মাত্রায় ১০ দিন পর পর ২-৩ বার স্প্রে করতে হবে। মোজাইক ভাইরাস। লক্ষণ: এই ভাইরাসের আক্রমণে পাতায় হলুদ ও সবুজ রঙের ছোপ ছোপ দাগ দেখা যায়। পাতা কুঁকড়ে যায়, আকারে ছোট হয় এবং গাছের বৃদ্ধি থেমে যায়। ফল আকারে বিকৃত হতে পারে। প্রতিকার: এর কোনো সরাসরি প্রতিকার নেই। এটি সাধারণত জাবপোকার মাধ্যমে ছড়ায়, তাই জাবপোকা দমন করা জরুরি। আক্রান্ত গাছ দেখামাত্র তুলে ফেলে পুড়িয়ে ফেলতে হবে। মাছিপোকা। লক্ষণ: পূর্ণাঙ্গ মাছিপোকা কচি ফলের গায়ে ছিদ্র করে ডিম পাড়ে। ডিম ফুটে কীড়া বের হয়ে ফলের নরম অংশ খেয়ে নষ্ট করে ফেলে। আক্রান্ত ফল হলুদ হয়ে পচে যায় এবং অকালে ঝরে পড়ে। প্রতিকার: পরিষ্কার-পরিচ্ছন্ন চাষাবাদ করতে হবে। আক্রান্ত ফল সংগ্রহ করে নষ্ট করে ফেলতে হবে। ফেরোমন ফাঁদ ব্যবহার করা সবচেয়ে কার্যকর ও পরিবেশবান্ধব একটি পদ্ধতি।';

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
        title: const Text('রোগবালাই ও প্রতিকার'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red.shade700, Colors.red.shade400],
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
            const Text(
              'চিচিঙ্গার সাধারণ রোগ ও প্রতিকার',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'চিচিঙ্গা গাছে বিভিন্ন ধরণের রোগবালাই ও পোকার আক্রমণ হতে পারে। সঠিক সময়ে এগুলোর লক্ষণ চিনে প্রতিকারমূলক ব্যবস্থা গ্রহণ করলে ফসলের বড় ধরণের ক্ষতি এড়ানো সম্ভব।',
              style: TextStyle(fontSize: 16, height: 1.6),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 24),

            _buildDiseaseCard(
              context,
              title: 'পাউডারি মিলডিউ',
              symptoms: 'এই রোগে পাতার উপর সাদা পাউডারের মতো আস্তরণ পড়ে। ধীরে ধীরে পুরো পাতায় ছড়িয়ে পড়ে এবং পাতা হলুদ হয়ে শুকিয়ে যায়, যার ফলে গাছের বৃদ্ধি ও ফলন মারাত্মকভাবে কমে যায়।',
              remedy: 'আক্রান্ত পাতা ও ডগা সংগ্রহ করে পুড়িয়ে ফেলুন। সালফার জাতীয় ছত্রাকনাশক (যেমন: থিওভিট) অনুমোদিত মাত্রায় ১০ দিন পর পর ২-৩ বার স্প্রে করতে হবে।',
              imagePath: 'assets/images/powdery_milview.jpg', // এই ছবিটি assets ফোল্ডারে যোগ করতে হবে
            ),

            _buildDiseaseCard(
              context,
              title: 'মোজাইক ভাইরাস',
              symptoms: 'এই ভাইরাসের আক্রমণে পাতায় হলুদ ও সবুজ রঙের ছোপ ছোপ দাগ দেখা যায়। পাতা কুঁকড়ে যায়, আকারে ছোট হয় এবং গাছের বৃদ্ধি থেমে যায়। ফল আকারে বিকৃত হতে পারে।',
              remedy: 'এর কোনো সরাসরি প্রতিকার নেই। এটি সাধারণত জাবপোকার মাধ্যমে ছড়ায়, তাই জাবপোকা দমন করা জরুরি। আক্রান্ত গাছ দেখামাত্র তুলে ফেলে পুড়িয়ে ফেলতে হবে।',
              imagePath: 'assets/images/mosaic.jpg', // এই ছবিটি assets ফোল্ডারে যোগ করতে হবে
            ),

            _buildDiseaseCard(
              context,
              title: 'মাছিপোকা',
              symptoms: 'পূর্ণাঙ্গ মাছিপোকা কচি ফলের গায়ে ছিদ্র করে ডিম পাড়ে। ডিম ফুটে কীড়া বের হয়ে ফলের নরম অংশ খেয়ে নষ্ট করে ফেলে। আক্রান্ত ফল হলুদ হয়ে পচে যায় এবং অকালে ঝরে পড়ে।',
              remedy: 'পরিষ্কার-পরিচ্ছন্ন চাষাবাদ করতে হবে। আক্রান্ত ফল সংগ্রহ করে নষ্ট করে ফেলতে হবে। ফেরোমন ফাঁদ ব্যবহার করা সবচেয়ে কার্যকর ও পরিবেশবান্ধব একটি পদ্ধতি।',
              imagePath: 'assets/images/fruit.jpg', // এই ছবিটি assets ফোল্ডারে যোগ করতে হবে
            ),

            _buildDiseaseCard(
                context,
                title: 'চিচিঙ্গা হোয়াইট মোল্ড রোগ',
                symptoms: "ছত্রাকের আক্রমনে এ রোগ হয়। কান্ডে ও ফলে সাদা তুলার মত বস্তু দেখা যায় ।",
                remedy: '১। আক্রান্ত ফল,পাতা ও ডগা অপসারণ করা। ২। বীজ লাগানোর আগে গভীরভাবে চাষ দিয়ে জমি তৈরী করা । ৩। প্রপিকোনাজল গ্রুপের ছত্রাকনাশক যেমন: টিল্ট ২৫০ ইসি ০.৫ মি.লি. / লি. হারে পানিতে মিশিয়ে ১০ দিন পরপর ৩ বার শেষ বিকেলে স্প্রে করা।',
                imagePath: 'assets/images/whitemold.jpg',
            ),

            _buildDiseaseCard(
              context,
              title: 'চিচিঙ্গা পাতা সুড়ঙ্গকারী পোকা',
              symptoms: "ক্ষুদ্র কীড়া পাতার দুইপাশের সবুজ অংশ খেয়ে ফেলে। তাই পাতার উপর আঁকা বাঁকা রেখার মত দাগ পড়ে এবং পাতা শুকিয়ে ঝড়ে যায়।",
              remedy: '১। আক্রান্ত পাতা সংগ্রহ করে ধ্বংস করা বা পুড়ে ফেলা। ২। আঠালো হলুদ ফাঁদ স্থাপন করা । ৩। সাইপারমেথ্রিন গ্রুপের কীটনাশক ( যেমন: কট ১০ ইসি) ১ মি.লি. / লি. হারে পানিতে মিশিয়ে স্প্রে করা।',
              imagePath: 'assets/images/bsd.jpg',
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

  // রোগবালাই দেখানোর জন্য একটি কার্ড উইজেট
  Widget _buildDiseaseCard(BuildContext context, {required String title, required String symptoms, required String remedy, String? imagePath}) {
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
                  'লক্ষণ:',
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
                  'প্রতিকার:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                ),
                const SizedBox(height: 4),
                Text(
                  remedy,
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
