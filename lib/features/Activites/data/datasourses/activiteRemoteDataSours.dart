import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:zenify_app/core/error/exceptions.dart';
import 'package:zenify_app/features/Activites/data/model/activitesmodel.dart';
import 'package:zenify_app/features/notification/data/model/pushnotificationmodel.dart';
import 'package:zenify_app/login/Login.dart';

abstract class ActiviteRemoteDataSours {
  Future<List<ActivityModel>> getAllActivities();
  Future<Unit> deletActivities(String notificationId);
  Future<Unit> UpdateActivities(ActivityModel activitesModel);
  Future<Unit> addActivities(ActivityModel activitesModel);
}

const BASE_URL = "https://api.zenify-trip.continuousnet.com";

class ActiviteRemoteDataSoursImplementwithHttp
    implements ActiviteRemoteDataSours {
  final http.Client client;

  ActiviteRemoteDataSoursImplementwithHttp({required this.client});
  @override
  Future<List<ActivityModel>> getAllActivities() async {
    String? token = await storage.read(key: 'access_token');
    final response =
        await client.get(Uri.parse(BASE_URL + "/api/activities"), headers: {
          "Authorization": "Bearer $token",

      "Accept": "application/json, text/plain, */*",
      "Accept-Encoding": "gzip, deflate, br",
      "Accept-Language": "en-US,en;q=0.9",
    });
    if (response.statusCode == 200) {
      print(response.statusCode);

      final data = json.decode(response.body);
      final List results = data["results"];

      final List<ActivityModel> activites =
          results.map((e) => ActivityModel.fromJson(e)).toList();
          print("Activitesitem ${activites[0].activityTemplate?.id}");
      // return Future.value(notifications);
      return activites;
    } else {
      throw ServerExeption();
    }
  }

  @override
  Future<Unit> addActivities(ActivityModel activitesodel) async {
    final body = {
      "adultPrice": activitesodel.adultPrice,
      "activityTemplateId": activitesodel.activityTemplateId,
      "babyPrice": activitesodel.babyPrice,
      "childPrice": activitesodel.childPrice,
      "name": activitesodel.name,
      "departureDate": activitesodel.departureDate,
      "returnDate": activitesodel.returnDate,
      "departureNote": activitesodel.departureNote,
    };
    String? token = await storage.read(key: 'access_token');
    final response = await client
        .post(Uri.parse(BASE_URL + "/api/activities"), body: body, headers: {
      "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImUxMWU0N2FhLTE5YzgtNDM5Mi1hMGEyLTkwN2NmYTg0MzM4OCIsInN1YiI6ImUxMWU0N2FhLTE5YzgtNDM5Mi1hMGEyLTkwN2NmYTg0MzM4OCIsInVzZXJuYW1lIjoic2E3Ym9vY2gzIiwiZW1haWwiOiJzYTdib29jaDNAZ21haWwuY29tIiwicm9sZSI6IkFkbWluaXN0cmF0b3IiLCJmaXJzdE5hbWUiOiJTYWhiaSIsInBob25lIjpudWxsLCJsYXN0TmFtZSI6IktoYWxmYWxsYWgiLCJleHBpcmVzIjoxNzAwOTIxMDg3LCJjcmVhdGVkIjoxNzAwODM0Njg3LCJpYXQiOjE3MDA4MzQ2ODcsImV4cCI6MTcwMDkyMTA4N30.bwa_Dh-CXs5roeQCJsLK7jiJrmzTND-1qLcD2rt_qs8",
      "Accept": "application/json, text/plain, */*",
      "Accept-Encoding": "gzip, deflate, br",
      "Accept-Language": "en-US,en;q=0.9",
    });
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
  Future<Unit> UpdateActivities(ActivityModel activitesodel) async {
    final activitesid = activitesodel.id.toString();
    final body = {
   "adultPrice": activitesodel.adultPrice,
      "activityTemplateId": activitesodel.activityTemplateId,
      "babyPrice": activitesodel.babyPrice,
      "childPrice": activitesodel.childPrice,
      "name": activitesodel.name,
      "departureDate": activitesodel.departureDate,
      "returnDate": activitesodel.returnDate,
      "departureNote": activitesodel.departureNote,
    };
    String? token = await storage.read(key: 'access_token');
    final response = await client
        .patch(Uri.parse(BASE_URL + "/api/activities$activitesid"), body: body, headers: {
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
  Future<Unit> deletActivities(String activitesId) async {
    String? token = await storage.read(key: 'access_token');
    final response = await client.delete(
        Uri.parse(BASE_URL + "/api/activities/$activitesId"),
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

// class ActiviteRemoteDataSoursImplementWithDio
//     implements ActiviteRemoteDataSours {
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
