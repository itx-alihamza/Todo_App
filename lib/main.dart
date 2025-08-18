import 'package:flutter/material.dart';
import 'package:template/utils/preferences_service.dart';
import 'screens/home/homePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize SharedPreferences service
  await PreferencesService.init();
  
  runApp(const MyApp());
}

