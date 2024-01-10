import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:SunShine/guide_Screens/TravelerProfileScreen.dart';
import 'package:SunShine/login/Login.dart';
import 'package:SunShine/services/constent.dart';

import 'package:SunShine/modele/traveller/TravellerModel.dart';
import 'package:url_launcher/url_launcher.dart';

class TravelersListScreen extends StatefulWidget {
  final String? selectedtouristGroupId;

  const TravelersListScreen({super.key, required this.selectedtouristGroupId});

  @override
  _TravelersListScreenState createState() => _TravelersListScreenState();
}

class _TravelersListScreenState extends State<TravelersListScreen> {
  List<Traveller> _travelers = [];

  @override
  void initState() {
    super.initState();
    fetchTravelersData();
  }

  Future<void> fetchTravelersData() async {
    String? token = await storage.read(key: "access_token");
    String formatter(String url) {
      return baseUrls + url;
    }

    String url = formatter(
        "/api/travellers?filters[touristGroupId]=${widget.selectedtouristGroupId}");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final List<dynamic> results = responseData["results"];
      final List<Traveller> fetchedTravellers =
          results.map((data) => Traveller.fromJson(data)).toList();
      setState(() {
        _travelers = fetchedTravellers;
      });
    } else {
      print("Error fetching travelers data: ${response.statusCode}");
      // Handle error here
    }
  }

  void _navigateToProfile(Traveller traveler) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TravelerProfileScreen(traveler: traveler),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 60.0),
            Text('Liste des voyageurs'),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10.0),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const SizedBox(width: 5.0),
              const SizedBox(width: 4.0),
            ],
          ),
          const SizedBox(height: 17.0),
          Expanded(
            child: ListView.builder(
              itemCount: _travelers.length,
              itemBuilder: (context, index) {
                final traveler = _travelers[index];
                bool isChecked =
                    false; // Add a boolean variable to track the checkbox state

                return GestureDetector(
                  onTap: () {
                    _navigateToProfile(traveler); // Navigate to profile screen
                  },
                  child: Slidable(
                    startActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      extentRatio: 0.25,
                      children: [
                        SlidableAction(
                          label: 'Call',
                          backgroundColor:
                              const Color.fromARGB(255, 27, 97, 39),
                          icon: Icons.phone,
                          onPressed: (context) async {
                            Uri phoneNumber =
                                Uri.parse('tel:${traveler.user!.phone}');
                            if (await launchUrl(phoneNumber)) {
                              //dialer opened
                            } else {
                              //dailer is not opened
                            }
                          },
                        ),
                      ],
                    ),
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      extentRatio: 0.25,
                      children: [
                        SlidableAction(
                          label: 'Delete',
                          backgroundColor: Colors.red,
                          icon: Icons.delete,
                          onPressed: (context) {
                            // Handle delete action
                            setState(() {
                              _travelers.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                    child: Card(
                      elevation:
                          4, // Add some elevation for a card-like appearance
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8), // Adjust margins
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Checkbox(
                              value: isChecked,
                              onChanged: (value) {
                                setState(() {
                                  isChecked = value!;
                                });
                              },
                            ),
                            Expanded(
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: traveler.user!.picture !=
                                          null
                                      ? NetworkImage(
                                          "${traveler.user!.picture}")
                                      : null, // Use null if there is no picture
                                  radius:
                                      40, // Increase the radius for a bigger profile picture
                                  child: traveler.user!.picture == null
                                      ? Text(
                                          '${traveler.user!.firstName?[0]}${traveler.user!.lastName?[0]}',
                                          style: const TextStyle(
                                              fontSize: 24,
                                              color: Colors.white),
                                        ) // Display initials if no picture
                                      : null, // Use null if there is a picture
                                ),
                                title: Text(
                                  '${traveler.user!.firstName} ${traveler.user!.lastName}',
                                  style: const TextStyle(
                                      fontSize: 18), // Increase the font size
                                ),
                                subtitle: Text(
                                  ' Code: ${traveler.code}',
                                  style: const TextStyle(
                                    fontSize: 14, // Increase the font size
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
