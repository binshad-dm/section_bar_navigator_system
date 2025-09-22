import 'package:flutter/material.dart';
import 'package:section_bar_navigator_system/app.dart';
import 'package:shared_preferences/shared_preferences.dart';
final navigatorKey = GlobalKey<NavigatorState>();
void main() async{
    WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  List<String>? data = prefs.getStringList('floatButtonPosition');

  final double? dx = (data != null && data.length >= 2)
      ? double.tryParse((data[0].trim().toLowerCase() == 'null') ? '' : data[0])
      : 347.79575892857144;
  final double? dy = (data != null && data.length >= 2)
      ? double.tryParse((data[1].trim().toLowerCase() == 'null') ? '' : data[1])
      : 423.5546875;
  runApp( App(navigatorKey: navigatorKey,dx: dx,dy: dy,));
}
