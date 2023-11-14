import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;


import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:zenify_app/modele/tasks/taskModel.dart';
import 'package:zenify_app/services/constent.dart';




class HTTPHandlerTasks {

  // String baseurl = "https://jsonplaceholder.typicode.com/photos";
  // String baseurlA = "https://api.zenify-trip.continuousnet.com/api/";
  String baseurlA = "http://192.168.1.23:3000/api/";
  String baseurlp = "https://api.zenify-trip.continuousnet.com/api/plannings";
  final storage = const FlutterSecureStorage();
  Future<List<Tasks>> fetchData(String url) async {
    // String? baseUrl = await storage.read(key: "baseurl");
    // String token = await storage.read( key: 'access_token');
    List<Tasks> tasks = [];
    // String formater(String baseurl, String url) {
    //   print(baseurl + url);
    //   print(" urllllllllllllllllllllllllllll");
    //   return baseurl + url;
    // }

    // url = formater(baseUrl, url);
    String? token = await storage.read(key: 'access_token');

// await storage.read(key: "baseurl");
    // List<TouristGroup> touristGroup = [];
    String formater(String url) {
      return baseUrls + url;
    }

    url = formater(url);
    final respond = await http.get(headers: {
      "Authorization":
          "Bearer $token" ,
      "Accept": "application/json, text/plain, */*",
      "Accept-Encoding": "gzip, deflate, br",
      "Accept-Language": "en-US,en;q=0.9",
       }, Uri.parse(url));
    print(respond.statusCode);
    if (respond.statusCode == 200) {
    
      final data = json.decode(respond.body);

      final List r = data["results"];
    





      return r.map((e) => Tasks.fromJson(e)).toList();

    } else {
   
      throw Exception('${respond.statusCode}');

    }
  }

  // String formater(String url) {
  //   return baseurlA + url;
  // }
}
class HTTPHandlerCount {
  final storage = const FlutterSecureStorage();

  Future<int> fetchInlineCount(String url) async {
    String? token = await storage.read(key: "access_token");
    String baseUrl ="https://api.zenify-trip.continuousnet.com" ;
// await storage.read(key: "baseurl");
    String formater(String url) {
      // if (baseUrl != null) {
        return baseUrls + url;
      // } else {
      //   return 'https://api.zenify-trip.continuousnet.com';
      // }
    }

    url = formater(url);

    // url = formater(baseUrl, url);
    // List<Agency> agancy = [];
    // url = formater(url);
    final respond = await http
        .get(headers: {"Authorization": "Bearer $token"}, Uri.parse(url));
    print(respond.statusCode);

    if (respond.statusCode == 200) {
      final data = json.decode(respond.body);
      final int inlineCount = data["inlineCount"];
      return inlineCount;
    } else {
      throw Exception(
          'Failed to fetch inline count. Status code: ${respond.statusCode}');
    }
  }
}
