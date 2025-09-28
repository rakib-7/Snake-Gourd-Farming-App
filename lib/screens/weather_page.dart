import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final String _apiKey = 'a8b92b8a29b2de30319a413ae1e002b8';
  final String _lat = '22.25';
  final String _lon = '92.05';
  late Future<Map<String, dynamic>> _weatherFuture;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('bn_BD', null);
    _weatherFuture = _fetchWeatherWithRetry();
  }

  Future<Map<String, dynamic>> _fetchWeatherWithRetry({int retries = 3}) async {
    for (int i = 0; i < retries; i++) {
      try {
        return await _fetchWeather();
      } catch (e) {
        if (i == retries - 1) rethrow;
        await Future.delayed(const Duration(seconds: 2));
      }
    }
    throw Exception('সমস্ত চেষ্টা ব্যর্থ হয়েছে');
  }

  Future<Map<String, dynamic>> _fetchWeather() async {
    // Check internet connection
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw Exception('ইন্টারনেট সংযোগ নেই। মোবাইল ডাটা বা Wi-Fi চালু করুন।');
    }

    final url = 'https://api.openweathermap.org/data/2.5/onecall?lat=$_lat&lon=$_lon&exclude=minutely,hourly,alerts&appid=$_apiKey&units=metric&lang=bn';

    try {
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        throw Exception('API Key ভুল। OpenWeatherMap থেকে নতুন Key নিন।');
      } else {
        throw Exception('সার্ভার ত্রুটি: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('ইন্টারনেট সংযোগ সমস্যা। পরীক্ষা করুন।');
    } on TimeoutException {
      throw Exception('রিকুয়েস্ট সময় শেষ। ইন্টারনেট গতি পরীক্ষা করুন।');
    } catch (e) {
      throw Exception('ত্রুটি: $e');
    }
  }

  // আবহাওয়ার অবস্থার ওপর ভিত্তি করে আইকন ও রঙ নির্ধারণ
  Map<String, dynamic> _getWeatherUI(String condition) {
    condition = condition.toLowerCase();
    if (condition.contains('rain')) {
      return {'icon': Icons.grain, 'color': Colors.blue.shade300};
    } else if (condition.contains('clouds')) {
      return {'icon': Icons.cloud_outlined, 'color': Colors.grey.shade400};
    } else if (condition.contains('thunderstorm')) {
      return {'icon': Icons.bolt, 'color': Colors.yellow.shade700};
    }
    return {'icon': Icons.wb_sunny, 'color': Colors.orangeAccent};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('বাস্তব আবহাওয়ার পূর্বাভাস'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.grey[800],
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _weatherFuture,
        builder: (context, snapshot) {
          if (_apiKey.contains('YOUR_OPENWEATHERMAP_API_KEY')) {
            return const Center(child: Text('অনুগ্রহ করে API Key যোগ করুন।', style: TextStyle(color: Colors.red, fontSize: 16)));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('ত্রুটি: ${snapshot.error}', style: const TextStyle(fontSize: 16)));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('কোনো ডেটা পাওয়া যায়নি।'));
          }

          final currentData = snapshot.data!['current'];
          final dailyData = snapshot.data!['daily'] as List;
          final todayData = dailyData[0];

          final uiProps = _getWeatherUI(currentData['weather'][0]['main']);

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                _buildCurrentWeatherCard(currentData, todayData, uiProps),
                const SizedBox(height: 24),
                _buildFarmingAdviceCard(dailyData),
                const SizedBox(height: 24),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('আগামী ৭ দিনের পূর্বাভাস', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
                ),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: dailyData.length > 7 ? 7 : dailyData.length,
                  itemBuilder: (context, index) {
                    return _buildDailyForecastTile(dailyData[index]);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // বর্তমান আবহাওয়ার কার্ড
  Widget _buildCurrentWeatherCard(Map<String, dynamic> current, Map<String, dynamic> today, Map<String, dynamic> ui) {
    String condition = current['weather'][0]['description'];
    condition = condition.replaceFirst(condition[0], condition[0].toUpperCase());

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [ui['color'].withOpacity(0.8), ui['color']],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
        ),
        child: Column(
          children: [
            const Text('চন্দনাইশ, চট্টগ্রাম', style: TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 10),
            Icon(ui['icon'], size: 70, color: Colors.white),
            const SizedBox(height: 10),
            Text('${current['temp'].round()}°C', style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.white)),
            Text(condition, style: const TextStyle(color: Colors.white, fontSize: 20)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _weatherInfo('সর্বোচ্চ', '${today['temp']['max'].round()}°'),
                _weatherInfo('সর্বনিম্ন', '${today['temp']['min'].round()}°'),
                _weatherInfo('আর্দ্রতা', '${current['humidity']}%'),
              ],
            )
          ],
        ),
      ),
    );
  }

  // চাষের পরামর্শ কার্ড
  Widget _buildFarmingAdviceCard(List<dynamic> dailyData) {
    String advice = 'সাধারণ আবহাওয়ায় নিয়মিত পরিচর্যা চালিয়ে যান।';
    if (dailyData.length > 1) {
      final tomorrow = dailyData[1];
      final tomorrowCondition = tomorrow['weather'][0]['main'].toString().toLowerCase();
      if (tomorrowCondition.contains('rain') || tomorrowCondition.contains('thunderstorm')) {
        advice = 'আগামীকাল বৃষ্টির সম্ভাবনা। আজ সেচ দেওয়া থেকে বিরত থাকুন এবং অতিরিক্ত পানি নিষ্কাশনের ব্যবস্থা প্রস্তুত রাখুন।';
      } else if (tomorrow['temp']['day'] > 34) {
        advice = 'আগামীকাল তাপমাত্রা বেশি থাকবে। গাছের গোড়ায় আর্দ্রতা ধরে রাখতে সকালে বা সন্ধ্যায় হালকা সেচ দিন।';
      }
    }
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.eco_outlined, color: Colors.green, size: 40),
            const SizedBox(width: 16),
            Expanded(child: Text(advice, style: const TextStyle(fontSize: 15, height: 1.5))),
          ],
        ),
      ),
    );
  }

  // ৭ দিনের পূর্বাভাসের জন্য টাইল
  Widget _buildDailyForecastTile(Map<String, dynamic> dayData) {
    final dt = DateTime.fromMillisecondsSinceEpoch(dayData['dt'] * 1000);
    final dayName = DateFormat('EEEE', 'bn_BD').format(dt);
    final tempMax = (dayData['temp']['max'] as double).round();
    final tempMin = (dayData['temp']['min'] as double).round();
    final iconCode = dayData['weather'][0]['icon'];

    return Card(
      elevation: 2,
      child: ListTile(
        leading: Image.network('https://openweathermap.org/img/wn/$iconCode@2x.png', width: 40),
        title: Text(dayName, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text('$tempMax° / $tempMin°', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      ),
    );
  }

  // ছোট আবহাওয়ার তথ্য
  Widget _weatherInfo(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.8))),
      ],
    );
  }
}




