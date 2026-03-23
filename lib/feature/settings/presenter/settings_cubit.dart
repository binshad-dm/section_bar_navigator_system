import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:section_bar_navigator_system/feature/settings/data/model/screenmodel.dart';
import 'package:section_bar_navigator_system/feature/settings/presenter/state/settings_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum HandnessType { left, right }

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsInitial());
  ScrollController? controller;
  HandnessType _handnessType = HandnessType.right;
  bool _vibrationEnabled = true;
  bool isScrolled = false;
  bool _isFloatingScreen = true;
  Timer? _hideOverlayTimer;

  final List<SectionData> screenList = [];
  List<String> tagList = [];

  HandnessType get handnessType => _handnessType;
  bool get vibrationEnabled => _vibrationEnabled;
  bool get isFloatingScreen => _isFloatingScreen;

  double? floatingWidgetCurrentDx;
  double? floatingWidgetCurrentDy;

  int currentSelectedIndex = 0;

  double currentScrollPosition = 0.0;

  void setcurrentSelectedIndex(index) {
    currentSelectedIndex = index;
    emit(SettingsDataLoaded());
  }

  void setCurrentScrollPosition(value) {
    currentScrollPosition = value;
  }

  void setfloatingButtonCurrentPosition(dx, dy) async {
    floatingWidgetCurrentDx = dx;
    floatingWidgetCurrentDy = dy;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("section_nav_floatButtonPosition", [
      dx != null ? dx.toString() : '',
      dy != null ? dy.toString() : '',
    ]);
  }

  Future<void> setSectionOrderInitially() async {
    final prefs = await SharedPreferences.getInstance();
    final sectionsNameList = prefs.getStringList("section_nav_SectionList");

    if (sectionsNameList == null || sectionsNameList.isEmpty) return;

    List<SectionData> newScreenOrder = [];

    for (var name in sectionsNameList) {
      final match = screenList.firstWhere((e) => e.name == name);
      newScreenOrder.add(match);
    }

    screenList
      ..clear()
      ..addAll(newScreenOrder);
    tagList = generateUniqueTags(screenList.map((e) => e.name).toList());
  }

  Future<void> resetReorderedSection() async {
    final prefs = await SharedPreferences.getInstance();

    screenList..clear();
    // Default screens reset is removed because it now takes dynamic screens.

    await prefs.setStringList(
      "section_nav_SectionList",
      screenList.map((e) => e.name).toList(),
    );
    emit(SettingsDataLoaded());
  }

  void setFloatingScreenState(width) async {
    _isFloatingScreen = true;
    emit(SettingsDataLoaded());
  }

  void setNormalScreenState(context, {isMakeDelay = true}) async {
    _isFloatingScreen = false;
    isScrolled = false;
    emit(SettingsFloatingScreenState());
    if (isMakeDelay) {
      await Future.delayed(Duration(milliseconds: 20));
    }
    if (controller!.hasClients) {
      controller?.jumpTo(currentScrollPosition + 0.1);
    }
    _hideOverlayTimer = Timer(const Duration(seconds: 2), () {
      if (!isScrolled && !isFloatingScreen) {
        final size = MediaQuery.of(context).size;
        setFloatingScreenState(size.width);
      }
    });
  }

  Future<void> loadSettings(
    List<SectionData> initialSections, {
    required bool vibrationEnabled,
    required HandnessType handnessType,
  }) async {
    screenList.clear();
    screenList.addAll(initialSections);
    final prefs = await SharedPreferences.getInstance();

    // Removed persistence for hand and vib
    setSectionOrderInitially();
    final List<String>? positionList = prefs.getStringList(
      'section_nav_floatButtonPosition',
    );
    if (positionList != null && positionList.length >= 2) {
      final rawDx = positionList[0];
      final rawDy = positionList[1];
      final parsedDx = double.tryParse(
        (rawDx.trim().toLowerCase() == 'null') ? '' : rawDx,
      );
      final parsedDy = double.tryParse(
        (rawDy.trim().toLowerCase() == 'null') ? '' : rawDy,
      );
      if (parsedDx != null) {
        floatingWidgetCurrentDx = parsedDx;
      }
      if (parsedDy != null) {
        floatingWidgetCurrentDy = parsedDy;
      }
    }

    _handnessType = handnessType;
    _vibrationEnabled = vibrationEnabled;
    tagList = generateUniqueTags(screenList.map((e) => e.name).toList());

    emit(SettingsDataLoaded());
  }

  Future<void> setHandnessType(HandnessType value) async {
    _handnessType = value;
    emit(SettingsDataLoaded());
  }

  Future<void> toggleVibration(bool value) async {
    _vibrationEnabled = value;
    emit(SettingsDataLoaded());
  }
}

String generateUniqueTag(List<String> items, int index) {
  final Set<String> usedTags = {};
  final List<String> results = [];

  for (final item in items) {
    final words = item.trim().split(RegExp(r'\s+'));
    String baseTag;

    if (words.length >= 2) {
      baseTag = (words[0][0] + words[1][0])
          .toUpperCase(); // e.g., Doctor Note → DN
    } else {
      baseTag = words[0][0].toUpperCase(); // e.g., Doctors → D
    }

    if (!usedTags.contains(baseTag)) {
      usedTags.add(baseTag);
      results.add(baseTag);
    } else {
      final fallbackTag = generateFallbackTag(words[0], usedTags);
      usedTags.add(fallbackTag);
      results.add(fallbackTag);
    }
  }

  assert(
    results.length == items.length,
    "Returned list length does not match input.",
  );
  return results[index];
}

String generateFallbackTag(String word, Set<String> usedTags) {
  // Simple fallback implementation
  for (int i = 1; i <= 99; i++) {
    String candidate = '${word[0].toUpperCase()}$i';
    if (!usedTags.contains(candidate)) {
      return candidate;
    }
  }
  return '${word[0].toUpperCase()}99';
}

List<String> generateUniqueTags(List<String> items) {
  final Set<String> usedTags = {};
  final List<String> results = [];

  for (final item in items) {
    final words = item.trim().split(RegExp(r'\s+'));
    String baseTag;

    if (words.length >= 2) {
      baseTag = (words[0][0] + words[1][0])
          .toUpperCase(); // e.g., Doctor Note → DN
    } else {
      baseTag = words[0][0].toUpperCase(); // e.g., Doctors → D
    }

    if (!usedTags.contains(baseTag)) {
      usedTags.add(baseTag);
      results.add(baseTag);
    } else {
      final fallbackTag = generateFallbackTag(words[0], usedTags);
      usedTags.add(fallbackTag);
      results.add(fallbackTag);
    }
  }

  assert(
    results.length == items.length,
    "Returned list length does not match input.",
  );
  return results;
}
