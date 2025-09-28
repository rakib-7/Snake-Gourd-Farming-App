import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:snake_gourd/services/tts_service.dart';

// GovtSchemePage-কে একটি StatefulWidget-এ রূপান্তর করা হয়েছে
class GovtSchemePage extends StatefulWidget {
  const GovtSchemePage({super.key});

  @override
  State<GovtSchemePage> createState() => _GovtSchemePageState();
}

class _GovtSchemePageState extends State<GovtSchemePage> {
  // পেজের সব লেখা একটি স্ট্রিং-এ একত্রিত করা হয়েছে
  final String _combinedText =
      'কৃষকদের জন্য বাংলাদেশ সরকারের উদ্যোগ। বাংলাদেশ সরকার কৃষি খাতের উন্নয়নে এবং কৃষকদের জীবনযাত্রার মান উন্নত করতে বিভিন্ন ধরণের প্রকল্প ও সহায়তা প্রদান করে থাকে। নিচে কিছু গুরুত্বপূর্ণ প্রকল্প সম্পর্কে আলোচনা করা হলো: সার ও বীজে ভর্তুকি। কৃষকদের উৎপাদন খরচ কমাতে সরকার বিভিন্ন প্রকার সার, যেমন ইউরিয়া, টিএসপি, এমওপি এবং উন্নত মানের বীজে ভর্তুকি প্রদান করে। সহজ শর্তে কৃষি ঋণ। বিভিন্ন সরকারি ও বেসরকারি ব্যাংকের মাধ্যমে কৃষকদের অত্যন্ত সহজ শর্তে এবং স্বল্প সুদে কৃষি ঋণ প্রদান করা হয়, যা ফসল উৎপাদন ও খামার ব্যবস্থাপনায় সহায়তা করে। আধুনিক প্রযুক্তি ও প্রশিক্ষণ। কৃষি সম্প্রসারণ অধিদপ্তরের মাধ্যমে কৃষকদের আধুনিক চাষাবাদ পদ্ধতি, নতুন জাত এবং প্রযুক্তি সম্পর্কে প্রশিক্ষণ দেওয়া হয়। গুরুত্বপূর্ণ লিঙ্কসমূহ। কৃষি সম্প্রসারণ অধিদপ্তর। কৃষি তথ্য সার্ভিস। বাংলাদেশ কৃষি গবেষণা ইনস্টিটিউট।';

  // URL খোলার জন্য একটি হেল্পার ফাংশন
  Future<void> _launchURL(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('দুঃখিত, এই লিঙ্কটি খোলা যাচ্ছে না: $url')),
      );
    }
  }

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
        title: const Text('সরকারি প্রকল্পসমূহ'),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'কৃষকদের জন্য বাংলাদেশ সরকারের উদ্যোগ',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'বাংলাদেশ সরকার কৃষি খাতের উন্নয়নে এবং কৃষকদের জীবনযাত্রার মান উন্নত করতে বিভিন্ন ধরণের প্রকল্প ও সহায়তা প্রদান করে থাকে। নিচে কিছু গুরুত্বপূর্ণ প্রকল্প সম্পর্কে আলোচনা করা হলো:',
              style: TextStyle(fontSize: 16, height: 1.6),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 24),
            _buildSchemeCard(
              context,
              icon: Icons.paid_outlined,
              title: 'সার ও বীজে ভর্তুকি',
              description: 'কৃষকদের উৎপাদন খরচ কমাতে সরকার বিভিন্ন প্রকার সার, যেমন ইউরিয়া, টিএসপি, এমওপি এবং উন্নত মানের বীজে ভর্তুকি প্রদান করে।',
              imagePath: 'assets/images/fertilizer.png', // এই ছবিটি assets ফোল্ডারে যোগ করতে হবে
            ),
            _buildSchemeCard(
              context,
              icon: Icons.account_balance_wallet_outlined,
              title: 'সহজ শর্তে কৃষি ঋণ',
              description: 'বিভিন্ন সরকারি ও বেসরকারি ব্যাংকের মাধ্যমে কৃষকদের অত্যন্ত সহজ শর্তে এবং স্বল্প সুদে কৃষি ঋণ প্রদান করা হয়, যা ফসল উৎপাদন ও খামার ব্যবস্থাপনায় সহায়তা করে।',
            ),
            _buildSchemeCard(
              context,
              icon: Icons.biotech_outlined,
              title: 'আধুনিক প্রযুক্তি ও প্রশিক্ষণ',
              description: 'কৃষি সম্প্রসারণ অধিদপ্তরের মাধ্যমে কৃষকদের আধুনিক চাষাবাদ পদ্ধতি, নতুন জাত এবং প্রযুক্তি সম্পর্কে প্রশিক্ষণ দেওয়া হয়।',
              imagePath: 'assets/images/advance_technology.png', // এই ছবিটি assets ফোল্ডারে যোগ করতে হবে
            ),
            const SizedBox(height: 24),
            const Text(
              'গুরুত্বপূর্ণ লিঙ্কসমূহ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _buildLinkTile(
              context,
              icon: Icons.language,
              title: 'কৃষি সম্প্রসারণ অধিদপ্তর',
              url: 'http://www.dae.gov.bd/',
            ),
            _buildLinkTile(
              context,
              icon: Icons.info_outline,
              title: 'কৃষি তথ্য সার্ভিস',
              url: 'http://www.ais.gov.bd/',
            ),
            _buildLinkTile(
              context,
              icon: Icons.science_outlined,
              title: 'বাংলাদেশ কৃষি গবেষণা ইনস্টিটিউট',
              url: 'http://www.bari.gov.bd/',
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

  // প্রকল্প দেখানোর জন্য একটি কার্ড উইজেট
  Widget _buildSchemeCard(BuildContext context, {required IconData icon, required String title, required String description, String? imagePath}) {
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
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox(height: 150, child: Center(child: Text('ছবি পাওয়া যায়নি'))),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: Colors.teal, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  description,
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

  // লিঙ্ক দেখানোর জন্য একটি টাইল উইজেট
  Widget _buildLinkTile(BuildContext context, {required IconData icon, required String title, required String url}) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(title, style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline)),
      onTap: () => _launchURL(context, url),
    );
  }
}
