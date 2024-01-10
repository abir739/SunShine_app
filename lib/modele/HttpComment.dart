import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/constent.dart';
import 'activitsmodel/commentmodel.dart';
class HTTPHandlerComment {
  final storage = const FlutterSecureStorage();
  String? token = "";
  Future<List<Comment>> fetchData(String url) async {
    String? token = await storage.read(key: "access_token");
String? baseUrl = await storage.read(key: "baseurl");
   String formater(String url) {
        return baseUrls + url;
    }

    url = formater(url);
    final respond =  await http.get(Uri.parse(url), headers:  {
      "Authorization":
          "Bearer $token",
      "Accept": "application/json, text/plain, */*",
      "Accept-Encoding": "gzip, deflate, br",
      "Accept-Language": "en-US,en;q=0.9",
      "Connection": "keep-alive",
    });
    print(respond.statusCode);
    if (respond.statusCode == 200) {
      final data = json.decode(respond.body);

      final List r = data["Comments"];
      print("----------------------------------------------");
      print(r[0]["id"]);
      print("----------------------------------------------");

      
      return r.map((e) => Comment.fromJson(e)).toList();
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
    final respond = await http.get(Uri.parse(url), headers:  {"Authorization": "Bearer $token"});
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
