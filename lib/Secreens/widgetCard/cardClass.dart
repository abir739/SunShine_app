import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';



import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'package:zenify_app/modele/activitsmodel/activitesmodel.dart';
import 'package:zenify_app/modele/tasks/taskModel.dart';
import 'package:zenify_app/modele/touristGroup.dart';
import 'package:zenify_app/modele/transportmodel/transportModel.dart';
import 'package:zenify_app/services/ServiceWedget/NotificationUserImages.dart';
import 'package:zenify_app/services/constent.dart';

final customFormat = DateFormat('dd MMMM yyyy hh:mm a');

class TransferCard extends StatelessWidget {
  final Transport transfer;
// List<String> groupIdsList ;
  final List<Map<String, dynamic>> travelersData;
  TransferCard(this.transfer, this.travelersData);
  int userCount = 0;
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

  Text timeDifference(DateTime? targetTime) {
    final now = DateTime.now();
    final difference = targetTime!.difference(now);
    final minutesDifference = difference.inMinutes;
    final hoursDifference = difference.inHours;
    final daysDifference = difference.inDays;

    if (minutesDifference <= 0) {
      return Text(
        'Passed',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 40),
      );
    } else if (minutesDifference < 60) {
      return Text(
        'In $minutesDifference min',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 40),
      );
    } else if (hoursDifference < 24) {
      return Text(
        'In $hoursDifference hours',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 40),
      );
    } else {
      return Text(
        'In $daysDifference days',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 40),
      );
    }
  }

  String truncateText(String text, int maxLength) {
    if (text.length > maxLength) {
      return text.substring(0, maxLength) + '...';
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    // Common UI elements for all types of transfers
    return FittedBox(
      child: SizedBox(
          height: 400,
          width: 900,
          child: Card(
            color: Color.fromARGB(255, 250, 250, 235),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Center(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 30,
                          ),
                          transfer.agency?.logo == null
                              ? ImageWithDynamicBackgroundColorusers(
                                  imageUrl:
                                      "https://images.unsplash.com/photo-1575936123452-b67c3203c357?auto=format&fit=crop&q=80&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aW1hZ2V8ZW58MHx8MHx8fDA%3D&w=1000",
                                  isCirculair: true,
                                )
                              : ImageWithDynamicBackgroundColorusers(
                                  imageUrl:
                                      "${baseUrls}${transfer.agency?.logo}",
                                  isCirculair: true,
                                ),
                          SizedBox(
                            width: Get.width * 0.03,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Text("Tunisia"),
                              Text(
                                "${transfer.agency?.name ?? "A/N"}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 35),
                              ),
                              Text("Tunisia aire"),
                              Text(
                                truncateText(
                                    transfer.agency?.fullName ?? "A/N", 20),
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 30),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: Get.width * 0.35,
                    ),
                    Chip(
                      label: timeDifference(transfer.date!
                          .add(Duration(hours: transfer.durationHours ?? 5))),
                      avatar: Icon(
                        Icons.timer,
                        size: 40,
                      ),
                      backgroundColor: Color.fromARGB(54, 243, 133, 8),
                    )

                    //  Text('${activityTransfer.activityTemplate?.name}'),
                    //   Text('${a.activityTemplate?.name}'),
                  ],
                ),
                Divider(
                  thickness: 3,
                  color: Color.fromARGB(255, 87, 57, 12),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          DateFormat('h:mm a').format(
                              transfer.date!.toLocal() ?? DateTime.now()),style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30)
                        ),
                        Container(
                                        width: Get.width * 0.8,
                                        child:Text("${transfer.from ?? 'N/a'}",style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24)),
                    )],
                    ),
                    Column(
                      children: [
                        Icon(Icons.airplanemode_active),
                        Text(
                          DateFormat('h:mm a').format(
                              transfer.date!.toLocal() ?? DateTime.now()),style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30)
                        ),
                        // Text("3 hours ${transfer.id}"),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          transfer != null &&
                                  transfer.date != null &&
                                  transfer.durationHours != null
                              ? transfer.durationHours! > 23
                                  ? DateFormat('EEEE, h:mm a').format(
                                        transfer.date!.toLocal().add(
                                              Duration(
                                                  hours:
                                                      transfer.durationHours ??
                                                          1),
                                            ),
                                      ) ??
                                      DateFormat('EEEE, h:mm a')
                                          .format(DateTime.now())
                                  : DateFormat('h:mm a').format(
                                        transfer.date!.toLocal().add(
                                              Duration(
                                                  hours:
                                                      transfer.durationHours ??
                                                          1),
                                            ),
                                      ) ??
                                      DateFormat('h:mm a')
                                          .format(DateTime.now())
                              : 'N/A', // Handle the case when transfer or transfer.date is null
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)  ),
                      Container(
                                        width: Get.width * 0.4,
                                        child:  Text("${transfer.to ?? 'N/a'}" ?? "N/a",style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24)),
                      )  ],
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 20),
                    Icon(Icons.group_sharp),
                    Text("23 Person",style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 20),
                    Icon(Icons.location_on_outlined),
                    Text("  Tunisia, sousse",style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
                    SizedBox(
                      width: 70,
                    ),
                    // Row(
                    //   // mainAxisSize: MainAxisSize.min,
                    //   // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    SizedBox(
                      height: 40,
                      width: 100,
                      child: ListView.builder(
                        // itemExtent: 25.5,
                        // cacheExtent: 0.0,
                        //  clipBehavior :Clip.antiAliasWithSaveLayer,
                        //   itemExtent: 30, // Adjust this value to your desired item height
                        scrollDirection: Axis.horizontal,
                        itemCount: travelersData.length,
                        itemBuilder: (context, index) {
                          final traveler = travelersData[index];
                          final user = traveler['user'];
                          // final userImageUrl = "${baseUrls}/assets/uploads/${user['id']}/${user['picture']}";

                          final userImageUrl =
                              "${baseUrls}/assets/uploads/${user['picture']}";

                          if (transfer.touristGroups!.any((group) =>
                              group.id == traveler['touristGroupId'])) {
                            for (TouristGroup group
                                in transfer.touristGroups ?? []) {
                              if (group != null) {
                                for (Map<String, dynamic> traveler
                                    in travelersData) {
                                  if (group.id == traveler['touristGroupId']) {
                                    userCount++; // Increment the user count for each matching user
                                  }
                                }
                              }
                            }
                            return CircleAvatar(
                              backgroundImage:
                                  NetworkImage(userImageUrl, scale: 100),
                            );
                          } else {
                            // If 'touristGroupId' doesn't match any 'id' in the tourist groups, return an empty SizedBox
                            return SizedBox.shrink();
                          }
                        },
                      ),

                      //                   FutureBuilder(
                      //     future: fetchTravelersByGroupIds(groupIdsList),
                      //     builder: (context, snapshot) {
                      //       if (snapshot.connectionState == ConnectionState.waiting) {
                      //         return SizedBox();
                      //       } else if (snapshot.hasError) {
                      //         return Text('Error: ${snapshot.error}');
                      //       } else if (!snapshot.hasData) {
                      //         return Text('No data available');
                      //       } else {
                      //         final travelers = snapshot.data ;
                      //         return ListView.builder(
                      //           scrollDirection: Axis.horizontal,
                      //           itemCount: travelers!.length,
                      //           itemBuilder: (context, index) {
                      //             final traveler = travelers[index];
                      //             final user = traveler['user'];
                      //             final userImageUrl =  "${baseUrls}/assets/uploads/${user['picture']}"; // Replace with the actual URL
                      //       if (transfer.touristGroups!.any((group) => group.id == traveler['touristGroupId'])) {
                      //     return Padding(
                      //       padding: EdgeInsets.all(8.0),
                      //       child: CircleAvatar(
                      //         backgroundImage: NetworkImage(userImageUrl),
                      //       ),
                      //     );
                      //   } else {
                      //     // If 'touristGroupId' doesn't match any 'id' in the tourist groups, return an empty SizedBox
                      //     return SizedBox.shrink();
                      //   }
                      // },
                      //         );
                      //       }
                      //     },
                      //   ),

                      // TravelerImageList(travelerGroupIds:groupIdsList, transfer: transfer,)

                      //           ListView.builder(
                      //   scrollDirection: Axis.horizontal,
                      //   itemCount: groupedTravelerImages.keys.length,
                      //   itemBuilder: (context, transportIndex) {
                      //     final transportId =
                      //         groupedTravelerImages.keys.elementAt(transportIndex);
                      //     final groupMap = groupedTravelerImages[transportId]!;

                      //     // Replace 'transferId' with the specific transfer ID you want to display
                      //     if (transportId != transfer.id) {
                      //       // Skip the transfers that don't match the specified transfer ID
                      //       return SizedBox.shrink();
                      //     }

                      //     List<Widget> groupWidgets = [];

                      //     for (final groupId in groupMap.keys) {
                      //       final images = groupMap[groupId];
                      //       print("images $images");
                      //       List<Widget> imageWidgets = images!.map((imageUrl) {
                      //         return Stack(
                      //           children: [
                      //             ClipOval(
                      //               child: Image.network(
                      //                 "${baseUrls}/assets/uploads/$imageUrl",
                      //                 width: 50,
                      //                 height: 50,
                      //                 fit: BoxFit.cover,
                      //               ),
                      //             ),
                      //           ],
                      //         );
                      //       }).toList();

                      //       groupWidgets.addAll(imageWidgets);
                      //     }

                      //     return SizedBox(
                      //       height: 40,
                      //       width: 50,
                      //       child: Row(children: groupWidgets),
                      //     );
                      //   },
                      // ),
                    )
                    //   ],
                    // ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final Activity activity;

  ActivityCard(this.activity);
  Text timeDifferences(DateTime? targetTime) {
   final now = DateTime.now();
    final difference = targetTime!.difference(now);
    final minutesDifference = difference.inMinutes;
    final hoursDifference = difference.inHours;
    final daysDifference = difference.inDays;

    if (minutesDifference <= 0) {
      return Text(
        'Passed',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 40),
      );
    } else if (minutesDifference < 60) {
      return Text(
        'In $minutesDifference min',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 40),
      );
    } else if (hoursDifference < 24) {
      return Text(
        'In $hoursDifference hours',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 40),
      );
    } else {
      return Text(
        'In $daysDifference days',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 40),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Specific UI elements for ActivityTransfer
    final timeDifference =
        activity.returnDate!.difference(activity.departureDate!);
    return FittedBox(
      child: SizedBox(
          height: 400,
          width: 900,
          child: Card(
            color: Color.fromARGB(206, 209, 209, 207),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Center(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 30,
                          ),
                          activity.agency?.logo == null
                              ? ImageWithDynamicBackgroundColorusers(
                                  imageUrl:
                                      "https://images.unsplash.com/photo-1575936123452-b67c3203c357?auto=format&fit=crop&q=80&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aW1hZ2V8ZW58MHx8MHx8fDA%3D&w=1000",
                                  isCirculair: true,
                                )
                              : ImageWithDynamicBackgroundColorusers(
                                  imageUrl:
                                      "${baseUrls}${activity.agency?.logo}",
                                  isCirculair: true,
                                ),
                          SizedBox(
                            width: Get.width * 0.03,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Text("Tunisia"),
                              Text("${activity.agency?.name ?? "A/N"}",style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
                              Text("Activity aire",style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
                              Text("${activity.agency?.fullName ?? "A/N"}",style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: Get.width * 0.35,
                    ),
                    Chip(
                      label: timeDifferences(activity.departureDate!
                          .add(Duration(hours: timeDifference.inHours ?? 5),),),
                      avatar: Icon(Icons.timer,size: 35),
                      backgroundColor: Color.fromARGB(250, 241, 241, 237),
                    )

                    //  Text('${activityTransfer.activityTemplate?.name}'),
                    //   Text('${a.activityTemplate?.name}'),
                  ],
                ),
                Divider(
                  thickness: 2,
                  color: Color.fromARGB(255, 233, 229, 229),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          DateFormat('h:mm a').format(
                              activity.departureDate!.toLocal() ??
                                  DateTime.now())
                     ,style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)   ),
                        Container(
                                        width: Get.width * 0.8,
                                        child:Text("${activity.adultPrice ?? 'N/a'}",style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
                     ) ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.airplanemode_active),
                        Text(
                          DateFormat('h:mm a').format(
                              activity.departureDate!.toLocal() ??
                                  DateTime.now()),style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)
                        ),
                        // Text("3 hours ${transfer.id}"),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          activity != null &&
                                  activity.departureDate != null &&
                                  activity.returnDate != null
                              ? timeDifference.inHours > 23
                                  ? DateFormat('EEEE, h:mm a').format(
                                          activity.departureDate!.toLocal()) ??
                                      DateFormat('EEEE, h:mm a')
                                          .format(DateTime.now())
                                  : DateFormat('h:mm a').format(
                                          activity.departureDate!.toLocal()) ??
                                      DateFormat('h:mm a')
                                          .format(DateTime.now() )
                              : 'N/A', // Handle the case when transfer or transfer.date is null
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)  ),
                        Container(
                                        width: Get.width * 0.8,
                                        child:Text("${activity.name ?? 'N/a'}" ?? "N/a",style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
                     ) ],
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 20),
                    Icon(Icons.group_sharp),
                    Text("23 Person",style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 20),
                    Icon(Icons.location_on_outlined),
                    Text("  Tunisia, sousse",style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30)),
                    SizedBox(
                      width: 70,
                    ),
                 

                    // Row(
                    //   // mainAxisSize: MainAxisSize.min,
                    //   // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    // SizedBox(
                    //   height: 40,
                    //   width: 100,
                    //   child: ListView.builder(
                    //     // itemExtent: 25.5,
                    //     // cacheExtent: 0.0,
                    //     //  clipBehavior :Clip.antiAliasWithSaveLayer,
                    //     //   itemExtent: 30, // Adjust this value to your desired item height
                    //     scrollDirection: Axis.horizontal,
                    //     itemCount: travelersData.length,
                    //     itemBuilder: (context, index) {
                    //       final traveler = travelersData[index];
                    //       final user = traveler['user'];
                    //       // final userImageUrl = "${baseUrls}/assets/uploads/${user['id']}/${user['picture']}";

                    //       final userImageUrl =
                    //           "${baseUrls}/assets/uploads/${user['picture']}";

                    //       if (transfer.touristGroups!.any(
                    //           (group) => group.id == traveler['touristGroupId'])) {
                    //         for (TouristGroup group in transfer.touristGroups ?? []) {
                    //           if (group != null) {
                    //             for (Map<String, dynamic> traveler in travelersData) {
                    //               if (group.id == traveler['touristGroupId']) {
                    //                 userCount++; // Increment the user count for each matching user
                    //               }
                    //             }
                    //           }
                    //         }
                    //         return CircleAvatar(
                    //           backgroundImage: NetworkImage(userImageUrl, scale: 100),
                    //         );
                    //       } else {
                    //         // If 'touristGroupId' doesn't match any 'id' in the tourist groups, return an empty SizedBox
                    //         return SizedBox.shrink();
                    //       }
                    //     },
                    //   ),

                    //   //                   FutureBuilder(
                    //   //     future: fetchTravelersByGroupIds(groupIdsList),
                    //   //     builder: (context, snapshot) {
                    //   //       if (snapshot.connectionState == ConnectionState.waiting) {
                    //   //         return SizedBox();
                    //   //       } else if (snapshot.hasError) {
                    //   //         return Text('Error: ${snapshot.error}');
                    //   //       } else if (!snapshot.hasData) {
                    //   //         return Text('No data available');
                    //   //       } else {
                    //   //         final travelers = snapshot.data ;
                    //   //         return ListView.builder(
                    //   //           scrollDirection: Axis.horizontal,
                    //   //           itemCount: travelers!.length,
                    //   //           itemBuilder: (context, index) {
                    //   //             final traveler = travelers[index];
                    //   //             final user = traveler['user'];
                    //   //             final userImageUrl =  "${baseUrls}/assets/uploads/${user['picture']}"; // Replace with the actual URL
                    //   //       if (transfer.touristGroups!.any((group) => group.id == traveler['touristGroupId'])) {
                    //   //     return Padding(
                    //   //       padding: EdgeInsets.all(8.0),
                    //   //       child: CircleAvatar(
                    //   //         backgroundImage: NetworkImage(userImageUrl),
                    //   //       ),
                    //   //     );
                    //   //   } else {
                    //   //     // If 'touristGroupId' doesn't match any 'id' in the tourist groups, return an empty SizedBox
                    //   //     return SizedBox.shrink();
                    //   //   }
                    //   // },
                    //   //         );
                    //   //       }
                    //   //     },
                    //   //   ),

                    //   // TravelerImageList(travelerGroupIds:groupIdsList, transfer: transfer,)

                    //   //           ListView.builder(
                    //   //   scrollDirection: Axis.horizontal,
                    //   //   itemCount: groupedTravelerImages.keys.length,
                    //   //   itemBuilder: (context, transportIndex) {
                    //   //     final transportId =
                    //   //         groupedTravelerImages.keys.elementAt(transportIndex);
                    //   //     final groupMap = groupedTravelerImages[transportId]!;

                    //   //     // Replace 'transferId' with the specific transfer ID you want to display
                    //   //     if (transportId != transfer.id) {
                    //   //       // Skip the transfers that don't match the specified transfer ID
                    //   //       return SizedBox.shrink();
                    //   //     }

                    //   //     List<Widget> groupWidgets = [];

                    //   //     for (final groupId in groupMap.keys) {
                    //   //       final images = groupMap[groupId];
                    //   //       print("images $images");
                    //   //       List<Widget> imageWidgets = images!.map((imageUrl) {
                    //   //         return Stack(
                    //   //           children: [
                    //   //             ClipOval(
                    //   //               child: Image.network(
                    //   //                 "${baseUrls}/assets/uploads/$imageUrl",
                    //   //                 width: 50,
                    //   //                 height: 50,
                    //   //                 fit: BoxFit.cover,
                    //   //               ),
                    //   //             ),
                    //   //           ],
                    //   //         );
                    //   //       }).toList();

                    //   //       groupWidgets.addAll(imageWidgets);
                    //   //     }

                    //   //     return SizedBox(
                    //   //       height: 40,
                    //   //       width: 50,
                    //   //       child: Row(children: groupWidgets),
                    //   //     );
                    //   //   },
                    //   // ),
                    // )
                    // //   ],
                    // ),
                             Column(
                               children: [Text("trace Activity location",style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30)),
                                 IconButton(
              icon: Icon(
                Icons.map,size:60
              ),
              onPressed: () async {
                if (activity.activityTemplate != null &&
                    activity.activityTemplate?.coordinates != null) {
                  final coordinates = activity.activityTemplate?.coordinates!;
                  final binaryCoordinates = jsonEncode(coordinates);
                  final parsedCoordinates = parseCoordinates(binaryCoordinates);
                  double latitude = parsedCoordinates[0];
                  double longitude = parsedCoordinates[1];
                  final placeQuery = '$latitude $longitude';
                  final c = Colors.blue;
                  // getLocationZone(latitude, longitude);
                  openMapApp(
                    latitude!,
                    longitude!,
                    placeQuery: placeQuery,
                    trackLocation: true,
                    color: c,
                    markerImage: const AssetImage('assets/Male.png'),
                    map_action: true,
                  );

                  print("binaryCoordinates $binaryCoordinates");
                  print("latitude $latitude");
                  print("longitude $longitude");
                  // await fetchWeather(latitude, longitude);
                }
              },
            ),
                               ],
                             ),
     
                  ],
                ),
              ],
            ),
          )),
    );
  }
}

