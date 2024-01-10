import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/constent.dart';
import 'agance.dart';
class HTTPHandlerAgancy {
  final storage = const FlutterSecureStorage();
  String? token = "";
  Future<List<Agency>> fetchData(String url) async {
    String? token = await storage.read(key: "access_token");
    String? baseUrl = await getBaseUrl();
    String formater(String url) {
      if (baseUrl!.isEmpty) {
        return baseUrls + url;
      } else {
        return "$baseUrl/api/agencies"; // Use the baseUrls from constants.dart
      }
    }
    if (baseUrl != null) {}
    final respond =  await http.get(Uri.parse(url), headers:  {"Authorization": "Bearer $token",   "Accept": "application/json, text/plain, */*",
      "Accept-Encoding": "gzip, deflate, br",
      "Accept-Language": "en-US,en;q=0.9",
      "Connection": "keep-alive",});
    print(respond.statusCode);
    if (respond.statusCode == 200) {
      final data = json.decode(respond.body);

      final List r = data["results"];
      print("----------------------------------------------");
      print(r[0]["id"]);
      print("----------------------------------------------");
      return r.map((e) => Agency.fromJson(e)).toList();
    } else {
      throw Exception('${respond.statusCode}');
    }
  }
}
