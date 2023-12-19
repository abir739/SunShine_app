import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zenify_app/guide_Screens/travelers_list_screen.dart';
import 'package:zenify_app/login/Login.dart';
import 'package:zenify_app/services/constent.dart';
import 'dart:convert';
import 'package:zenify_app/modele/touristGroup.dart';
import 'package:flutter_svg/svg.dart';

class TravellersListScreen extends StatefulWidget {
  final String? guideId;

  const TravellersListScreen({super.key, required this.guideId});

  @override
  // ignore: library_private_types_in_public_api
  _TravellersListScreenState createState() => _TravellersListScreenState();
}

class _TravellersListScreenState extends State<TravellersListScreen> {
  List<TouristGroup> _touristGroups = [];
  final List<Color> backgroundColors = [
    const Color(0xFF3A355733),
    const Color(0xFFEB5F52),
    const Color.fromARGB(255, 255, 197, 192),
    const Color.fromARGB(57, 155, 162, 155),
  ];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    String? token = await storage.read(key: "access_token");
    String formatter(String url) {
      return baseUrls + url;
    }

    String url =
        formatter("/api/tourist-groups/touristGuideId/${widget.guideId}");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> results = data["results"];
      _touristGroups =
          results.map((groupData) => TouristGroup.fromJson(groupData)).toList();
      setState(() {});
    } else {
      print("Error fetching tourist groups: ${response.statusCode}");
      // Handle error here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/Users_3.svg',
                    fit: BoxFit.cover,
                    height: 33.0,
                  ), 
                  SizedBox(width: 10), 
                  Text(
                    "Your Groups",
                    style: TextStyle(
                      fontSize: 24, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _touristGroups.length,
                itemBuilder: (context, index) {
                  final group = _touristGroups[index];

                  // Generate a random index to select a background color
                  final randomColor = backgroundColors[Random().nextInt(
                      backgroundColors.length)]; // Adjust the index based on the number of colors you have

                  return Container(
                    width: 335, 
                    height: 86, 
                    margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
                    decoration: BoxDecoration(
                      color:
                          randomColor, 
                      borderRadius:
                          BorderRadius.circular(10), 
                    ),
                    child: ListTile(
                      title: Text(
                        group.name ?? "N/A",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 8, 8, 8), 
                        ),
                      ),
                      subtitle: Text(
                        "Arrival Date: ${group.arrivalDate}",
                        style: const TextStyle(
                          color: Color.fromARGB(255, 8, 8, 8), 
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TravelersListScreen(
                              selectedtouristGroupId: group.id,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
