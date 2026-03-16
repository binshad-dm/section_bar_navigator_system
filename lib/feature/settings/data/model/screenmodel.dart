import 'package:flutter/material.dart';

class ScreenModel {
  final String name;
  final List<String>? pagesData;
  final Color tabColor;
  final Widget screens;
  final bool isScreenFullWidth;

  ScreenModel({
    required this.name,
    this.isScreenFullWidth = false,
    required this.tabColor,
    this.pagesData,
    required this.screens,
  });
}
