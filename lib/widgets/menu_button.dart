import 'package:flutter/material.dart';
import '../models/menu_item.dart';

/// হোম পেজের জন্য একটি কার্ড-স্টাইল বাটন উইজেট
class MenuButton extends StatelessWidget {
  final MenuItem item;
  final VoidCallback onTap; // নেভিগেশনের জন্য কলব্যাক ফাংশন

  const MenuButton({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // রঙের null সমস্যা সমাধানের জন্য একটি ডিফল্ট রঙ নির্ধারণ
    final buttonColor = item.color ?? Colors.green;

    return GestureDetector(
      onTap: onTap, // HomePage থেকে পাঠানো ফাংশনটি এখানে কাজ করবে
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias, // borderRadius সঠিকভাবে কাজ করার জন্য
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [buttonColor.withOpacity(0.7), buttonColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon, size: 50, color: Colors.white),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 2.0,
                        color: Colors.black26,
                        offset: Offset(1.0, 1.0),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

