import 'package:flutter/material.dart';

import 'package:section_bar_navigator_system/feature/settings/data/model/screenmodel.dart';
// Note: We might move screenmodel into this file or a nearby models/ file shortly.
import 'package:section_bar_navigator_system/app.dart';

// Type definitions for callbacks
typedef FloatingPositionChangedCallback = void Function(double dx, double dy);

/// The main entry point for the Section Bar Navigator package.
class SectionBarNavigator extends StatelessWidget {
  /// The list of sections (tabs) in the index bar, and their corresponding screens.
  final List<SectionData> sections;

  /// The root navigator key for the app.
  final GlobalKey<NavigatorState> navigatorKey;

  /// Whether to display an AppBar on the screens (when in full screen mode).
  final bool showAppBar;

  /// (Optional) Callback fired when the user drags and stops the floating button.
  final FloatingPositionChangedCallback? onFloatingPositionChanged;

  /// Configuration for the floating button's position when it's first created (if not saved previously).
  final double? initialFloatingPositionDx;
  final double? initialFloatingPositionDy;

  const SectionBarNavigator({
    super.key,
    required this.sections,
    required this.navigatorKey,
    this.showAppBar = false,
    this.onFloatingPositionChanged,
    this.initialFloatingPositionDx,
    this.initialFloatingPositionDy,
  });

  @override
  Widget build(BuildContext context) {
    return App(
      navigatorKey: navigatorKey,
      sections: sections,
      showAppBar: showAppBar,
      onFloatingPositionChanged: onFloatingPositionChanged,
      dx: initialFloatingPositionDx,
      dy: initialFloatingPositionDy,
    );
  }
}
