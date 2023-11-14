// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class NotificationCountNotifier with ChangeNotifier {
//   int _count = 0;

//   int get count => _count;

//   void increment() {
//     _count++;
//     notifyListeners();
//     Get.snackbar('new notification Have Ben', "",
//         colorText: Colors.white,
//         backgroundColor: Color.fromARGB(52, 243, 199, 3));
//     print('Count incremented: $_count');
//   }

//   void reset() {
//     _count = 0;
//     notifyListeners();
//   }
// }
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zenify_app/modele/activitsmodel/httpActivites.dart';
class NotificationCountNotifier with ChangeNotifier {
  int _count = 0;
  SharedPreferences? _prefs;
  bool _newNotificationReceived = false; // Flag for new notifications

  int get count => _count;
  bool get newNotificationReceived => _newNotificationReceived;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadCount();
  }

  Future<int> fetchNewCount(String apiUrl) async {
    final counts = HTTPHandlerCount();
    try {
      int newCount = await counts.fetchInlineCount(apiUrl);
      int difference = newCount - _count;

      // Set the new notification received flag
      _newNotificationReceived = difference > 0;

      _count = newCount;
      _saveCount();
      return difference;
    } catch (error) {
      print('Error: $error');
      throw error;
    }
  }

  void increment() {
    _count++;
    _saveCount();
    _newNotificationReceived = true; // Mark as a new notification received
    notifyListeners();
  }

  Future<void> resetCount() async {
    _count = 0;
    _newNotificationReceived = false; // Reset the new notification flag
    _saveCount();
    notifyListeners();
  }

  Future<void> loadCountFromStorage() async {
    _loadCount();
  }

  Future<void> _loadCount() async {
    if (_prefs != null) {
      _count = _prefs?.getInt('notificationCount') ?? 0;
      notifyListeners();
    }
  }

  Future<void> _saveCount() async {
    if (_prefs != null) {
      await _prefs?.setInt('notificationCount', _count);
    }
  }
}
// class NotificationCountNotifier with ChangeNotifier {
//   int _count = 0;
//   SharedPreferences? _prefs;

//   int get count => _count;

//   Future<void> init() async {
//     _prefs = await SharedPreferences.getInstance();
//     _loadCount();
//   }

//   Future<int> fetchNewCount(String apiUrl) async {
//     final counts = HTTPHandlerCount();
//     try {
//       int newCount = await counts.fetchInlineCount(apiUrl);
//       int difference = newCount - _count;
//       _count = newCount;
//       _saveCount();
//       return difference;
//     } catch (error) {
//       print('Error: $error');
//       throw error;
//     }
//   }
//  void increment() {
//     _count++;
//     _saveCount();
//     notifyListeners();
//   }
//   Future<void> resetCount() async {
//     _count = 0;
//     _saveCount();
//     notifyListeners();
//   }

//   Future<void> loadCountFromStorage() async {
//     _loadCount();
//   }

//   Future<void> _loadCount() async {
//     if (_prefs != null) {
//       _count = _prefs?.getInt('notificationCount') ?? 0;
//       notifyListeners();
//     }
//   }

//   Future<void> _saveCount() async {
//     if (_prefs != null) {
//       await _prefs?.setInt('notificationCount', _count);
//     }
//   }
// }
