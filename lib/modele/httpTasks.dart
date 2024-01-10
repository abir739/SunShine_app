import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:SunShine/modele/tasks/taskModel.dart';
import 'package:SunShine/services/constent.dart';

class HTTPHandlerTasks {
  String baseurlA = "http://192.168.1.23:3000/api/";
  String baseurlp = "https://api.zenify-trip.continuousnet.com/api/plannings";
  final storage = const FlutterSecureStorage();
  Future<List<Tasks>> fetchData(String url) async {
    List<Tasks> tasks = [];
    String? token = await storage.read(key: 'access_token');
    String formater(String url) {
      return baseUrls + url;
    }

    url = formater(url);
    final respond = await http.get(headers: {
      "Authorization": "Bearer $token",
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
}

class HTTPHandlerCount {
  final storage = const FlutterSecureStorage();

  Future<int> fetchInlineCount(String url) async {
    String? token = await storage.read(key: "access_token");
    String baseUrl = "https://api.zenify-trip.continuousnet.com";
    String formater(String url) {
      return baseUrls + url;
    }

    url = formater(url);
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
