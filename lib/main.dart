import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snake_gourd/services/tts_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:snake_gourd/screens/splash_screen.dart';


Future<void> main() async {
  // Flutter অ্যাপ চালু হওয়ার আগে Supabase চালু করা নিশ্চিত করুন
  WidgetsFlutterBinding.ensureInitialized();
  await TtsService.instance.initialize();
  // Supabase চালু করুন
  await Supabase.initialize(
    // ⚠️ গুরুত্বপূর্ণ: এখানে আপনার Supabase URL এবং anon key বসান
    url: 'https://ewycnjinodutcjnwwbmc.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV3eWNuamlub2R1dGNqbnd3Ym1jIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTg2MDk3NDAsImV4cCI6MjA3NDE4NTc0MH0.HtHHR_uBnY0T5iUHkD-u-TJDOXyECminOzhe4yUOYpM',
  );

  runApp(const SnakeGourdApp());
}

class SnakeGourdApp extends StatelessWidget {
  const SnakeGourdApp({super.key});

  @override
  Widget build(BuildContext context) {
    // একটি আধুনিক এবং সুন্দর থিম তৈরি করুন
    final textTheme = Theme.of(context).textTheme;

    return MaterialApp(
      title: 'চিচিঙ্গা সহায়িকা',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5), // হালকা ধূসর ব্যাকগ্রাউন্ড
        visualDensity: VisualDensity.adaptivePlatformDensity,

        // Google Fonts ব্যবহার করে একটি সুন্দর বাংলা ফন্ট সেট করুন
        textTheme: GoogleFonts.hindSiliguriTextTheme(textTheme).apply(
          bodyColor: Colors.grey[800],
          displayColor: Colors.black,
        ),

        // অ্যাপের সার্বিক ডিজাইন উন্নত করুন
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green.shade700,
          foregroundColor: Colors.white,
          elevation: 2,
          centerTitle: true,
          titleTextStyle: GoogleFonts.hindSiliguri(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.green.shade600,
          foregroundColor: Colors.white,
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade600,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            textStyle: GoogleFonts.hindSiliguri(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        cardTheme: CardThemeData(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        ),
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

