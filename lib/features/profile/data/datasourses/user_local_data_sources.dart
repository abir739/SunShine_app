import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:SunShine/core/error/exceptions.dart';
import 'package:SunShine/features/notification/data/model/pushnotificationmodel.dart';
import 'package:SunShine/features/profile/data/model/usersmodel.dart';

abstract class UserLocalDataSours {
  Future<UserModel> getCachedUser();
  Future<Unit> cachedNotification(UserModel userModel);
}

// const Cachec
class UserLocalDataSoursImpl implements UserLocalDataSours {
  final SharedPreferences sharedPreferences;

  UserLocalDataSoursImpl({required this.sharedPreferences});
  @override
  Future<Unit> cachedNotification(UserModel userModel) async {
    final Map<String, dynamic> notificationModelToJson = userModel.toJson();
    sharedPreferences.setString(
        "Cacheduser", json.encode(notificationModelToJson));
    // TODO: Implement storing the notificationModelToJson in your local storage.
    // You might use a database or shared preferences for this.

    return Future.value(unit); // Return success
  }

  @override
  Future<UserModel> getCachedUser() {
    final jsonString = sharedPreferences.getString("Cacheduser");
    if (jsonString != null) {
      final Map<String, dynamic> decodeJsonData = json.decode(jsonString);
      final UserModel jsonToUser = UserModel.fromJson(decodeJsonData);

      return Future.value(jsonToUser);
    } else {
      throw EmptyCachExeption();
    }
    // TODO: implement getCachedNotification
    throw UnimplementedError();
  }
}
