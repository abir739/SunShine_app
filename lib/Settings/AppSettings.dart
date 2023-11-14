import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsLoader extends ChangeNotifier{
  static const String keyTheme = 'themeKey';
  static const String keyHideEmptyScheduleWeek = 'hideEmptyScheduleWeekKey';
  static const String keyAnimation = 'animationKey';
  static const String ActivityColor = 'activitycolor';
  static const String TransferColor = 'transfercolor';
  static const String Taskcoloe = 'taskcolor';
static const String keyBackgroundImage = 'backgroundImageKey'; // New key
 static const String ActivityColorKey = 'activity_color';

  Color? _activityColor;

  Color? get activityColor => _activityColor;
    Color? _transferColor;

  Color? get transferColor => _transferColor;
  // Save theme setting
  static Future<void> saveTheme(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyTheme, isDarkMode);
  }
  // Save background image setting
  static Future<void> saveBackgroundImage(String? imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyBackgroundImage, imagePath ?? '');
  }

  // Load background image setting
static Future<String?> loadBackgroundImage() async {
  final prefs = await SharedPreferences.getInstance();
  final imagePath = prefs.getString(keyBackgroundImage);
  print('Loaded background image path: $imagePath');
   return prefs.getString(keyBackgroundImage) ?? null;

}
  // Load theme setting
  static Future<bool> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyTheme) ?? false; // Default value is false
  }

  // Save hideEmptyScheduleWeek setting
  static Future<void> saveHideEmptyScheduleWeek(bool hide) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyHideEmptyScheduleWeek, hide);
  }

  // Load hideEmptyScheduleWeek setting
  static Future<bool> loadHideEmptyScheduleWeek() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyHideEmptyScheduleWeek) ?? false; // Default value is false
  }

  // Save animation setting
  static Future<void> saveAnimation(bool isAnimated) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyAnimation, isAnimated);
  }

  // Load animation setting
  static Future<bool> loadAnimation() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyAnimation) ?? false; // Default value is false
  }
  static Future<void> saveActivitycolor(String? activitycolor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(ActivityColor, activitycolor ?? '');
  }
  static Future<String?> loadActivitycolor() async {
  final prefs = await SharedPreferences.getInstance();
  final activitycolor = prefs.getString(ActivityColor);
  print('Loaded background image path: $activitycolor');
   return prefs.getString(ActivityColor) ?? null;

}
 Future<void> saveActivityColor(Color? activityColor) async {
    final prefs = await SharedPreferences.getInstance();
    if (activityColor != null) {
      await prefs.setInt(ActivityColorKey, activityColor.value);
    } else {
      await prefs.remove(ActivityColorKey);
    }
    _activityColor = activityColor;
    notifyListeners();
  }

 Future<Color?> loadActivityColor() async {
  final prefs = await SharedPreferences.getInstance();
  final int? colorValue = prefs.getInt(ActivityColorKey);
  _activityColor = colorValue != null ? Color(colorValue) : null;
  notifyListeners();
  return _activityColor;
}
 Future<void> saveTransferColor(Color? transferColor) async {
    final prefs = await SharedPreferences.getInstance();
    if (transferColor != null) {
      await prefs.setInt(TransferColor, transferColor.value);
    } else {
      await prefs.remove(TransferColor);
    }
    _transferColor = transferColor;
    notifyListeners();
  }

 Future<Color?> loadTranferColor() async {
  final prefs = await SharedPreferences.getInstance();
  final int? colorValue = prefs.getInt(TransferColor);
  _transferColor = colorValue != null ? Color(colorValue) : null;
  notifyListeners();
  return _transferColor;
}
}
