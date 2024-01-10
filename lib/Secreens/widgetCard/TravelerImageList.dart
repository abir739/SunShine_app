import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:SunShine/modele/transportmodel/transportModel.dart';
import 'package:SunShine/services/constent.dart';
import 'dart:convert';

class TravelerImageList extends StatelessWidget {
  final List<String> travelerGroupIds;
  final Transport transfer;
  TravelerImageList({required this.travelerGroupIds, required this.transfer});

  Future<List<Map<String, dynamic>>> fetchTravelersByGroupIds(
      List<String> groupIds) async {
    final groupIdsQueryParam = groupIds.map((id) => 'ids=$id').join('&');
    final response = await http.get(
        Uri.parse('${baseUrls}/api/travellers-mobile?$groupIdsQueryParam'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final results = jsonResponse['results'] as List;
      return results.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load travelers');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchTravelersByGroupIds(travelerGroupIds),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return Text('No data available');
        } else {
          final travelers = snapshot.data;
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: travelers!.length,
            itemBuilder: (context, index) {
              final traveler = travelers[index];
              final user = traveler['user'];
              final userImageUrl =
                  "${baseUrls}/assets/uploads/${user['picture']}"; // Replace with the actual URL
              if (transfer.touristGroups!
                  .any((group) => group.id == traveler['touristGroupId'])) {
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(userImageUrl),
                  ),
                );
              } else {
                // If 'touristGroupId' doesn't match any 'id' in the tourist groups, return an empty SizedBox
                return SizedBox.shrink();
              }
            },
          );
        }
      },
    );
  }
}

// Usage
