import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:SunShine/guide_Screens/Book_Travelers.dart';

import 'package:SunShine/login/Login.dart';
import 'package:SunShine/services/constent.dart';
import 'dart:convert';
import 'package:SunShine/modele/touristGroup.dart';
import 'package:flutter_svg/svg.dart';

class GroupsList extends StatefulWidget {
  const GroupsList({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _GroupsListState createState() => _GroupsListState();
}

class _GroupsListState extends State<GroupsList> {
  List<TouristGroup> _touristGroups = [];
  List<TouristGroup> _filteredGroups = [];
  TextEditingController searchController = TextEditingController();

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
      setState(() {});
    } else {
      print("Error fetching tourist groups: ${response.statusCode}");
      // Handle error here
    }
  }

  void filterGroups(String query) {
    print("Query: $query");
    _filteredGroups = _touristGroups
        .where((group) =>
            group.name?.toLowerCase().contains(query.toLowerCase()) ?? false)
        .toList();
    print("Filtered Groups: $_filteredGroups");
    setState(() {});
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  SizedBox(height: 16),
                  TextField(
                    controller: searchController,
                    onChanged:
                        filterGroups, // Make sure this is triggering the filterGroups method
                    decoration: InputDecoration(
                      labelText: 'Search by group name',
                      prefixIcon: Icon(Icons.search),
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

                  return Container(
                    width: 330,
                    height: 120,
                    margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
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
