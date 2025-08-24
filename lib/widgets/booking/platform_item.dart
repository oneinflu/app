import 'package:flutter/material.dart';

class PlatformItem {
  final String name;
  final IconData icon;
  bool isSelected;

  PlatformItem({
    required this.name,
    required this.icon,
    this.isSelected = false,
  });
}