import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zenify_app/Secreens/Notification/GuidPushnotification.dart';
import 'package:zenify_app/Secreens/Notification/NotificationDetails.dart';
import 'package:zenify_app/Secreens/Notification/PushNotificationScreen.dart';
import 'package:zenify_app/Secreens/Notification/transferdetailsfromnotification.dart';
import 'package:zenify_app/modele/TouristGuide.dart';
import 'package:zenify_app/services/ServiceWedget/ImageWithDynamicBackgrounListusers%20copy.dart';

import 'package:zenify_app/services/constent.dart';
import '../../modele/HttpPushNotification.dart';
import '../../modele/activitsmodel/httpActivites.dart';
import '../../modele/activitsmodel/pushnotificationmodel.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;

import 'NotificationCountNotifierProvider.dart';
class NotificationScreen extends StatelessWidget {
  String? groupsid;
  TouristGuide? guid; // Add guid here

  NotificationScreen({required this.groupsid, this.guid});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: NotificationList(guid: guid, groupsid: groupsid)),
    );
  }
}

class NotificationList extends StatefulWidget {
  final TouristGuide? guid; // Add guid parameter
  final String? groupsid;

  NotificationList({required this.guid, required this.groupsid});

  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  final httpHandler = HTTPHandlerPushNotification();
  final count = HTTPHandlerCount();
  int limit = 12;
  String formatTimestamp(DateTime? dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime!);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    } else {
      final formatter = DateFormat('yyyy-MM-dd');
      return formatter.format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return 
    Column(
      children: [  SizedBox(
          height: 20,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              badges.Badge(
  badgeAnimation: BadgeAnimation.rotation(),
  position: BadgePosition.topStart(top: 1.5, start: 1),
  badgeContent: Consumer<NotificationCountNotifier>(
    builder: (context, notifier, child) {
      final combinedCount = notifier.count;
      return Text(
        '$combinedCount',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      );
    },
  ),
  child: IconButton(
    color: Color.fromARGB(178, 105, 103, 103),
    iconSize: 20,
    icon: const FaIcon(FontAwesomeIcons.bell),
    onPressed: () async {
    final notificationCountNotifier =
        Provider.of<NotificationCountNotifier>(context, listen: false);

    // Reset the notification count
    notificationCountNotifier.resetCount();

    await count
        .fetchInlineCount(
            "/api/push-notificationsMobile?filters[tagsGroups]=")
        .then((result) {
          setState(() {
            // inlineCount = result;
          });
          print('Inline Count: $result'); // Print the result
        }).catchError((error) {
          print('Error: $error'); // Handle errors if any
        });
  
    },
    // color: Color.fromARGB(219, 39, 38, 40),
  ),
)

            ],
          ),
        ),
      
        Expanded(
          child: RefreshIndicator(
            color: const Color.fromARGB(255, 238, 227, 227),
            backgroundColor: const Color(0xFF3A3557),
            onRefresh: () async {
              await Future.delayed(const Duration(
                  milliseconds:
                      200)); // Changed 'microseconds' to 'milliseconds'
              setState(() {});
            },
            child: FutureBuilder<List<PushNotification>>(
              future: httpHandler.fetchData(
                  '/api/push-notificationsMobile?filters[tagsGroups]=${widget.groupsid}&limit=$limit'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('No notifications available.'));
                }
                else {
                  final dateFormat = DateFormat('MMMM d, yyyy');
                  final timeFormat = DateFormat('hh:mm a');
                  // Display the list of notifications
                  final notificationsList = ListView.separated(
                    itemCount: snapshot.data!.length +
                        1, // Add 1 for "See Fewer Notifications"
                    itemBuilder: (context, index) {
                      if (index == snapshot.data!.length) {
                        // This is the last item, add the "See Fewer Notifications" GestureDetector
                        return Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  // Handle the click event for "See Fewer Notifications"
                                  setState(() {
                                    limit = limit + 6;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "See Fewer Notifications",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }

                      final notification = snapshot.data![index];

                      // Format the notification's createdAt date
                      final formattedDate = dateFormat
                          .format(notification.createdAt ?? DateTime.now());

                      // Format the notification's createdAt time
                      final formattedTime = timeFormat
                          .format(notification.createdAt ?? DateTime.now());

                      // Check if the current notification's date is different from the previous one
                      final bool isDifferentDate = index == 0 ||
                          formattedDate !=
                              dateFormat.format(
                                  snapshot.data![index - 1].createdAt ??
                                      DateTime.now());

                      return Column(
                        children: [
                          if (isDifferentDate)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                formattedDate, // Use the formatted date
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: Colors.grey),
                              ),
                            ),
                          GestureDetector(
                         onTap: () {
                              // Handle the click event for "See Fewer Notifications"
                              // setState(() {
                              // limit = limit + 6;
                              print(notification.type);
                              Get.to(TransportDetailSecreen(
                                  notification.category));
                              // });
                            },
                              child: Container(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 6),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20.0),
                                        child: Divider(
                                          endIndent: Get.width * 0.02,
                                          indent: Get.width * 0.02,
                                          height:
                                              0.5, // Adjust the height of the separator as needed
                                          thickness: 1,
                                          color: Color.fromARGB(164, 89, 88,
                                              92), // Customize the color of the separator
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [SizedBox(width:10,),
                                          notification.creatorUserId == null
                                              ? ImageWithDynamicBackgroundColorusersList(
                                                  imageUrl:
                                                      "https://images.unsplash.com/photo-1575936123452-b67c3203c357?auto=format&fit=crop&q=80&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aW1hZ2V8ZW58MHx8MHx8fDA%3D&w=1000",
                                                  isCirculair: true,color: true,
                                                )
                                              : ImageWithDynamicBackgroundColorusersList(
                                                  imageUrl:
                                                      "${baseUrls}${notification.title}",
                                                  isCirculair: true,color: true,
                                                ),
                                          Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: Get.width * 0.8,
                                                    child: Text(
                                                      ' ${notification.message}',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                      width: Get.width * 0.8,
                                                      child: Text(
                                                        " ${notification.title}",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w200),
                                                      ))
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                    
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            DateFormat('EEEE, h:mm a').format(
                                                notification.createdAt!
                                                        .toLocal() ??
                                                    DateTime.now()),
                                          ),
                                          Text(
                                            DateFormat('h:mm a').format(
                                                notification.createdAt!
                                                        .toLocal() ??
                                                    DateTime.now()),
                                          ),
                                         
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )

                              //  Chip(
                              //   avatar: CircleAvatar(
                              //     backgroundImage: NetworkImage(
                              //         "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ2NKsAR38L2Nsk1q1H_u3EWO_oo9ggQwYXig&usqp=CAU"),
                              //   ),
                              //   label: ListTile(
                              //     title: Text(notification.title ?? "title"),
                              //     trailing: notification.type == "Transfer"
                              //         ? Column(
                              //             children: [
                              //               Text("🚍 "),
                              //               SizedBox(
                              //                 height: 20,
                              //               ),
                              //               Text(
                              //                 formatTimestamp(
                              //                     notification.createdAt),
                              //                 style: TextStyle(
                              //                     fontWeight: FontWeight.bold,
                              //                     fontSize: 20),
                              //               )
                              //             ],
                              //           )
                              //         : Text(
                              //             formatTimestamp(notification.createdAt),
                              //             style: TextStyle(
                              //                 fontWeight: FontWeight.bold,
                              //                 fontSize: 20),
                              //           ),
                              //     subtitle: Text(
                              //       notification.message ?? "Message",
                              //       style: TextStyle(
                              //           fontWeight: FontWeight.bold,
                              //           fontSize: 20),
                              //     ),
                              //     //  Text(
                              //     //                               "${notification.message ?? "message"}\n$formattedTime", // Include formatted time
                              //     //                             ),
                              //   ),
                              // ),

                              ),
                        ],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      // This function defines the separators between items.
                      // You can return a widget that represents the separator.
                      return Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: Divider(
                          endIndent: Get.width * 0.02,
                          indent: Get.width * 0.02,
                          height:
                              0.5, // Adjust the height of the separator as needed
                          thickness: 1,
                          color: Color.fromARGB(164, 89, 88,
                              92), // Customize the color of the separator
                        ),
                      );
                    },
                  );

                  return notificationsList;
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 16), // Adjust the spacing as needed
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Row(
                    children: [ const FaIcon(FontAwesomeIcons.bell),
                      Text('  Send Notification'),
                    ],
                  ),
                  content: Container(
                    width: 400, // Adjust the width as needed
                    height: 300, // Adjust the height as needed
                    child: PushNotificationGuideScreen(widget.guid?.id),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        children: [ const FaIcon(FontAwesomeIcons.arrowsTurnRight),
                          Text(' Close'),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
            // Pass the guid to PushNotificationScreen when the button is pressed
            // Get.to(PushNotificationScreen(widget.guid));
            // Get.to(PushNotificationGuideScreen(widget.guid?.id));
          },
          style: ElevatedButton.styleFrom(
            primary:
                const Color(0xFFEB5F52), // Change the button's background color
            fixedSize: const Size(321, 43),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: const Text(
            'Create New Notification',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
