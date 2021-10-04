import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'store_manager.dart';

// ignore: prefer_mixin
class ThemeNotifier with ChangeNotifier {
  final darkTheme = ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    backgroundColor: const Color(0xFF212121),
    accentColor: Colors.white,
    accentIconTheme: IconThemeData(color: Colors.black),
    dividerColor: Colors.black12,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    errorColor: Colors.white,
  );

  final lightTheme = ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: Colors.blue,
    brightness: Brightness.light,
    backgroundColor: const Color(0xFFE5E5E5),
    accentColor: Colors.black,
    accentIconTheme: IconThemeData(color: Colors.white),
    dividerColor: Colors.white54,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    errorColor: Colors.white,
  );

  ThemeData? _themeData;
  ThemeData? getTheme() => _themeData;

  ThemeNotifier() {
    StorageManager.readData('themeMode').then((value) {
      // print('value read from storage: ' + value.toString());
      final themeMode = value ?? 'light';
      if (themeMode == 'light') {
        _themeData = lightTheme;
      } else {
        // print('setting dark theme');
        _themeData = darkTheme;
      }
      notifyListeners();
    });
  }

  void setDarkMode() async {
    _themeData = darkTheme;
    StorageManager.saveData('themeMode', 'dark');
    notifyListeners();
  }

  void setLightMode() async {
    _themeData = lightTheme;
    StorageManager.saveData('themeMode', 'light');
    notifyListeners();
  }

  Future<String> getIconTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeMode = prefs.get('themeMode');
    if (themeMode != null) {
      return themeMode.toString();
    } else {
      return 'light';
    }
  }
}
