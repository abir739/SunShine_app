import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:zenify_app/guide_Screens/GroupsList.dart';
import 'package:zenify_app/login/Login.dart';
import 'package:zenify_app/modele/Media-files.dart';
import 'package:zenify_app/modele/activitsmodel/activityTempModel.dart';
import 'package:zenify_app/services/constent.dart';
import 'package:http/http.dart' as http;

import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ActivityDetailPage extends StatefulWidget {
  final ActivityTemplate activityTemplate;

  ActivityDetailPage({required this.activityTemplate});

  @override
  _ActivityDetailPageState createState() => _ActivityDetailPageState();
}

class _ActivityDetailPageState extends State<ActivityDetailPage> {
  List<Media> media = []; // Assuming Media is the type of your media files

  @override
  void initState() {
    super.initState();
    // Fetch media files when the widget is initialized
    fetchMediafiles();
  }

  Future<void> fetchMediafiles() async {
    String? token = await storage.read(key: "access_token");
    String formatter(String url) {
      return baseUrls + url;
    }

    String url = formatter("/api/media-files");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> results = data["results"];
      setState(() {
        media = results.map((groupData) => Media.fromJson(groupData)).toList();
      });
    } else {
      print('Failed to load media files');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 554,
              height: 314,
              margin: EdgeInsets.fromLTRB(9, 0, 7, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(21),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    "${baseUrls}${widget.activityTemplate.picture}",
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(18),
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.activityTemplate.name ?? '',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF725E),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Country: ${widget.activityTemplate.country?.name ?? ''}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 21),
                  Text(
                    'About the Place',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 1, 1, 1),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    widget.activityTemplate.shortDescription ?? '',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 21),
                  Text(
                    'More Photos',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 1, 1, 1),
                    ),
                  ),
                  SizedBox(height: 10),
                  buildImageList(widget.activityTemplate.id ?? ""),

                  SizedBox(height: 55),
                  // Bookmark Icon
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.bookmark_border,
                            size: 35,
                            color: Color(0xFFFF725E),
                          ),
                          onPressed: () {
                            // Implement bookmark functionality here
                          },
                        ),
                      ),
                      SizedBox(width: 20),
                      // "Book Now" Button
                      Container(
                        width: 212,
                        height: 43,
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to TravellersListScreen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GroupsList(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Color(0xFFFF725E), // You can change the color
                          ),
                          child: Text(
                            'Book Now',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImageList(String objectPrimaryKey) {
    List<String> images = media
        .where((m) => m.objectPrimaryKey == objectPrimaryKey)
        .map((m) => m.file ?? "")
        .toList();

    if (images.isEmpty) {
      return Text('No images available.');
    }

    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              openImageGallery(index);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 3,
                child: Container(
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage("${baseUrls}${images[index]}"),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void openImageGallery(int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoViewGallery(
          pageController: PageController(initialPage: initialIndex),
          scrollPhysics: BouncingScrollPhysics(),
          backgroundDecoration: BoxDecoration(
            color: Colors.black,
          ),
          pageOptions: media
              .where((m) => m.objectPrimaryKey == widget.activityTemplate.id)
              .map((m) => PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage("${baseUrls}${m.file}"),
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered * 2,
                  ))
              .toList(),
        ),
      ),
    );
  }
}
