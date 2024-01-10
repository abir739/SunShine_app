import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:SunShine/Secreens/Notification/NotificationCountNotifierProvider.dart';

import 'package:SunShine/Secreens/Notification/transferdetailsfromnotification.dart';
import 'package:SunShine/Secreens/TravelerProvider.dart';
import 'package:SunShine/modele/traveller/TravellerModel.dart';
import 'package:SunShine/services/ServiceWedget/ImageWithDynamicBackgrounListusers%20copy.dart';

import 'package:SunShine/services/constent.dart';
import '../../modele/HttpPushNotification.dart';
import '../../modele/activitsmodel/httpActivites.dart';
import '../../modele/activitsmodel/pushnotificationmodel.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import 'package:badges/badges.dart' as badges;

import '../Secreens/Notification/Traveller_Notifier-Guid.dart';

class NotificationScreen extends StatelessWidget {
  String? groupsid;

  NotificationScreen({required this.groupsid});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationList(groupsid: groupsid),
    );
  }
}

class NotificationList extends StatefulWidget {
  @override
  String? groupsid;
  NotificationList({required this.groupsid});
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  final httpHandler = HTTPHandlerPushNotification();
  final count = HTTPHandlerCount();
  int limit = 12;
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;
  late List<DateTime> _currentViewVisibleDates;
  String? travellergroupId = "";
  Traveller? traveller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _initializeTravelerData();
    _initializeTravelerDataDetalis();
    controller.addListener(() {
      double value = controller.offset / 119;

      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 200;

        // Timer(Duration(microseconds: 1), () {
        //   // This function will be executed after 1 second

        //   // Update the UI or perform any action here
        //   setState(() {
        //     hideitem = closeTopContainer;
        //     // Modify your UI state here
        //     // For example, set a flag or update a variable to hide an item
        //   });
        // });
      });
    });
  }

  // Future<void> _initializeTravelerData() async {
  //   final travelerProvider =
  //       Provider.of<TravelerProvider>(context, listen: false);

  //   try {
  //     final result = await travelerProvider.loadTravelerData();
  //     setState(() {
  //       travellergroupId = result;
  //     });
  //   } catch (error) {
  //     // Handle the error as needed
  //     print("Error initializing traveler data: $error");
  //   }

  //   // Other initialization code if needed
  // }

  Future<void> _initializeTravelerDataDetalis() async {
    final travelerProvider =
        Provider.of<TravelerProvider>(context, listen: false);

    try {
      final result = await travelerProvider.loadTraveler();
      setState(() {
        traveller = result;
      });
    } catch (error) {
      // Handle the error as needed
      print("Error initializing traveler data: $error");
    }

    // Other initialization code if needed
  }

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
    return Column(
      children: [
        closeTopContainer
            ? SizedBox()
            : SizedBox(
                height: 20,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    badges.Badge(
                      badgeAnimation: badges.BadgeAnimation.rotation(),
                      position:
                          badges.BadgePosition.topStart(top: 1.5, start: 1),
                      badgeContent: FutureBuilder<int>(
                        future: count.fetchInlineCount(
                          "/api/push-notificationsMobile?filters[tagsGroups]=${travellergroupId}",
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            // Display a loading indicator while fetching the inline count
                            return SizedBox();
                            // IconButton(
                            //   color: Color.fromARGB(255, 8, 8, 8),
                            //   iconSize: 20,
                            //   icon: const FaIcon(FontAwesomeIcons.bell),
                            //   onPressed: () async {
                            //     await count
                            //         .fetchInlineCount(
                            //             "/api/push-notificationsMobile?filters[tagsGroups]")
                            //         .then((result) {
                            //       setState(() {
                            //         // inlineCount = result;
                            //       });
                            //       print('Inline Count: $result'); // Print the result
                            //     }).catchError((error) {
                            //       print('Error: $error'); // Handle errors if any
                            //     });
                            //     // Get.toNamed('notificationScreen', arguments: {
                            //     //   'touristGroupId': traveller.touristGroupId
                            //     // });
                            //     // });
                            //   },
                            //   // color: Color.fromARGB(219, 39, 38, 40),
                            // );
                          }
                          if (snapshot.hasError) {
                            // Handle the error if the inline count couldn't be fetched
                            return Text(
                              '0',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          final apiCount = snapshot.data ?? 0;

                          // Use the apiCount value here

                          // Return your widget, e.g., combine it with the Consumer widget
                          return Consumer<NotificationCountNotifier>(
                            builder: (context, notifier, child) {
                              // Display the notification count using Text widget
                              final combinedCount = apiCount + notifier.count;
                              // Save the combined count to SharedPreferences

                              // prefs.setInt('notificationCount', combinedCount);
                              if (combinedCount > (apiCount + notifier.count)) {
                                final resulta = combinedCount;
                                setState(() {});
                                return Text(
                                  '${notifier.count.abs()}',
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                );
                              } else {
                                final reset = combinedCount - apiCount;

                                return Text(
                                  '${reset.abs()}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                );
                              }
                            },
                          );
                        },
                      ),
                      child: IconButton(
                        color: Color.fromARGB(178, 105, 103, 103),
                        iconSize: 20,
                        icon: const FaIcon(FontAwesomeIcons.bell),
                        onPressed: () async {
                          await count
                              .fetchInlineCount(
                                  "/api/push-notificationsMobile?filters[tagsGroups]=${travellergroupId}")
                              .then((result) {
                            setState(() {
                              // inlineCount = result;
                            });
                            print('Inline Count: $result'); // Print the result
                          }).catchError((error) {
                            print('Error: $error'); // Handle errors if any
                          });
                          // Get.toNamed('notificationScreen', arguments: {
                          //   'touristGroupId': traveller.touristGroupId
                          // });
                          // });
                        },
                        // color: Color.fromARGB(219, 39, 38, 40),
                      ),
                    ),
                  ],
                ),
              ),
        Expanded(
          child: RefreshIndicator(
            color: Color.fromARGB(255, 238, 227, 227),
            backgroundColor: Colors.transparent,
            onRefresh: () async {
              // Implement your refresh logic here
              await Future.delayed(
                  Duration(microseconds: 200)); // Simulate a delay
              setState(() {}); // Trigger a rebuild of the widget
            },
            child: FutureBuilder<List<PushNotification>>(
              future: httpHandler.fetchData(
                  '/api/push-notificationsMobile?filters[tagsGroups]=${traveller?.touristGroupId}'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No notifications available.'));
                } else {
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
                                        children: [
                                          SizedBox(
                                            width: 10,
                                          ),
                                          notification.creatorUserId == null
                                              ? ImageWithDynamicBackgroundColorusersList(
                                                  imageUrl:
                                                      "https://images.unsplash.com/photo-1575936123452-b67c3203c357?auto=format&fit=crop&q=80&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aW1hZ2V8ZW58MHx8MHx8fDA%3D&w=1000",
                                                  isCirculair: true,
                                                  color: true,
                                                )
                                              : ImageWithDynamicBackgroundColorusersList(
                                                  imageUrl:
                                                      "${baseUrls}${notification.title}",
                                                  isCirculair: true,
                                                  color: true,
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
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Row(
                    children: [
                      const FaIcon(FontAwesomeIcons.bell),
                      Text('  Send Notification'),
                    ],
                  ),
                  content: Container(
                    width: 400, // Adjust the width as needed
                    height: 300, // Adjust the height as needed
                    child: TravellerNotifierGuide(),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        children: [
                          const FaIcon(FontAwesomeIcons.arrowsTurnRight),
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
            'Notifiy your Guide ',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