class TaskCard extends StatelessWidget {
  final Tasks tasksTransfer;

  TaskCard(this.tasksTransfer);
  Text timeDifferences(DateTime? targetTime) {
   final now = DateTime.now();
    final difference = targetTime!.difference(now);
    final minutesDifference = difference.inMinutes;
    final hoursDifference = difference.inHours;
    final daysDifference = difference.inDays;

    if (minutesDifference <= 0) {
      return Text(
        'Passed',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 40),
      );
    } else if (minutesDifference < 60) {
      return Text(
        'In $minutesDifference min',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 40),
      );
    } else if (hoursDifference < 24) {
      return Text(
        'In $hoursDifference hours',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 40),
      );
    } else {
      return Text(
        'In $daysDifference days',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 40),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Specific UI elements for ActivityTransfer
    final timeDifference =
        tasksTransfer.todoDate!.difference(tasksTransfer.todoDate!.add(Duration(days: 2000)));
    return FittedBox(
      child: SizedBox(
          height: 400,
          width: 900,
          child: Card(
            color: Color.fromARGB(255, 211, 127, 17),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Center(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 30,
                          ),
                          tasksTransfer?.creatorUserId != null
                              ? ImageWithDynamicBackgroundColorusers(
                                  imageUrl:
                                      "https://images.unsplash.com/photo-1575936123452-b67c3203c357?auto=format&fit=crop&q=80&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aW1hZ2V8ZW58MHx8MHx8fDA%3D&w=1000",
                                  isCirculair: true,
                                )
                              : ImageWithDynamicBackgroundColorusers(
                                  imageUrl:
                                      "",
                                  isCirculair: true,
                                ),
                          SizedBox(
                            width: Get.width * 0.03,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Text("Tunisia"),
                              // Text("${tasksTransfer.agency?.name ?? "A/N"}",style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
                              // Text("Activity aire",style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
                              // Text("${activity.agency?.fullName ?? "A/N"}",style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),),
                           
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: Get.width * 0.35,
                    ),
                    Chip(
                      label: timeDifferences(tasksTransfer.todoDate!
                          ),
                      avatar: Icon(Icons.timer,size: 35),
                      backgroundColor: Color.fromARGB(250, 241, 241, 237),
                    )

                    //  Text('${activityTransfer.activityTemplate?.name}'),
                    //   Text('${a.activityTemplate?.name}'),
                  ],
                ),
                Divider(
                  thickness: 2,
                  color: Color.fromARGB(255, 233, 229, 229),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          DateFormat('h:mm a').format(
                              tasksTransfer.todoDate!.toLocal() ??
                                  DateTime.now())
                     ,style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)   ),
                        Container(
                                        width: Get.width * 0.8,
                                        child:Text("${tasksTransfer.description ?? 'N/a'}",style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
                     ) ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.airplanemode_active),
                        Text(
                          DateFormat('h:mm a').format(
                              tasksTransfer.todoDate!.toLocal() ??
                                  DateTime.now()),style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)
                        ),
                        // Text("3 hours ${transfer.id}"),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          tasksTransfer != null &&
                                  tasksTransfer.todoDate != null 
                              ? timeDifference.inHours > 23
                                  ? DateFormat('EEEE, h:mm a').format(
                                          tasksTransfer.todoDate!.toLocal()) ??
                                      DateFormat('EEEE, h:mm a')
                                          .format(DateTime.now())
                                  : DateFormat('h:mm a').format(
                                          tasksTransfer.todoDate!.toLocal()) ??
                                      DateFormat('h:mm a')
                                          .format(DateTime.now() )
                              : 'N/A', // Handle the case when transfer or transfer.date is null
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)  ),
                        Container(
                                        width: Get.width * 0.8,
                                        child:Text("${tasksTransfer.description ?? 'N/a'}" ?? "N/a",style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
                     ) ],
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 20),
                    Icon(Icons.group_sharp),
                    Text("23 Person",style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 20),
                    Icon(Icons.location_on_outlined),
                    Text("  Tunisia, sousse",style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30)),
                    SizedBox(
                      width: 70,
                    ),
                 

                    // Row(
                    //   // mainAxisSize: MainAxisSize.min,
                    //   // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    // SizedBox(
                    //   height: 40,
                    //   width: 100,
                    //   child: ListView.builder(
                    //     // itemExtent: 25.5,
                    //     // cacheExtent: 0.0,
                    //     //  clipBehavior :Clip.antiAliasWithSaveLayer,
                    //     //   itemExtent: 30, // Adjust this value to your desired item height
                    //     scrollDirection: Axis.horizontal,
                    //     itemCount: travelersData.length,
                    //     itemBuilder: (context, index) {
                    //       final traveler = travelersData[index];
                    //       final user = traveler['user'];
                    //       // final userImageUrl = "${baseUrls}/assets/uploads/${user['id']}/${user['picture']}";

                    //       final userImageUrl =
                    //           "${baseUrls}/assets/uploads/${user['picture']}";

                    //       if (transfer.touristGroups!.any(
                    //           (group) => group.id == traveler['touristGroupId'])) {
                    //         for (TouristGroup group in transfer.touristGroups ?? []) {
                    //           if (group != null) {
                    //             for (Map<String, dynamic> traveler in travelersData) {
                    //               if (group.id == traveler['touristGroupId']) {
                    //                 userCount++; // Increment the user count for each matching user
                    //               }
                    //             }
                    //           }
                    //         }
                    //         return CircleAvatar(
                    //           backgroundImage: NetworkImage(userImageUrl, scale: 100),
                    //         );
                    //       } else {
                    //         // If 'touristGroupId' doesn't match any 'id' in the tourist groups, return an empty SizedBox
                    //         return SizedBox.shrink();
                    //       }
                    //     },
                    //   ),

                    //   //                   FutureBuilder(
                    //   //     future: fetchTravelersByGroupIds(groupIdsList),
                    //   //     builder: (context, snapshot) {
                    //   //       if (snapshot.connectionState == ConnectionState.waiting) {
                    //   //         return SizedBox();
                    //   //       } else if (snapshot.hasError) {
                    //   //         return Text('Error: ${snapshot.error}');
                    //   //       } else if (!snapshot.hasData) {
                    //   //         return Text('No data available');
                    //   //       } else {
                    //   //         final travelers = snapshot.data ;
                    //   //         return ListView.builder(
                    //   //           scrollDirection: Axis.horizontal,
                    //   //           itemCount: travelers!.length,
                    //   //           itemBuilder: (context, index) {
                    //   //             final traveler = travelers[index];
                    //   //             final user = traveler['user'];
                    //   //             final userImageUrl =  "${baseUrls}/assets/uploads/${user['picture']}"; // Replace with the actual URL
                    //   //       if (transfer.touristGroups!.any((group) => group.id == traveler['touristGroupId'])) {
                    //   //     return Padding(
                    //   //       padding: EdgeInsets.all(8.0),
                    //   //       child: CircleAvatar(
                    //   //         backgroundImage: NetworkImage(userImageUrl),
                    //   //       ),
                    //   //     );
                    //   //   } else {
                    //   //     // If 'touristGroupId' doesn't match any 'id' in the tourist groups, return an empty SizedBox
                    //   //     return SizedBox.shrink();
                    //   //   }
                    //   // },
                    //   //         );
                    //   //       }
                    //   //     },
                    //   //   ),

                    //   // TravelerImageList(travelerGroupIds:groupIdsList, transfer: transfer,)

                    //   //           ListView.builder(
                    //   //   scrollDirection: Axis.horizontal,
                    //   //   itemCount: groupedTravelerImages.keys.length,
                    //   //   itemBuilder: (context, transportIndex) {
                    //   //     final transportId =
                    //   //         groupedTravelerImages.keys.elementAt(transportIndex);
                    //   //     final groupMap = groupedTravelerImages[transportId]!;

                    //   //     // Replace 'transferId' with the specific transfer ID you want to display
                    //   //     if (transportId != transfer.id) {
                    //   //       // Skip the transfers that don't match the specified transfer ID
                    //   //       return SizedBox.shrink();
                    //   //     }

                    //   //     List<Widget> groupWidgets = [];

                    //   //     for (final groupId in groupMap.keys) {
                    //   //       final images = groupMap[groupId];
                    //   //       print("images $images");
                    //   //       List<Widget> imageWidgets = images!.map((imageUrl) {
                    //   //         return Stack(
                    //   //           children: [
                    //   //             ClipOval(
                    //   //               child: Image.network(
                    //   //                 "${baseUrls}/assets/uploads/$imageUrl",
                    //   //                 width: 50,
                    //   //                 height: 50,
                    //   //                 fit: BoxFit.cover,
                    //   //               ),
                    //   //             ),
                    //   //           ],
                    //   //         );
                    //   //       }).toList();

                    //   //       groupWidgets.addAll(imageWidgets);
                    //   //     }

                    //   //     return SizedBox(
                    //   //       height: 40,
                    //   //       width: 50,
                    //   //       child: Row(children: groupWidgets),
                    //   //     );
                    //   //   },
                    //   // ),
                    // )
                    // //   ],
                    // ),
            //                  Column(
            //                    children: [Text("trace Activity location",style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30)),
            //                      IconButton(
            //   icon: Icon(
            //     Icons.map,size:60
            //   ),
            //   onPressed: () async {
            //     if (activity.activityTemplate != null &&
            //         activity.activityTemplate?.coordinates != null) {
            //       final coordinates = activity.activityTemplate?.coordinates!;
            //       final binaryCoordinates = jsonEncode(coordinates);
            //       final parsedCoordinates = parseCoordinates(binaryCoordinates);
            //       double latitude = parsedCoordinates[0];
            //       double longitude = parsedCoordinates[1];
            //       final placeQuery = '$latitude $longitude';
            //       final c = Colors.blue;
            //       // getLocationZone(latitude, longitude);
            //       openMapApp(
            //         latitude!,
            //         longitude!,
            //         placeQuery: placeQuery,
            //         trackLocation: true,
            //         color: c,
            //         markerImage: const AssetImage('assets/Male.png'),
            //         map_action: true,
            //       );

            //       print("binaryCoordinates $binaryCoordinates");
            //       print("latitude $latitude");
            //       print("longitude $longitude");
            //       // await fetchWeather(latitude, longitude);
            //     }
            //   },
            // ),
                          
            //                    ],
            //                  ),
     
                  ],
                ),
              ],
            ),
          )),
    );
  }

}
