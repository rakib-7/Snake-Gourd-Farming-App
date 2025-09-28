import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  // Singleton প্যাটার্ন ব্যবহার করে একটি মাত্র ইনস্ট্যান্স তৈরি করা
  static final TtsService instance = TtsService._internal();
  factory TtsService() => instance;
  TtsService._internal();

  final FlutterTts _flutterTts = FlutterTts();

  // TTS ইঞ্জিন বর্তমানে কথা বলছে কি না, তা ট্র্যাক করার জন্য
  final ValueNotifier<bool> isSpeaking = ValueNotifier(false);

  // TTS ইঞ্জিন চালু করার জন্য
  Future<void> initialize() async {
    await _flutterTts.setLanguage("bn-BD");

    // কথা বলা শেষ হলে isSpeaking রিসেট করা
    _flutterTts.setCompletionHandler(() {
      isSpeaking.value = false;
    });

    // কোনো ত্রুটি হলে isSpeaking রিসেট করা
    _flutterTts.setErrorHandler((_) {
      isSpeaking.value = false;
    });
  }

  // সম্পূর্ণ পৃষ্ঠার লেখা পড়া শুরু বা বন্ধ করার ফাংশন
  Future<void> toggleSpeak(String fullPageText) async {
    if (isSpeaking.value) {
      await stop();
    } else {
      if (fullPageText.isNotEmpty) {
        final result = await _flutterTts.speak(fullPageText);
        if (result == 1) {
          isSpeaking.value = true;
        }
      }
    }
  }

  // কথা বলা বন্ধ করার ফাংশন
  Future<void> stop() async {
    await _flutterTts.stop();
    isSpeaking.value = false;
  }
}

