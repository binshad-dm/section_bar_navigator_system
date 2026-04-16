import 'package:flutter/material.dart';

import 'package:section_bar_navigator_system/feature/settings/data/model/screenmodel.dart';
import 'package:section_bar_navigator_system/feature/settings/presenter/settings_cubit.dart';
import 'package:section_bar_navigator_system/app.dart';

// Type definitions for callbacks
typedef FloatingPositionChangedCallback = void Function(double dx, double dy);
typedef SectionChangedCallback = void Function(int index, SectionData sectionData);

/// The main entry point for the Section Bar Navigator package.
class SectionBarNavigator extends StatelessWidget {
  /// The list of sections (tabs) in the index bar, and their corresponding screens.
  final List<SectionData> sections;

  /// The root navigator key for the app.
  final GlobalKey<NavigatorState>? navigatorKey;

  /// Whether to display an AppBar on the screens (when in full screen mode).
  final bool showAppBar;

  /// Whether to enable vibration when scrolling through sections.
  final bool vibrationEnabled;

  /// The default handness (left/right) for the index bar and floating button.
  final HandnessType? handnessType;

  /// (Optional) Callback fired when the user drags and stops the floating button.
  final FloatingPositionChangedCallback? onFloatingPositionChanged;

  /// (Optional) Callback fired when the user selects a section.
  final SectionChangedCallback? onSectionChanged;

  /// Configuration for the floating button's position when it's first created (if not saved previously).
  final double? initialFloatingPositionDx;
  final double? initialFloatingPositionDy;

  const SectionBarNavigator({
    super.key,
    required this.sections,
    this.navigatorKey,
    this.showAppBar = true,
    this.onFloatingPositionChanged,
    this.initialFloatingPositionDx,
    this.initialFloatingPositionDy,
    this.vibrationEnabled = true,
    this.handnessType,
    this.onSectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return App(
      navigatorKey: navigatorKey,
      sections: sections,
      showAppBar: showAppBar,
      onFloatingPositionChanged: onFloatingPositionChanged,
      initialFloatingPositionDx: initialFloatingPositionDx,
      initialFloatingPositionDy: initialFloatingPositionDy,
      vibrationEnabled: vibrationEnabled,
      handnessType: handnessType ?? HandnessType.right,
      onSectionChanged: onSectionChanged,
    );
  }
}
