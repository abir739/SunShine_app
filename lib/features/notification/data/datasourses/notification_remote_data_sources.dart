import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:zenify_app/core/error/exceptions.dart';
import 'package:zenify_app/features/notification/data/model/pushnotificationmodel.dart';
import 'package:zenify_app/login/Login.dart';

abstract class NotificationRemoteDataSours {
  Future<List<NotificationModel>> getAllNotification(int? index);
  Future<Unit> deletNotification(String notificationId);
  Future<Unit> UpdateNotification(NotificationModel notificationModel);
  Future<Unit> addNotification(NotificationModel notificationModel);
}

const BASE_URL = "https://api.zenify-trip.continuousnet.com";

class NotificationRemoteImplementwithHttp
    implements NotificationRemoteDataSours {
  final http.Client client;

  NotificationRemoteImplementwithHttp({required this.client});
  @override
  Future<List<NotificationModel>> getAllNotification(int? index) async {
      
    String? token = await storage.read(key: 'access_token');
      print("Bearer $token");
    final response = await client.get(
        Uri.parse(BASE_URL + "/api/push-notifications?limit=$index"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json, text/plain, */*",
          "Accept-Encoding": "gzip, deflate, br",
          "Accept-Language": "en-US,en;q=0.9",
        });
     
    if (response.statusCode == 200) {
      print(response.statusCode);

      final data = json.decode(response.body);
      final List results = data["results"];

      final List<NotificationModel> notifications =
          results.map((e) => NotificationModel.fromJson(e)).toList();
      // return Future.value(notifications);
      return notifications;
    } else {
      throw ServerExeption();
    }
  }

  @override
  Future<Unit> addNotification(NotificationModel notificationModel) async {
    final body = {
      "message": notificationModel.message,
      // "firstName": notificationModel.firstName,
      // "picture": notificationModel.picture,
      "title": notificationModel.title,
      // "type": notificationModel.type,
    };   print("Bearer");
    String? token = await storage.read(key: 'access_token');
       print("Bearer $token");
    final response = await client.post(
        Uri.parse(BASE_URL +"/api/push-notifications"),
        body: body,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json, text/plain, */*",
          "Accept-Encoding": "gzip, deflate, br",
          "Accept-Language": "en-US,en;q=0.9",
        });
    print("Bearer $token");
    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.statusCode);
      print("response.statusCode");
      print("response.statusCode");
      print("response.statusCode");
      return Future.value(unit);
    } else {
      print("response.statusCode");
      print("response.statusCode");
      print("response.statusCode");
      throw ServerExeption();
    }
  }

  @override
  Future<Unit> UpdateNotification(NotificationModel notificationModel) async {
    final notificationid = notificationModel.id.toString();
    final body = {
      "message": notificationModel.message,
      // "firstName": notificationModel.firstName,
      // "picture": notificationModel.picture,
      "title": notificationModel.title,
      // "type": notificationModel.type,
    };
    String? token = await storage.read(key: 'access_token');
        print("Bearer $token");
    final response = await client.patch(
        Uri.parse(BASE_URL + "/api/push-notifications/$notificationid"),
        body: body,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json, text/plain, */*",
          "Accept-Encoding": "gzip, deflate, br",
          "Accept-Language": "en-US,en;q=0.9",
        });
    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.statusCode);

      return Future.value(unit);
    } else {
      throw ServerExeption();
    }
  }

  @override
  Future<Unit> deletNotification(String notificationId) async {
    String? token = await storage.read(key: 'access_token');
    final response = await client.delete(
        Uri.parse(BASE_URL + "/api/push-notifications/$notificationId"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json, text/plain, */*",
          "Accept-Encoding": "gzip, deflate, br",
          "Accept-Language": "en-US,en;q=0.9",
        });
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 204) {
      print(response.statusCode);

      return Future.value(unit);
    } else {
      throw ServerExeption();
    }
  }
}

// class NotificationRemoteImplementWithDio
//     implements NotificationRemoteDataSours {
//   @override
//   Future<Unit> UpdateNotification(NotificationModel notificationModel) {
//     // TODO: implement UpdateNotification
//     throw UnimplementedError();
//   }

//   @override
//   Future<Unit> addNotification(NotificationModel notificationModel) {
//     // TODO: implement addNotification
//     throw UnimplementedError();
//   }

//   @override
//   Future<Unit> deletNotification(String notificationId) {
//     // TODO: implement deletNotification
//     throw UnimplementedError();
//   }

//   @override
//   Future<List<NotificationModel>> getAllNotification() {
//     // TODO: implement getAllNotification
//     throw UnimplementedError();
//   }
// }
