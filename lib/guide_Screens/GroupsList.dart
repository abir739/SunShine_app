import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zenify_app/guide_Screens/Book_Travelers.dart';
import 'package:zenify_app/login/Login.dart';
import 'package:zenify_app/modele/touristGroup.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zenify_app/services/constent.dart';

class GroupsList extends StatefulWidget {
  const GroupsList({Key? key}) : super(key: key);

  @override
  _GroupsListState createState() => _GroupsListState();
}

class _GroupsListState extends State<GroupsList> {
  List<TouristGroup> _touristGroups = [];
  List<TouristGroup> _filteredGroups = []; // New list for filtered groups
  bool _isLoading = true;
  TextEditingController _searchController =
      TextEditingController(); // Controller for the search bar

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    // Check if data is cached
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString("cachedData");

    if (cachedData != null) {
      // If cached data exists, use it
      setState(() {
        _touristGroups = jsonDecode(cachedData)
            .map<TouristGroup>((groupData) => TouristGroup.fromJson(groupData))
            .toList();
        _isLoading = false;
      });
    }

    String? token = await storage.read(key: "access_token");
    String formatter(String url) {
      return baseUrls + url;
    }

    String url = formatter("/api/tourist-groups/");

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

      // Cache the fetched data
      prefs.setString("cachedData", jsonEncode(_touristGroups));

      setState(() {
        _isLoading = false;
      });
    } else {
      print("Error fetching tourist groups: ${response.statusCode}");
      // Handle error here
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Method to filter groups based on search query
  void _filterGroups(String query) {
    if (query.isEmpty) {
      // If the query is empty, show all groups
      setState(() {
        _isLoading = false;
      });
    } else {
      // Filter groups based on the query
      setState(() {
        _touristGroups = _touristGroups
            .where((group) =>
                group.name?.toLowerCase().contains(query.toLowerCase()) ??
                false)
            .toList();
        _isLoading = false;
      });
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
              child: Column(
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/Users_3.svg',
                        fit: BoxFit.cover,
                        height: 33.0,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "All Groups",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10), // Add some space below the row
                  TextField(
                    controller: _searchController,
                    onChanged: _filterGroups,
                    decoration: InputDecoration(
                      hintText: 'Search groups',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ],
              ),
            ),
            _isLoading
                ? CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: _touristGroups.length,
                      itemBuilder: (context, index) {
                        final group = _touristGroups[index];

                        return Container(
                          width: 330,
                          height: 120,
                          margin: const EdgeInsets.only(
                              top: 16, left: 16, right: 16),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 240, 218, 216),
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
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 8), // Add some space here
                                Text(
                                  "Arrival Date: ${group.arrivalDate}",
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 8, 8, 8),
                                  ),
                                ),
                              ],
                            ),
                            trailing: Checkbox(
                              value: group.confirmed ??
                                  false, // You should have isSelected property in your TouristGroup class
                              onChanged: (bool? value) {
                                // Handle the checkbox state change here
                                // You might want to update the isSelected property in your TouristGroup class
                                // or handle the state in your widget depending on your data structure.
                              },
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
