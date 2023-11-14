import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:provider/provider.dart';
import 'package:zenify_app/Secreens/Notification/GuidPushnotification.dart';
import 'package:zenify_app/Secreens/Notification/ImageViewScreen.dart';
import 'package:zenify_app/Secreens/Notification/NotificationDetails.dart';
import 'package:zenify_app/Secreens/Notification/PushNotificationScreen.dart';
import 'package:zenify_app/Secreens/Notification/transferdetailsfromnotification.dart';
import 'package:zenify_app/Secreens/Profile/User_FromNotif.dart';
import 'package:zenify_app/login/Login.dart';
import 'package:zenify_app/modele/HttpUserHandler.dart';
import 'package:zenify_app/modele/TouristGuide.dart';
import 'package:zenify_app/modele/activitsmodel/httpToristGroup.dart';
import 'package:zenify_app/modele/activitsmodel/usersmodel.dart';
import 'package:zenify_app/modele/touristGroup.dart';
import 'package:zenify_app/routes/ScrollControllerProvider.dart';
import 'package:zenify_app/services/ServiceWedget/ImageWithDynamicBackgrounListusers%20copy.dart';

import 'package:zenify_app/services/ServiceWedget/NOtificationUserImage.dart';
import 'package:zenify_app/services/ServiceWedget/NotificationUserImages.dart';
import 'package:zenify_app/services/constent.dart';
import 'package:zenify_app/services/widget/LoadingScreen.dart';
import '../../modele/HttpPushNotification.dart';
import '../../modele/activitsmodel/httpActivites.dart';
import '../../modele/activitsmodel/pushnotificationmodel.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;
import 'package:getwidget/getwidget.dart';
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
  List<TouristGuide>? touristGuides;
  List<TouristGroup>? group;
  List<TouristGroup>? groupOptions = [];
  List<TouristGroup>? touristGroup;
  TouristGroup? selectedTouristGroup = TouristGroup();
  TouristGuide? selectedTouristGuide = TouristGuide();
  int limit = 20;
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;
  String? token;
  String? Url;
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

  final GFBottomSheetController _controller = GFBottomSheetController();
  double threshold = 0.0;
  double threshold1 = 0.0;
  final httpHandlertorist = HTTPHandlerhttpGroup();
  User? selectedUser = User();
  final httpUserHandler = HttpUserHandler();
  List<String> Tags = [];
  @override
  void initState() {
    super.initState();
    fetchDataAndStoreNotifications();
    _loadUser();
    _loadDatagroup();
    initializeMultiSelectItems();
    // controller.addListener(() {
    //   double value = controller.offset;

    //   setState(() {
    //     if (controller.position.didStartScroll == true) {
    //       print("startd");
    //       closeTopContainer = true; // Scrolling up or at the top
    //     } else if (controller.position.didEndScroll == true) {
    //       closeTopContainer = false; // Scrolling down
    //     }
    //   });
    // });
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   controller.addListener(() {
    //     print('scrolling');
    //     setState(() {
    //       closeTopContainer = true;
    //     });
    //   });
    //   controller.position.isScrollingNotifier.addListener(() {
    //     if (!controller.position.isScrollingNotifier.value) {
    //       print('scroll is stopped');
    //       setState(() {
    //         closeTopContainer = false;
    //       });
    //     }
    //     if (controller.offset >= controller.position.maxScrollExtent &&
    //         !controller.position.outOfRange) {
    //       // You've reached the bottom
    //       setState(() {
    //         debugPrint("Reached the bottom");
    //         closeTopContainer = true;
    //       });
    //     } else {
    //       print('scroll is started');
    //       setState(() {
    //         closeTopContainer = false;
    //       });
    //     }
    //   });
    // });
 
  }

  List<PushNotification> notifications = []; // Create an empty list
  Future<void> fetchDataAndStoreNotifications() async {
    try {
      List<PushNotification> fetchedNotifications = await httpHandler.fetchData(
        '/api/push-notificationsMobile?filters[tagsGuide]=${widget.guid?.id}&limit=$limit',
      );

  
        setState(() {
          notifications = fetchedNotifications;
        });
   
    } catch (e) {
      // Handle any potential exceptions here, e.g., network errors.
      print('Error: $e');
    }
  }

  _onStartScroll(ScrollMetrics metrics) {
  
      setState(() {
        closeTopContainer = false;
      });

  }

  _onUpdateScroll(ScrollMetrics metrics) {

      setState(() {
        closeTopContainer = true;
      });

  }

  _onEndScroll(ScrollMetrics metrics) {

      setState(() {
        debugPrint("Reached the bottom");
        closeTopContainer = true;
      });
   
  }

  Map<String, List<String>> selectedTagsMap = {
    "Groupids": [],
  };
  List<MultiSelectItem<TouristGroup>> multiSelectItems = [];
  void initializeMultiSelectItems() {
    if (groupOptions != null) {
      multiSelectItems = group!
          .map(
              (p) => MultiSelectItem<TouristGroup>(p, p.name ?? 'Default Name'))
          .toList();
      Tags = multiSelectItems.map((item) => item.value.id!).toList();
    }
  }

  void _loadDatagroup() async {
    setState(() {
      touristGroup = [];
      group = []; // initialize the list to an empty list
      multiSelectItems = []; // initialize the list to an empty list
    });
    final data = await httpHandlertorist.fetchData(
        "/api/tourist-groups?filters[touristGuideId]=${widget.guid?.id}");

    setState(() {
      touristGroup = data.cast<TouristGroup>();
      selectedTouristGroup = data.first;
      group = touristGroup;
      initializeMultiSelectItems();
    });
  }

  void _loadUser() async {
    token = (await storage.read(key: "access_token"))!;
    Url = await storage.read(key: "baseurl");
    setState(() {
      // users = []; // initialize the list to an empty list
    });
    print("token, $token");
    final userId = await storage.read(key: "id");
    try {
      final user = await httpUserHandler.fetchUser('/api/users/$userId');

      setState(() {
        // users = [user];
        selectedUser = user;
        circular = false;
      });
      if (user.email == null) {
        // ignore: use_build_context_synchronously
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => const CreatProfile()),
        // );
      }
    } catch (error) {
      print('Error loading user: $error');
    }
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Column(
  //     children: [
  //       SizedBox(
  //         height: 20,
  //         child: Row(
  //           crossAxisAlignment: CrossAxisAlignment.stretch,
  //           mainAxisAlignment: MainAxisAlignment.end,
  //           children: [
  //             badges.Badge(
  //               badgeAnimation: BadgeAnimation.rotation(),
  //               position: BadgePosition.topStart(top: 1.5, start: 1),
  //               badgeContent: Consumer<NotificationCountNotifier>(
  //                 builder: (context, notifier, child) {
  //                   final combinedCount = notifier.count;
  //                   return Text(
  //                     '$combinedCount',
  //                     style: TextStyle(
  //                       fontSize: 18,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   );
  //                 },
  //               ),
  //               child: IconButton(
  //                 color: Color.fromARGB(178, 105, 103, 103),
  //                 iconSize: 20,
  //                 icon: const FaIcon(FontAwesomeIcons.bell),
  //                 onPressed: () async {
  //                   final notificationCountNotifier =
  //                       Provider.of<NotificationCountNotifier>(context,
  //                           listen: false);

  //                   // Reset the notification count
  //                   notificationCountNotifier.resetCount();

  //                   await count
  //                       .fetchInlineCount(
  //                           "/api/push-notificationsMobile?filters[tagsGroups]=")
  //                       .then((result) {
  //                     setState(() {
  //                       // inlineCount = result;
  //                     });
  //                     print('Inline Count: $result'); // Print the result
  //                   }).catchError((error) {
  //                     print('Error: $error'); // Handle errors if any
  //                   });
  //                 },
  //                 // color: Color.fromARGB(219, 39, 38, 40),
  //               ),
  //             )
  //           ],
  //         ),
  //       ),

  //       Expanded(
  //         child: RefreshIndicator(
  //           color: const Color.fromARGB(255, 238, 227, 227),
  //           backgroundColor: const Color(0xFF3A3557),
  //           onRefresh: () async {
  //             await Future.delayed(const Duration(
  //                 milliseconds:
  //                     200)); // Changed 'microseconds' to 'milliseconds'
  //             setState(() {});
  //           },
  //            child: NotificationListener<ScrollNotification>(
  //             onNotification: (scrollNotification) {
  //               if (scrollNotification is ScrollStartNotification) {
  //                 _onStartScroll(scrollNotification.metrics);
  //               } else if (scrollNotification is ScrollUpdateNotification) {
  //                 _onUpdateScroll(scrollNotification.metrics);
  //               } else if (scrollNotification is ScrollEndNotification) {
  //                 _onEndScroll(scrollNotification.metrics);
  //               }   return true;
  //             },
  //             child: FutureBuilder<List<PushNotification>>(
  //               future: httpHandler.fetchData(
  //                   '/api/push-notificationsMobile?filters[tagsGuide]=${widget.guid?.id}&limit=$limit'),
  //               builder: (context, snapshot) {
  //                 if (snapshot.connectionState == ConnectionState.waiting) {
  //                   return const Center(child: CircularProgressIndicator());
  //                 } else if (snapshot.hasError) {
  //                   return Center(child: Text('Error: ${snapshot.error}'));
  //                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
  //                   return const Center(
  //                       child: Text('No notifications available.'));
  //                 }
  //             else
  //             {
  //                   final dateFormat = DateFormat('MMMM d, yyyy');
  //                   final timeFormat = DateFormat('hh:mm a');
  //                   // Display the list of notifications
  //                   final notificationsList = ListView.separated(
  //                     itemCount: snapshot.data!.length +
  //                         1, // Add 1 for "See Fewer Notifications"
  //                     itemBuilder: (context, index) {
  //                       if (index == snapshot.data!.length) {
  //                         // This is the last item, add the "See Fewer Notifications" GestureDetector
  //                         return Column(
  //                           children: [
  //                             SizedBox(
  //                               height: 20,
  //                             ),
  //                             Center(
  //                               child: GestureDetector(
  //                                 onTap: () {
  //                                   // Handle the click event for "See Fewer Notifications"
  //                                   setState(() {
  //                                     limit = limit + 6;
  //                                   });
  //                                 },
  //                                 child: Padding(
  //                                   padding: const EdgeInsets.all(8.0),
  //                                   child: Text(
  //                                     "See Fewer Notifications",
  //                                     style: TextStyle(
  //                                         fontWeight: FontWeight.bold,
  //                                         fontSize: 12),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         );
  //                       }

  //                       final notification = snapshot.data![index];

  //                       // Format the notification's createdAt date
  //                       final formattedDate = dateFormat
  //                           .format(notification.createdAt ?? DateTime.now());

  //                       // Format the notification's createdAt time
  //                       final formattedTime = timeFormat
  //                           .format(notification.createdAt ?? DateTime.now());

  //                       // Check if the current notification's date is different from the previous one
  //                       final bool isDifferentDate = index == 0 ||
  //                           formattedDate !=
  //                               dateFormat.format(
  //                                   snapshot.data![index - 1].createdAt ??
  //                                       DateTime.now());

  //                       return Column(
  //                         children: [
  //                           if (isDifferentDate)
  //                             Padding(
  //                               padding: const EdgeInsets.all(8.0),
  //                               child: Text(
  //                                 formattedDate, // Use the formatted date
  //                                 style: TextStyle(
  //                                     fontWeight: FontWeight.w500,
  //                                     fontSize: 12,
  //                                     color: Colors.grey),
  //                               ),
  //                             ),
  //                           GestureDetector(
  //                               onTap: () {
  //                                 // Handle the click event for "See Fewer Notifications"
  //                                 // setState(() {
  //                                 // limit = limit + 6;
  //                                 print(notification.type);
  //                                 Get.to(TransportDetailSecreen(
  //                                     notification.category));
  //                                 // });
  //                               },
  //                               child: Container(
  //                                 child: Padding(
  //                                   padding: EdgeInsets.only(top: 6),
  //                                   child: Column(
  //                                     mainAxisAlignment: MainAxisAlignment.start,
  //                                     children: [
  //                                       Padding(
  //                                         padding:
  //                                             const EdgeInsets.only(bottom: 20.0),
  //                                         child: Divider(
  //                                           endIndent: Get.width * 0.02,
  //                                           indent: Get.width * 0.02,
  //                                           height:
  //                                               0.5, // Adjust the height of the separator as needed
  //                                           thickness: 1,
  //                                           color: Color.fromARGB(164, 89, 88,
  //                                               92), // Customize the color of the separator
  //                                         ),
  //                                       ),
  //                                       Row(
  //                                         mainAxisAlignment:
  //                                             MainAxisAlignment.start,
  //                                         crossAxisAlignment:
  //                                             CrossAxisAlignment.start,
  //                                         children: [
  //                                           SizedBox(
  //                                             width: 10,
  //                                           ),
  //                                           notification.creatorUser?.picture == null
  //                                               ? ImageWithDynamicBackgroundColorusersList(
  //                                                   imageUrl:
  //                                                       "https://images.unsplash.com/photo-1575936123452-b67c3203c357?auto=format&fit=crop&q=80&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aW1hZ2V8ZW58MHx8MHx8fDA%3D&w=1000",
  //                                                   isCirculair: true,
  //                                                 )
  //                                               : ImageWithDynamicBackgroundColorusersList(
  //                                                   imageUrl:
  //                                                       "${baseUrls}/assets/uploads/traveller/${notification.creatorUser?.picture}",
  //                                                   isCirculair: true,
  //                                                 ),
  //                                           Row(
  //                                             children: [
  //                                               Column(
  //                                                 crossAxisAlignment:
  //                                                     CrossAxisAlignment.start,
  //                                                 children: [
  //                                            notification.creatorUser?.firstName!=null?          Container(
  //                                                       width: Get.width * 0.8,
  //                                                       child: Row(
  //                                                         children: [
  //                                                           Text(
  //                                                             "From ",
  //                                                             style: TextStyle(
  //                                                                 fontSize: 20,
  //                                                                 fontWeight:
  //                                                                     FontWeight
  //                                                                         .w500),
  //                                                           ),
  //                                                           Text(
  //                                                             "${notification.creatorUser?.firstName}",
  //                                                             style: TextStyle(
  //                                                                 fontSize: 20,
  //                                                                 fontWeight:
  //                                                                     FontWeight
  //                                                                         .w300,color: Colors.blue),
  //                                                           ),
  //                                                         ],
  //                                                       )):
  //                                                   Container(
  //                                                     width: Get.width * 0.8,
  //                                                     child: Text(
  //                                                       ' ${notification.message}',
  //                                                       style: TextStyle(
  //                                                         fontSize: 20,
  //                                                       ),
  //                                                     ),
  //                                                   ),
  //                                                 Container(
  //                                                       width: Get.width * 0.8,
  //                                                       child: Text(
  //                                                         " ${notification.title}",
  //                                                         style: TextStyle(
  //                                                             fontSize: 16,
  //                                                             fontWeight:
  //                                                                 FontWeight
  //                                                                     .w200),
  //                                                       )),

  //                                                 ],
  //                                               ),
  //                                             ],
  //                                           )
  //                                         ],
  //                                       ),
  //                                       SizedBox(
  //                                         height: 15,
  //                                       ),
  //                                       Row(
  //                                         mainAxisAlignment:
  //                                             MainAxisAlignment.spaceAround,
  //                                         children: [
  //                                           Text(
  //                                             DateFormat('EEEE, h:mm a').format(
  //                                                 notification.createdAt!
  //                                                         .toLocal() ??
  //                                                     DateTime.now()),
  //                                           ),
  //                                           Text(
  //                                             DateFormat('h:mm a').format(
  //                                                 notification.createdAt!
  //                                                         .toLocal() ??
  //                                                     DateTime.now()),
  //                                           ),
  //                                         ],
  //                                       )
  //                                     ],
  //                                   ),
  //                                 ),
  //                               )

  //                               //  Chip(
  //                               //   avatar: CircleAvatar(
  //                               //     backgroundImage: NetworkImage(
  //                               //         "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ2NKsAR38L2Nsk1q1H_u3EWO_oo9ggQwYXig&usqp=CAU"),
  //                               //   ),
  //                               //   label: ListTile(
  //                               //     title: Text(notification.title ?? "title"),
  //                               //     trailing: notification.type == "Transfer"
  //                               //         ? Column(
  //                               //             children: [
  //                               //               Text("🚍 "),
  //                               //               SizedBox(
  //                               //                 height: 20,
  //                               //               ),
  //                               //               Text(
  //                               //                 formatTimestamp(
  //                               //                     notification.createdAt),
  //                               //                 style: TextStyle(
  //                               //                     fontWeight: FontWeight.bold,
  //                               //                     fontSize: 20),
  //                               //               )
  //                               //             ],
  //                               //           )
  //                               //         : Text(
  //                               //             formatTimestamp(notification.createdAt),
  //                               //             style: TextStyle(
  //                               //                 fontWeight: FontWeight.bold,
  //                               //                 fontSize: 20),
  //                               //           ),
  //                               //     subtitle: Text(
  //                               //       notification.message ?? "Message",
  //                               //       style: TextStyle(
  //                               //           fontWeight: FontWeight.bold,
  //                               //           fontSize: 20),
  //                               //     ),
  //                               //     //  Text(
  //                               //     //                               "${notification.message ?? "message"}\n$formattedTime", // Include formatted time
  //                               //     //                             ),
  //                               //   ),
  //                               // ),

  //                               ),
  //                         ],
  //                       );
  //                     },
  //                     separatorBuilder: (BuildContext context, int index) {
  //                       // This function defines the separators between items.
  //                       // You can return a widget that represents the separator.
  //                       return Padding(
  //                         padding: EdgeInsets.only(top: 12),
  //                         child: Divider(
  //                           endIndent: Get.width * 0.02,
  //                           indent: Get.width * 0.02,
  //                           height:
  //                               0.5, // Adjust the height of the separator as needed
  //                           thickness: 1,
  //                           color: Color.fromARGB(164, 89, 88,
  //                               92), // Customize the color of the separator
  //                         ),
  //                       );
  //                     },
  //                   );

  //                   return notificationsList;
  //                 }
  //               },
  //             ),
  //           ),
  //         ),
  //       ),
  //       const SizedBox(height: 16), // Adjust the spacing as needed
  //       ElevatedButton(
  //         onPressed: () {
  //           showDialog(
  //             context: context,
  //             builder: (BuildContext context) {
  //               return AlertDialog(
  //                 title: Row(
  //                   children: [
  //                     const FaIcon(FontAwesomeIcons.bell),
  //                     Text('  Send Notification'),
  //                   ],
  //                 ),
  //                 content: Container(
  //                   width: 400, // Adjust the width as needed
  //                   height: 300, // Adjust the height as needed
  //                   child: PushNotificationGuideScreen(widget.guid?.id),
  //                 ),
  //                 actions: <Widget>[
  //                   TextButton(
  //                     onPressed: () {
  //                       Navigator.of(context).pop();
  //                     },
  //                     child: Row(
  //                       children: [
  //                         const FaIcon(FontAwesomeIcons.arrowsTurnRight),
  //                         Text(' Close'),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               );
  //             },
  //           );
  //           // Pass the guid to PushNotificationScreen when the button is pressed
  //           // Get.to(PushNotificationScreen(widget.guid));
  //           // Get.to(PushNotificationGuideScreen(widget.guid?.id));
  //         },
  //         style: ElevatedButton.styleFrom(
  //           primary:
  //               const Color(0xFFEB5F52), // Change the button's background color
  //           fixedSize: const Size(321, 43),
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(14),
  //           ),
  //         ),
  //         child: const Text(
  //           'Create New Notification',
  //           style: TextStyle(fontSize: 16),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) { final scrollControllerProvider = Provider.of<ScrollControllerProvider>(context);
    final scrollController = scrollControllerProvider.controller;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.addListener(() {
        print('scrolling');
        setState(() {
          closeTopContainer = false;
        });
      });
      controller.position.isScrollingNotifier.addListener(() {
        if (!controller.position.isScrollingNotifier.value) {
          print('scroll is stopped');
          setState(() {
            closeTopContainer = false;
          });
        }
        if (controller.offset >= controller.position.maxScrollExtent &&
            !controller.position.outOfRange) {
          // You've reached the bottom
          setState(() {
            debugPrint("Reached the bottom");
            closeTopContainer = false;
          });
        } else {
          print('scroll is started');
          setState(() {
            closeTopContainer = true;
          });
        }
      });
    });
  
    return Scaffold(
      bottomSheet:
          //  closeTopContainer
          //     ? SizedBox()
          //     :
          Visibility(
        visible:closeTopContainer,
        child: GFBottomSheet(
          controller: _controller,
          maxContentHeight: 100,
          stickyHeaderHeight: 90,
          stickyHeader: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 0)]),
            child: GFListTile(
              icon: InkWell(
                  onTap: () {
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
                            child: PushNotificationGuideScreen(widget.guid?.id),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Row(
                                children: [
                                  const FaIcon(FontAwesomeIcons.close),
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
                  child: FaIcon(FontAwesomeIcons.bell)),
              avatar: InkWell(
                onTap: () {
                  print("tapeddddd");
                  Get.to(ImageViewScreen(
                    "${baseUrls}/assets/uploads/traveller/${selectedUser?.picture}",
                  ));
                },
                child: Container(
                  child: ImageWithDynamicBackgroundColorusersList(
                    imageUrl:
                        "${baseUrls}/assets/uploads/traveller/${selectedUser?.picture}",
                    isCirculair: true,
                    color: false,
                  ),
                ),
              ),
              titleText: 'Create New Notification',
              subTitleText: 'Notifier your groups N°:${group?.length}',
            ),
          ),
          contentBody: Container(
            height: 200,
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: ListView(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              children: [
                Column(
                  children: [
                    Text("Those all of Your Groups"),
                    ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const ScrollPhysics(),
                      itemCount: group?.length,
                      itemBuilder: (context, index) {
                        return Text(
                          ' Group Name (${index + 1}) ${group?[index].name} is_confirmed ${group?[index].confirmed ?? 'N/A'} ',
                          style: TextStyle(
                              fontSize: 14,
                              wordSpacing: 0.3,
                              letterSpacing: 0.2),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          stickyFooter: Container(
            color: Color.fromARGB(0, 27, 6, 221),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
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
                            child: PushNotificationGuideScreen(widget.guid?.id),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Row(
                                children: [
                                  const FaIcon(FontAwesomeIcons.close),
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
                    primary: Color.fromARGB(251, 235, 95,
                        82), // Change the button's background color
                    fixedSize: const Size(321, 43),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Notifiy your Guide ',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                // Text(
                //   'Email us',
                //   style: TextStyle(fontSize: 15, color: const Color.fromARGB(255, 194, 4, 4)),
                // ),
              ],
            ),
          ),
          stickyFooterHeight: 50,
        ),
      ),

      // InkWell(splashColor:Colors.red,focusColor:Colors.red,
      //   child:  Text(
      //     'Create New Notifications',
      //     style: TextStyle(fontSize: 16),
      //   ),
      //   onTap: () {
      //     showDialog(
      //       context: context,
      //       builder: (BuildContext context) {
      //         return AlertDialog(
      //           title: Row(
      //             children: [
      //               const FaIcon(FontAwesomeIcons.bell),
      //               Text('  Send Notification'),
      //             ],
      //           ),
      //           content: Container(
      //             width: 400, // Adjust the width as needed
      //             height: 300, // Adjust the height as needed
      //             child: PushNotificationGuideScreen(widget.guid?.id),
      //           ),
      //           actions: <Widget>[
      //             TextButton(
      //               onPressed: () {
      //                 Navigator.of(context).pop();
      //               },
      //               child: Row(
      //                 children: [
      //                   const FaIcon(FontAwesomeIcons.arrowsTurnRight),
      //                   Text(' Close'),
      //                 ],
      //               ),
      //             ),
      //           ],
      //         );
      //       },
      //     );
      //     // Pass the guid to PushNotificationScreen when the button is pressed
      //     // Get.to(PushNotificationScreen(widget.guid));
      //     // Get.to(PushNotificationGuideScreen(widget.guid?.id));
      //   },
      //   // style: ElevatedButton.styleFrom(
      //   //   primary: const Color(
      //   //       0xFFEB5F52), // Change the button's background color
      //   //   fixedSize: const Size(321, 43),
      //   //   shape: RoundedRectangleBorder(
      //   //     borderRadius: BorderRadius.circular(14),
      //   //   ),
      //   ),
      // child: const Text(
      //   'Create New Notifications',
      //   style: TextStyle(fontSize: 16),
      // ),

      body: 
      RefreshIndicator(
        color: const Color.fromARGB(255, 238, 227, 227),
        backgroundColor: const Color(0xFF3A3557),
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 200));
          setState(() {
            fetchDataAndStoreNotifications();
          });
        },
        child: ListView.builder(
          controller: controller,
          itemCount: notifications.length + 1,
          itemBuilder: (context, index) {
            if (index == notifications.length) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        limit = limit + 6;
                        fetchDataAndStoreNotifications();
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        textAlign: TextAlign.center,
                        "See Fewer Notifications",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }

            final notification = notifications[index];

            final dateFormat = DateFormat('MMMM d, yyyy');
            final timeFormat = DateFormat('hh:mm a');
            final formattedDate =
                dateFormat.format(notification.createdAt ?? DateTime.now());
            final formattedTime =
                timeFormat.format(notification.createdAt ?? DateTime.now());

            final bool isDifferentDate = index == 0 ||
                formattedDate !=
                    dateFormat.format(
                        notifications[index - 1].createdAt ?? DateTime.now());

            return Column(
              children: [
                if (isDifferentDate)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      formattedDate,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                GestureDetector(
                  onTap: () {
                    print(notification.type);
                    // Replace with your navigation logic to 'TransportDetailSecreen'
                    // Get.to(TransportDetailSecreen(notification.category));
                  },
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Divider(
                              endIndent: Get.width * 0.02,
                              indent: Get.width * 0.02,
                              height: 0.5,
                              thickness: 1,
                              color: Color.fromARGB(164, 89, 88, 92),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(width: 10),
                              notification.creatorUser?.picture == null
                                  ? NotificationUserImage(
                                      imageUrl:
                                          "https://images.unsplash.com/photo-1575936123452-b67c3203c357?auto=format&fit=crop&q=80&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aW1hZ2V8ZW58MHx8MHx8fDA%3D&w=1000",
                                      isCirculair: true,
                                    )
                                  :
                                  // InkWell(onTap: () => Get.to(UserfromNotification(notification.creatorUser )),
                                  //   child:
                                  NotificationUserImage(
                                      imageUrl:
                                          "${baseUrls}/assets/uploads/traveller/${notification.creatorUser?.picture}",
                                      isCirculair: true,
                                      createduser: notification.creatorUser,
                                    ),
                              // ),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (notification.creatorUser?.firstName !=
                                          null)
                                        Container(
                                          width: Get.width * 0.8,
                                          child: Row(
                                            children: [
                                              Text(
                                                "From ",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                "${notification.creatorUser?.firstName}",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      else
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
                                            fontSize: 16,
                                            fontWeight: FontWeight.w200,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                DateFormat('EEEE, h:mm a').format(
                                    notification.createdAt!.toLocal() ??
                                        DateTime.now()),
                              ),
                              Text(
                                DateFormat('h:mm a').format(
                                    notification.createdAt!.toLocal() ??
                                        DateTime.now()),
                              ),
                            ],
                          ),
                          //       const SizedBox(height: 16), // Adjust the spacing as needed
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }}

