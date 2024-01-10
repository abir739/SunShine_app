import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:SunShine/Secreens/Activities-Category/Activity-Template-List.dart';
import 'package:SunShine/login/Login.dart';
import 'package:SunShine/modele/activitsmodel/activitiesCategoryModel.dart';
import 'package:SunShine/services/constent.dart';

class ActivityCategoryPage extends StatefulWidget {
  @override
  _ActivityCategoryPageState createState() => _ActivityCategoryPageState();
}

class _ActivityCategoryPageState extends State<ActivityCategoryPage> {
  late List<ActivitiesCategoryModel> activityCategories;
  late List<ActivitiesCategoryModel> filteredCategories;
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    activityCategories = [];
    filteredCategories = [];
    fetchActivityCategories();
  }

  void navigateToActivityTemplatePage(ActivitiesCategoryModel category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActivityTemplatePage(category: category),
      ),
    );
  }

  Future<void> fetchActivityCategories() async {
    String? token = await storage.read(key: "access_token");
    String formatter(String url) {
      return baseUrls + url;
    }

    String url = formatter("/api/activity-categories");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> results = data["results"];
      activityCategories = results
          .map((groupData) => ActivitiesCategoryModel.fromJson(groupData))
          .toList();

      // Initially, set filteredCategories to all categories
      filteredCategories = List.from(activityCategories);

      // Update the data source
      setState(() {});
    } else {
      print('Failed to load activity categories');
    }
  }

  void filterCategories(String query) {
    setState(() {
      filteredCategories = activityCategories
          .where((category) =>
              category.name?.toLowerCase().contains(query.toLowerCase()) ??
              false)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: size.width,
                    height: size.height * 0.1,
                    alignment: Alignment.center,
                    child: TextField(
                      controller: searchController,
                      onChanged: (query) {
                        filterCategories(query);
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.arrow_back_ios_new_sharp,
                          color: Colors.black,
                        ),
                        hintText: "Recherche",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(width: 2),
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  'Catégories',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 1, 1, 1),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: (filteredCategories.length / 4).ceil(),
                    itemBuilder: (context, rowIndex) {
                      final start = rowIndex * 4;
                      final end = (rowIndex + 1) * 4;
                      final currentCategories = filteredCategories.sublist(
                        start,
                        min(end, filteredCategories.length),
                      );

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (final category in currentCategories)
                            Container(
                              width: MediaQuery.of(context).size.width / 4,
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      navigateToActivityTemplatePage(category);
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: const Color.fromARGB(
                                          255, 235, 235, 202),
                                      radius: 40,
                                      backgroundImage: NetworkImage(
                                        "${baseUrls}${category.icon}",
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    category.name ?? '',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
