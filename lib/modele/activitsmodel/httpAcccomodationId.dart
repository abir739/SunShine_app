import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:SunShine/modele/accommodationsModel/accommodationModel.dart';
import 'package:SunShine/modele/activitsmodel/activitesmodel.dart';
import 'package:SunShine/modele/planning_model.dart';
import 'package:SunShine/modele/planningmainModel.dart';
import 'package:SunShine/modele/plannings.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../services/constent.dart';
import 'activityTempModel.dart';

class HTTPHandlerAccomodationId {
  final storage = const FlutterSecureStorage();
  Future<Accommodations> fetchData(String url) async {
    String? baseUrl = await storage.read(key: "baseurl");
    String? token = await storage.read(key: 'access_token');

    // String formater(String baseurl, String url) {
    //   print(baseurl + url);
    //   print(" urllllllllllllllllllllllllllll");
    //   return baseurl + url;
    // }

    // url = formater(baseUrl, url);
    String formater(String url) {
      return baseUrls + url;
    }

    url = formater(url);
    final respond = await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer $token",
    });

    print(respond.statusCode);
    if (respond.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // var data = jsonDecode(respond.body);
      // print(data);
      // final touristGuideName = data["results"]["agency"];
      // print(touristGuideName);

      final data = json.decode(respond.body);
      return Accommodations.fromJson(data);
    } else {
      throw Exception('${respond.statusCode}');
    }
  }

  // String formater(String url) {
  //   return baseurlA + url;
  // }
}