//
// import 'package:flutter/material.dart';
// import 'package:snake_gourd/services/tts_service.dart';
// import 'package:snake_gourd/widgets/info_card.dart';
//
// class WeatherPage extends StatefulWidget {
//   const WeatherPage({super.key});
//
//   @override
//   State<WeatherPage> createState() => _WeatherPageState();
// }
//
// class _WeatherPageState extends State<WeatherPage> {
//   // পৃষ্ঠার সকল লেখার জন্য একটি স্ট্রিং তৈরি করা হয়েছে
//   String _getCombinedText() {
//     return 'চিচিঙ্গা চাষে আবহাওয়া ও মাটির ভূমিকা। আবহাওয়া: চিচিঙ্গা উষ্ণ ও আর্দ্র আবহাওয়ায় ভালো জন্মে। গ্রীষ্মকাল এর জন্য সবচেয়ে উপযোগী। ২৫-৩৫°C তাপমাত্রা চিচিঙ্গা চাষের জন্য আদর্শ। অতিরিক্ত বৃষ্টিপাত এবং তাপমাত্রা কমে গেলে গাছের বৃদ্ধি ও ফলন কমে যায়। মাটির ধরণ: চিচিঙ্গা চাষের জন্য উর্বর বেলে দোআঁশ ও দোআঁশ মাটি সবচেয়ে উপযোগী। তবে পানি নিষ্কাশনের সুব্যবস্থা থাকলে এঁটেল দোআঁশ মাটিতেও এর চাষ করা যায়। মাটির pH ৬.০-৬.৮ হলে ভালো হয়।';
//   }
//
//   @override
//   void dispose() {
//     // পেজ থেকে বের হওয়ার সময় TTS বন্ধ করা
//     TtsService.instance.stop();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('আবহাওয়া ও মাটি'),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16.0),
//         children: const [
//           InfoCard(
//             title: 'আবহাওয়া',
//             imagePath: 'assets/images/goodweather.png',
//             description: 'চিচিঙ্গা উষ্ণ ও আর্দ্র আবহাওয়ায় ভালো জন্মে। গ্রীষ্মকাল এর জন্য সবচেয়ে উপযোগী। ২৫-৩৫°C তাপমাত্রা চিচিঙ্গা চাষের জন্য আদর্শ। অতিরিক্ত বৃষ্টিপাত এবং তাপমাত্রা কমে গেলে গাছের বৃদ্ধি ও ফলন কমে যায়।',
//           ),
//           InfoCard(
//             title: 'মাটির ধরণ',
//             imagePath: 'assets/images/soil.png',
//             description: 'চিচিঙ্গা চাষের জন্য উর্বর বেলে দোআঁশ ও দোআঁশ মাটি সবচেয়ে উপযোগী। তবে পানি নিষ্কাশনের সুব্যবস্থা থাকলে এঁটেল দোআঁশ মাটিতেও এর চাষ করা যায়। মাটির pH ৬.০-৬.৮ হলে ভালো হয়।',
//           ),
//         ],
//       ),
//       floatingActionButton: ValueListenableBuilder<bool>(
//         valueListenable: TtsService.instance.isSpeaking,
//         builder: (context, isSpeaking, child) {
//           return FloatingActionButton.extended(
//             onPressed: () => TtsService.instance.toggleSpeak(_getCombinedText()),
//             label: Text(isSpeaking ? 'থামুন' : 'শুনুন'),
//             icon: Icon(isSpeaking ? Icons.stop_rounded : Icons.volume_up_rounded),
//           );
//         },
//       ),
//     );
//   }
// }
