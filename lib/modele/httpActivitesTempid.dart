import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/constent.dart';
import 'activitsmodel/activityTempModel.dart';

class HTTPHandlerActivitestempId {
  final storage = const FlutterSecureStorage();
  Future<ActivityTemplate> fetchData(String url) async {
    String? baseUrl = await storage.read(key: "baseurl");
    String? token = await storage.read(key: 'access_token');
    String formater(String url) {
      return baseUrls + url;
    }

    url = formater(url);
    final respond =  await http.get(Uri.parse(url), headers: {"Authorization": "Bearer $token"});
    print(respond.statusCode);
    if (respond.statusCode == 200) {
      final data = json.decode(respond.body);
      return ActivityTemplate.fromJson(data);
    } else {
      throw Exception('${respond.statusCode}');
    }
  }
}
