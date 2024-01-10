import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:SunShine/modele/traveller/TravellerModel.dart';
import 'package:SunShine/services/constent.dart';

import 'activitsmodel/commentmodel.dart';
import 'agance.dart';

class HTTPHandleTravellers {
  final storage = const FlutterSecureStorage();
  String? token = "";
  Future<List<Traveller>> fetchData(String url) async {
    String? token = await storage.read(key: "access_token");
    String? baseUrl = await storage.read(key: "baseurl");
    String formater(String url) {
      return baseUrls + url;
    }

    url = formater(url);
    final respond = await http.get(headers: {
      "Authorization": "Bearer $token",
      "Accept": "application/json, text/plain, */*",
      "Accept-Encoding": "gzip, deflate, br",
      "Accept-Language": "en-US,en;q=0.9",
      "Connection": "keep-alive",
    }, Uri.parse(url));
    print(respond.statusCode);
    if (respond.statusCode == 200) {
      final data = json.decode(respond.body);

      final List r = data["results"];
      return r.map((e) => Traveller.fromJson(e)).toList();
    } else {
      throw Exception('${respond.statusCode}');
    }
  }
}

class HTTPHandlerCommentCount {
  final storage = const FlutterSecureStorage();
  Future<int> fetchInlineCount(String url) async {
    String? token = await storage.read(key: "access_token");
    String? baseUrl = await storage.read(key: "baseurl");
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
