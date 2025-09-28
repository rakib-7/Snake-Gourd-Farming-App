import 'package:flutter/material.dart';

/// Represents a single item in the home screen menu.
class MenuItem {
  final String title;
  final IconData icon;
  final Color? color;

  MenuItem({
    required this.title,
    required this.icon,
    this.color,
  });
}

