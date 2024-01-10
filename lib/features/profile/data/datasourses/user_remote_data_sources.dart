import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:SunShine/core/error/exceptions.dart';
import 'package:SunShine/features/notification/data/model/pushnotificationmodel.dart';
import 'package:SunShine/features/profile/data/model/usersmodel.dart';
import 'package:SunShine/login/Login.dart';

abstract class UserRemoteDataSours {
  Future<UserModel> getUser(String? index);
  Future<Unit> deletUser(String userid);
  Future<Unit> UpdateUser(UserModel userModel);
  Future<Unit> addUser(UserModel userModel);
}

const BASE_URL = "https://api.zenify-trip.continuousnet.com";

class UserRemoteImplementwithHttp implements UserRemoteDataSours {
  final http.Client client;

  UserRemoteImplementwithHttp({required this.client});
  @override
  Future<UserModel> getUser(String? index) async {
    String? token = await storage.read(key: 'access_token');
    final userId = await storage.read(key: "id");
    print("Bearer $token");
    final response =
        await client.get(Uri.parse(BASE_URL + "/api/users/$userId"), headers: {
      "Authorization": "Bearer $token",
      "Accept": "application/json, text/plain, */*",
      "Accept-Encoding": "gzip, deflate, br",
      "Accept-Language": "en-US,en;q=0.9",
    });

    if (response.statusCode == 200) {
      print(response.statusCode);
      UserModel user = UserModel.fromJson(json.decode(response.body));
      return user;
      // Do something wit
      // final data = json.decode(response.body);
      // final List results = data["results"];

      // final UserModel notifications =
      //     results.map((e) => UserModel.fromJson(e));
      // // return Future.value(notifications);
      // return notifications;
    } else {
      throw ServerExeption();
    }
  }

  @override
  Future<Unit> addUser(UserModel userModel) async {
    final body = {
      "lastName": userModel.lastName,
      // "firstName": notificationModel.firstName,
      // "picture": notificationModel.picture,
      "firstName": userModel.firstName,
      // "type": notificationModel.type,
    };
    print("Bearer");
    String? token = await storage.read(key: 'access_token');

    print("Bearer $token");
    final response = await client
        .post(Uri.parse(BASE_URL + "/api/users"), body: body, headers: {
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
  Future<Unit> UpdateUser(UserModel userModel) async {
    print("cannots updated");
    final userid = userModel.id.toString();
    final body = {
      "firstName": userModel.firstName,
      "lastName": userModel.lastName,
      "birthDate": userModel.birthDate?.toIso8601String(),
      // "address": userModel.address
      //  "email": userModel.email,
      //   // "picture": notificationModel.picture,
      //   "firstName": userModel.firstName,
      // "type": notificationModel.type,
    };
    String? token = await storage.read(key: 'access_token');
    print("Bearer $token");
    final userId = await storage.read(key: "id");
    final response = await client.patch(
        Uri.parse(BASE_URL + "/api/users/$userid"),
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
      print("cannots updated");
      throw ServerExeption();
    }
  }

  @override
  Future<Unit> deletUser(String userid) async {
    String? token = await storage.read(key: 'access_token');
    final response = await client.delete(
        Uri.parse(BASE_URL + "/api/push-notifications/$userid"),
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
