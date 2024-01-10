import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/constent.dart';
import 'activitsmodel/pushnotificationmodel.dart';
class HTTPHandlerNotificationId {
  final storage = const FlutterSecureStorage();

  Future<PushNotification> fetchData(String url) async {
    try {
      final token = await storage.read(key: 'access_token');

      final formattedUrl = '$baseUrls$url'.replaceAll(' ', '');
      print(formattedUrl);
      final response = await http.get(
        Uri.parse(formattedUrl),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
print(response.body);
        // print("dataaaaaaaaaaaa $data");
        return PushNotification.fromJson(data);
      } else {
        throw Exception(
            'Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch data. Error: $e');
    }
  }
}
