import 'package:flutter/material.dart';

class SectionData {
  final String name;
  final Color tabColor;
  final Widget screens;
  final bool isScreenFullWidth;

  SectionData({
    required this.name,
    this.isScreenFullWidth = true,
    required this.tabColor,
    required this.screens,
  });
}
