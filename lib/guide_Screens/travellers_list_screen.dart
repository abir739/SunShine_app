import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:SunShine/guide_Screens/travelers_list_screen.dart';
import 'package:SunShine/login/Login.dart';
import 'package:SunShine/services/GuideProvider.dart';
import 'package:SunShine/services/constent.dart';
import 'dart:convert';
import 'package:SunShine/modele/touristGroup.dart';
import 'package:flutter_svg/svg.dart';

class TravellersListScreen extends StatefulWidget {
  const TravellersListScreen({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _TravellersListScreenState createState() => _TravellersListScreenState();
}

class _TravellersListScreenState extends State<TravellersListScreen> {
  List<TouristGroup> _touristGroups = [];
  final List<Color> backgroundColors = [
    const Color.fromARGB(57, 155, 162, 155),
  ];
  String? guideid;
  @override
  void initState() {
    super.initState();
    _initializeGuideData();
  }

  Future<void> _initializeGuideData() async {
    final travelerProvider = Provider.of<guidProvider>(context, listen: false);

    try {
      final result = await travelerProvider.loadDataGuid();
      print("result");
      setState(() {
        guideid = result;
      });
    } catch (error) {
      // Handle the error as needed
      print("Error initializing traveler data: $error");
    }

    try {
      fetchData();
    } catch (e) {}
  }

  Future<void> fetchData() async {
    String? token = await storage.read(key: "access_token");
    String formatter(String url) {
      return baseUrls + url;
    }

    String url = formatter("/api/tourist-groups/touristGuideId/${guideid}");

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
                    "Mes groupes",
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
                      backgroundColors
                          .length)]; // Adjust the index based on the number of colors you have

                  return Container(
                    width: 335,
                    height: 86,
                    margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
                    decoration: BoxDecoration(
                      color: randomColor,
                      borderRadius: BorderRadius.circular(10),
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
                        "Date d'arrivée: ${group.arrivalDate}",
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
