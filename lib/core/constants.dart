
import 'package:flutter/material.dart';
import 'package:section_bar_navigator_system/feature/sections/activity_page.dart';
import 'package:section_bar_navigator_system/feature/sections/anesthetics/pages/anesthetic_page.dart';

import 'package:section_bar_navigator_system/feature/sections/lab_results_page.dart';

import '../feature/settings/data/model/screenmodel.dart';
 final List<ScreenModel> defaultSectionList = [
         ScreenModel(
      isScreenFullWidth: true,
      screens: [AnestheticPage()],
      name: 'Anesthetics',
      currentSelectedScreenIndex: 0,
      tabColor: Colors.indigoAccent,
    ), ScreenModel(screens: [ActivityPage()], name: 'Activity Page', currentSelectedScreenIndex: 0, tabColor: Colors.green),
       ScreenModel(
      screens: [LabResultPage()],
      isScreenFullWidth: true,
      name: 'Lab Results',
      currentSelectedScreenIndex: 0,
      tabColor: Colors.deepOrange,
    ),
   

    
  ];
