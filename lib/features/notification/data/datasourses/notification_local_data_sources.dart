import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:SunShine/core/error/exceptions.dart';
import 'package:SunShine/features/notification/data/model/pushnotificationmodel.dart';

abstract class NotificationLocalDataSours {
  Future<List<NotificationModel>> getCachedNotification();
  Future<Unit> cachedNotification(List<NotificationModel> notificationModels);
}

// const Cachec
class NotificationLocalDataSoursImpl implements NotificationLocalDataSours {
  final SharedPreferences sharedPreferences;

  NotificationLocalDataSoursImpl({required this.sharedPreferences});
  @override
  Future<Unit> cachedNotification(List<NotificationModel> notificationModels) {
    //List notificationModelsTojson=notificationModels.map<Map<String,dynamic>>((notificationModelse))=>notificationModels.).toList();
    final List<Map<String, dynamic>> notificationModelsToJson =
        notificationModels.map((model) => model.toJson()).toList();
    sharedPreferences.setString(
        "CachedNotification", json.encode(notificationModelsToJson));
    // TODO: Implement storing the notificationModelsToJson in your local storage.
    // You might use a database or shared preferences for this.

    return Future.value(unit); // Return success
  }

  @override
  Future<List<NotificationModel>> getCachedNotification() {
    final jsonString = sharedPreferences.getString("CachedNotification");
    if (jsonString != null) {
      List decodeJsonData = json.decode(jsonString);
      List<NotificationModel> jsonToNotifications = decodeJsonData
          .map((jsonToNotification) =>
              NotificationModel.fromJson(jsonToNotification))
          .toList();
      return Future.value(jsonToNotifications);
    } else {
      throw EmptyCachExeption();
    }
    // TODO: implement getCachedNotification
    throw UnimplementedError();
  }
}
