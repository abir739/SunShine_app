import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zenify_app/core/error/exceptions.dart';
import 'package:zenify_app/features/Activites/data/model/activitesmodel.dart';
import 'package:zenify_app/features/notification/data/model/pushnotificationmodel.dart';

abstract class ActiviteRLocalDataSours {
  Future<List<ActivityModel>> getCachedActivity();
  Future<Unit> cachedActivity(List<ActivityModel> activitymodel);
}
// const Cachec
class ActiviteLocalDataSoursImpl implements ActiviteRLocalDataSours {
  final SharedPreferences sharedPreferences;

ActiviteLocalDataSoursImpl({required this.sharedPreferences});
  @override
  Future<Unit> cachedActivity(List<ActivityModel> activitesModels) {
    //List notificationModelsTojson=notificationModels.map<Map<String,dynamic>>((notificationModelse))=>notificationModels.).toList();
    final List<Map<String, dynamic>> activitesModelsToJson =
        activitesModels.map((model) => model.toJson()).toList();
    sharedPreferences.setString(
        "CachedActivity", json.encode(activitesModelsToJson));
    // TODO: Implement storing the notificationModelsToJson in your local storage.
    // You might use a database or shared preferences for this.

    return Future.value(unit); // Return success
  }

  @override
  Future<List<ActivityModel>> getCachedActivity() {
    final jsonString = sharedPreferences.getString("CachedActivity");
    if (jsonString != null) {
      List decodeJsonData = json.decode(jsonString);
      List<ActivityModel> jsonToActivites = decodeJsonData
          .map((jsonToActivites) =>
              ActivityModel.fromJson(jsonToActivites))
          .toList();
      return Future.value(jsonToActivites);
    } else {
      throw EmptyCachExeption();
    }
    // TODO: implement getCachedNotification
    throw UnimplementedError();
  }
}
