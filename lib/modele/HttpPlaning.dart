import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/constent.dart';
import '../modele/planningmainModel.dart';
class HTTPHandlerplaning {
  final storage = const FlutterSecureStorage();
  Future<List<PlanningMainModel>> fetchData(String url) async {
    String? token = await storage.read(key: 'access_token');
    String baseUrl = "https://api.zenify-trip.continuousnet.com";
    String formater(String url) {
      return baseUrls + url;
    }

    url = formater(url);
    final respond = await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer $token",
      "Accept": "application/json, text/plain, */*",
      "Accept-Encoding": "gzip, deflate, br",
      "Accept-Language": "en-US,en;q=0.9",
      "Connection": "keep-alive",
    });

    print(respond.statusCode);
    if (respond.statusCode == 200) {
      final data = json.decode(respond.body);
      final List r = data["results"];
      return r.map((e) => PlanningMainModel.fromJson(e)).toList();
    } else {
      throw Exception('${respond.statusCode}');
    }
  }
}
