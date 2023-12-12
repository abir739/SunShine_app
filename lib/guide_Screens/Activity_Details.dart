import 'package:flutter/material.dart';
import 'package:zenify_app/modele/activitsmodel/activitesmodel.dart';
import 'package:zenify_app/modele/activitsmodel/activityTempModel.dart';
import 'package:zenify_app/services/constent.dart';

class ActivityView extends StatelessWidget {
  final Activity activity;

  ActivityView({required this.activity});

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
                    "${baseUrls}${activity.activityTemplate?.picture}",
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
                    activity.name ?? '',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF725E),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Date: ${activity.departureDate ?? ''}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 21),
                  Text(
                    'Departure Note',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 1, 1, 1),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    activity.departureNote ?? '',
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
                  buildImageList(activity.activityTemplate?.images),

                  SizedBox(height: 70),
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
                            // Implement book now functionality here
                            // You can navigate to a new screen, show a dialog, or perform any other action
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

  Widget buildImageList(List<String>? images) {
    if (images == null || images.isEmpty) {
      return Text('No images available.');
    }

    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Padding(
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
          );
        },
      ),
    );
  }
}
