import 'package:flutter/material.dart';
import 'package:zenify_app/login/Login.dart';
import 'package:zenify_app/modele/activitsmodel/activitiesCategoryModel.dart';
import 'package:zenify_app/modele/activitsmodel/activityTempModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:zenify_app/services/constent.dart';

enum ActivitySort { priceLowToHigh, country, nameAZ }

class ActivityTemplatePage extends StatefulWidget {
  final ActivitiesCategoryModel category;

  ActivityTemplatePage({required this.category});

  @override
  _ActivityTemplatePageState createState() => _ActivityTemplatePageState();
}

class _ActivityTemplatePageState extends State<ActivityTemplatePage> {
  late List<ActivityTemplate> activityTemplates;
  bool isLoading = false;
  ActivitySort _currentSort = ActivitySort.priceLowToHigh;

  @override
  void initState() {
    super.initState();
    activityTemplates = [];
    fetchActivityTemplates();
  }

  Future<void> fetchActivityTemplates() async {
    String? token = await storage.read(key: "access_token");
    String formatter(String url) {
      return baseUrls + url;
    }

    String url =
        formatter("/api/activity-templates/categories/${widget.category.id}");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> results = data["results"];
      activityTemplates = results
          .map((groupData) => ActivityTemplate.fromJson(groupData))
          .toList();

      // Update the data source
      setState(() {
        _updateSorting();
      });
    } else {
      print('Failed to load activity Templates');
    }
  }

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sort By'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSortOptionTile(
                  'Price (Low to High)', ActivitySort.priceLowToHigh),
              _buildSortOptionTile('Country', ActivitySort.country),
              _buildSortOptionTile('Name (A-Z)', ActivitySort.nameAZ),
            ],
          ),
        );
      },
    );
  }

  ListTile _buildSortOptionTile(String title, ActivitySort sort) {
    return ListTile(
      title: Text(title),
      onTap: () {
        setState(() {
          _currentSort = sort;
          // Call the method to update the sorting logic based on the selected option
          _updateSorting();
        });
        Navigator.of(context).pop(); // Close the dialog
      },
    );
  }

  void _updateSorting() {
    // Add sorting logic based on _currentSort
    switch (_currentSort) {
      case ActivitySort.priceLowToHigh:
        activityTemplates
            .sort((a, b) => (a.adultPrice ?? 0).compareTo(b.adultPrice ?? 0));
        break;
      case ActivitySort.country:
        activityTemplates
            .sort((a, b) => (a.countryId ?? '').compareTo(b.countryId ?? ''));
        break;
      case ActivitySort.nameAZ:
        activityTemplates
            .sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name ?? ''),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.filter_list,
                              color: Color(0xFFFF725E),
                            ),
                            onPressed: _showSortDialog,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Sort By',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      // Add sorting dropdown or buttons here
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: activityTemplates.length,
                    itemBuilder: (context, index) {
                      final template = activityTemplates[index];
                      return Container(
                        width: 341,
                        height: 135,
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 141,
                                  height: 134,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(14),
                                      bottomLeft: Radius.circular(14),
                                    ),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        "${baseUrls}${template.picture}",
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        template.name ?? '',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Country: ${template.countryId ?? ''}',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Price: \$${template.adultPrice ?? ''}',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              width: 71,
                              height: 25,
                              top: 105,
                              left: 265,
                              child: Container(
                                padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFF725E),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    'Book',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
