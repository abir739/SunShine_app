import 'dart:convert';
import 'package:http/http.dart' as http;
import '../modele/activitsmodel/activitesmodel.dart';
class HTTPHandler {
  String baseurl = "https://jsonplaceholder.typicode.com/photos";

  Future<List<Activity>> fetchData(String url) async {
    List<Activity> activityList = [];
    url = formater(url);
    final respond = await http.get(Uri.parse(url));
    if (respond.statusCode == 200 || respond.statusCode == 201) {
      var data = jsonDecode(respond.body);

      final List result = json.decode(respond.body);
      return result.map((e) => Activity.fromJson(e)).toList();
    } else {
      throw Exception('${respond.statusCode}');
    }
  }

  String formater(String url) {
    return baseurl + url;
  }
}
