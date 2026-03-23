import 'package:flutter/material.dart';
import 'package:section_bar_navigator_system/feature/settings/data/model/screenmodel.dart';
import 'package:section_bar_navigator_system/feature/settings/presenter/settings_cubit.dart';
import 'package:section_bar_navigator_system/section_bar_navigator.dart';

import 'sections/activity_page.dart';
import 'sections/anesthetics/pages/anesthetic_page.dart';
import 'sections/lab_results_page.dart';

final List<SectionData> defaultSectionList = [
  SectionData(
    isScreenFullWidth: true,
    screens: AnestheticPage(),
    name: 'Anesthetics',
    tabColor: Colors.indigoAccent,
  ),
  SectionData(
    screens: ActivityPage(),
    name: 'Activity Page',
    tabColor: Colors.green,
  ),
  SectionData(
    screens: LabResultPage(),
    name: 'Lab Results',
    tabColor: Colors.deepOrange,
  ),
];

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      home: SectionBarNavigator(
        navigatorKey: navigatorKey,
        sections: defaultSectionList,
      ),
    ),
  );
}
