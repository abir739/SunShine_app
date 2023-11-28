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
                            ? Container(
                                width: 140, // Set your desired width
                                height: 140, // Set your desired height
                                child: ImageWithDynamicBackgroundColorusers(
                                  imageUrl:
                                      "https://images.unsplash.com/photo-1575936123452-b67c3203c357?auto=format&fit=crop&q=80&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aW1hZ2V8ZW58MHx8MHx8fDA%3D&w=1000",
                                  isCirculair: true,
                                ),
                              )
                            : Container(
                                width: 140, // Set your desired width
                                height: 140, // Set your desired height
                                child: ImageWithDynamicBackgroundColorusers(
                                  imageUrl:
                                      "${baseUrls}${transfer.agency?.logo}",
                                  isCirculair: true,
                                ),
                              ),
                        SizedBox(
                          width: Get.width * 0.10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${transfer.agency?.name ?? "A/N"}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 35),
                            ),
                            SizedBox(height: 10),
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
                  Spacer(), // Add Spacer to push the Chip to the right
                  Align(
                    alignment: Alignment.topRight,
                    child: Chip(
                      label: timeDifference(
                        transfer.date!.add(
                          Duration(hours: transfer.durationHours ?? 5),
                        ),
                      ),
                      avatar: Icon(
                        Icons.timer,
                        size: 40,
                      ),
                      backgroundColor: Color.fromARGB(54, 243, 133, 8),
                    ),
                  ),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.airplanemode_active,
                                    size: 40,
                                  ),
                                  SizedBox(width: 18),
                                  Text(
                                    "Dep:  " +
                                        DateFormat('h:mm a').format(
                                          (transfer.date ?? DateTime.now())
                                              .toLocal(),
                                        ),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 30),
                                  ),
                                  SizedBox(width: 100),
                                  Icon(
                                    Icons.airplanemode_active,
                                    size: 40,
                                  ),
                                  SizedBox(width: 18),
                                  Text(
                                    "Ar: " +
                                        (transfer != null &&
                                                transfer.date != null &&
                                                transfer.durationHours != null
                                            ? (transfer.durationHours! > 23
                                                ? DateFormat('EEEE, h:mm a')
                                                    .format(
                                                    (transfer.date!
                                                            .toLocal()
                                                            .add(
                                                              Duration(
                                                                  hours: transfer
                                                                          .durationHours ??
                                                                      1),
                                                            )) ??
                                                        DateTime.now(),
                                                  )
                                                : DateFormat('h:mm a').format(
                                                    (transfer.date!
                                                            .toLocal()
                                                            .add(
                                                              Duration(
                                                                  hours: transfer
                                                                          .durationHours ??
                                                                      1),
                                                            )) ??
                                                        DateTime.now(),
                                                  ))
                                            : 'N/A'),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 30,
                                    ),
                                  ),
                                  SizedBox(width: 78),
                                ],
                              ),
                              SizedBox(height: 75),
                              Icon(
                                Icons.location_on_outlined,
                                size: 40,
                              ),
                              SizedBox(width: 18),
                              Text(
                                "${transfer.to ?? 'N/a'}" ?? "N/a",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 30),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
                              ? Container(
                                  width: 140, // Set your desired width
                                  height: 140, // Set your desired height
                                  child: ImageWithDynamicBackgroundColorusers(
                                    imageUrl:
                                        "https://images.unsplash.com/photo-1575936123452-b67c3203c357?auto=format&fit=crop&q=80&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aW1hZ2V8ZW58MHx8MHx8fDA%3D&w=1000",
                                    isCirculair: true,
                                  ),
                                )
                              : Container(
                                  width: 140, // Set your desired width
                                  height: 140, // Set your desired height
                                  child: ImageWithDynamicBackgroundColorusers(
                                    imageUrl:
                                        "${baseUrls}${activity.agency?.logo}",
                                    isCirculair: true,
                                  ),
                                ),
                          SizedBox(
                            width: Get.width * 0.10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("${activity.agency?.name ?? "A/N"}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 30)),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "${activity.agency?.fullName ?? "A/N"}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 30),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Spacer(), // Add Spacer to push the Chip to the right
                    Align(
                        alignment: Alignment.topRight,
                        child: Chip(
                          label: timeDifferences(
                            activity.departureDate!.add(
                              Duration(hours: timeDifference.inHours ?? 5),
                            ),
                          ),
                          avatar: Icon(Icons.timer, size: 35),
                          backgroundColor: Color.fromARGB(250, 241, 241, 237),
                        )),
                  ],
                ),
                Divider(
                  thickness: 3,
                  color: Color.fromARGB(255, 233, 229, 229),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.airplanemode_active,
                                      size: 40,
                                    ),
                                    SizedBox(width: 18),
                                    Text(
                                      DateFormat('h:mm a').format(
                                          activity.departureDate!.toLocal() ??
                                              DateTime.now()),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 30),
                                    ),
                                    SizedBox(width: 100),
                                    Icon(
                                      Icons.airplanemode_active,
                                      size: 40,
                                    ),
                                    SizedBox(width: 18),
                                    Text(
                                      activity != null &&
                                              activity.departureDate != null &&
                                              activity.returnDate != null
                                          ? timeDifference.inHours > 23
                                              ? DateFormat('EEEE, h:mm a')
                                                      .format(activity
                                                          .departureDate!
                                                          .toLocal()) ??
                                                  DateFormat('EEEE, h:mm a')
                                                      .format(DateTime.now())
                                              : DateFormat('h:mm a').format(
                                                      activity.departureDate!
                                                          .toLocal()) ??
                                                  DateFormat('h:mm a')
                                                      .format(DateTime.now())
                                          : 'N/A',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 30,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 78,
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.location_on, size: 50),
                                      onPressed: () async {
                                        if (activity.activityTemplate != null &&
                                            activity.activityTemplate
                                                    ?.coordinates !=
                                                null) {
                                          final coordinates = activity
                                              .activityTemplate?.coordinates!;
                                          final binaryCoordinates =
                                              jsonEncode(coordinates);
                                          final parsedCoordinates =
                                              parseCoordinates(
                                                  binaryCoordinates);
                                          double latitude =
                                              parsedCoordinates[0];
                                          double longitude =
                                              parsedCoordinates[1];
                                          final placeQuery =
                                              '$latitude $longitude';
                                          final c = Colors.blue;

                                          openMapApp(
                                            latitude!,
                                            longitude!,
                                            placeQuery: placeQuery,
                                            trackLocation: true,
                                            color: c,
                                            markerImage: const AssetImage(
                                                'assets/Male.png'),
                                            map_action: true,
                                          );

                                          print(
                                              "binaryCoordinates $binaryCoordinates");
                                          print("latitude $latitude");
                                          print("longitude $longitude");
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      width: 14,
                                    ),
                                    Text(
                                      "Location",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 30),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 50),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.price_check,
                                      size: 40,
                                    ),
                                    SizedBox(width: 15),
                                    Text(
                                      "Price:   " +
                                          "${activity.adultPrice ?? 'N/a'}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 30),
                                    ),
                                    SizedBox(width: 120),
                                    Text(
                                      "Activity name:    " +
                                              "${activity.name ?? 'N/a'}" ??
                                          "N/a",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 30,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
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
    final timeDifference = tasksTransfer.todoDate!
        .difference(tasksTransfer.todoDate!.add(Duration(days: 2000)));
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
                              ? Container(
                                  width: 140, // Set your desired width
                                  height: 140, // Set your desired height
                                  child: ImageWithDynamicBackgroundColorusers(
                                    imageUrl:
                                        "https://images.unsplash.com/photo-1575936123452-b67c3203c357?auto=format&fit=crop&q=80&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aW1hZ2V8ZW58MHx8MHx8fDA%3D&w=1000",
                                    isCirculair: true,
                                  ),
                                )
                              : Container(
                                  width: 140, // Set your desired width
                                  height: 140, // Set your desired height
                                  child: ImageWithDynamicBackgroundColorusers(
                                    imageUrl: "",
                                    isCirculair: true,
                                  ),
                                ),
                          SizedBox(
                            width: Get.width * 0.03,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [],
                          ),
                        ],
                      ),
                    ),
                    Spacer(), // Add Spacer to push the Chip to the right
                    Align(
                        alignment: Alignment.topRight,
                        child: Chip(
                          label: timeDifferences(tasksTransfer.todoDate!),
                          avatar: Icon(Icons.timer, size: 35),
                          backgroundColor: Color.fromARGB(250, 241, 241, 237),
                        )),
                  ],
                ),
                Divider(
                  thickness: 3,
                  color: Color.fromARGB(255, 233, 229, 229),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.today_outlined,
                                      size: 40,
                                    ),
                                    SizedBox(width: 18),
                                    Text(
                                      tasksTransfer != null &&
                                              tasksTransfer.todoDate != null
                                          ? timeDifference.inHours > 23
                                              ? DateFormat('EEEE, h:mm a')
                                                      .format(tasksTransfer
                                                          .todoDate!
                                                          .toLocal()) ??
                                                  DateFormat('EEEE, h:mm a')
                                                      .format(DateTime.now())
                                              : DateFormat('h:mm a').format(
                                                      tasksTransfer.todoDate!
                                                          .toLocal()) ??
                                                  DateFormat('h:mm a')
                                                      .format(DateTime.now())
                                          : 'N/A',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 30,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 78,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 55,
                                ),
                                Text(
                                    "${tasksTransfer.description ?? 'N/a'}" ??
                                        "N/a",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 30)),
                              ],
                            ),
                          ],
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
