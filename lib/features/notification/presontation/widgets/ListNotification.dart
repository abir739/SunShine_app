import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/bottom_sheet/gf_bottom_sheet.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:provider/provider.dart';
import 'package:SunShine/Secreens/Notification/GuidPushnotification.dart';
import 'package:SunShine/Secreens/Notification/ImageViewScreen.dart';
import 'package:SunShine/features/notification/domain/entites/notification.dart'
    as not;
import 'package:SunShine/features/notification/presontation/bloc/NotificationsBlocs/notifications_bloc.dart';
import 'package:SunShine/features/notification/presontation/pages/Notification_detail_page.dart';
import 'package:SunShine/login/Login.dart';
import 'package:SunShine/modele/HttpUserHandler.dart';
import 'package:SunShine/modele/activitsmodel/usersmodel.dart';
import 'package:SunShine/routes/ScrollControllerProvider.dart';
import 'package:SunShine/services/ServiceWedget/ImageWithDynamicBackgrounListusers%20copy.dart';
import 'package:SunShine/services/ServiceWedget/NotificationUserImage.dart';
import 'package:SunShine/services/constent.dart';
import 'package:intl/intl.dart';

class ListNotificationWidget extends StatefulWidget {
  final List<not.Notification> notifications;
  ListNotificationWidget({Key? key, required this.notifications})
      : super(key: key);

  @override
  _ListNotificationWidgetState createState() => _ListNotificationWidgetState();
}

class _ListNotificationWidgetState extends State<ListNotificationWidget> {
  int limit = 12;
  late ScrollController controller;
  bool closeTopContainer = false;
  double topContainer = 0;
  String? token;
  String? Url;
  late List<DateTime> _currentViewVisibleDates;
  String? travellergroupId = "";
  User? selectedUser = User();
  final httpUserHandler = HttpUserHandler();
  final GFBottomSheetController _controller = GFBottomSheetController();
  @override
  void initState() {
    super.initState();
    _loadUser();
    controller = ScrollController();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
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
    final scrollControllerProvider =
        Provider.of<ScrollControllerProvider>(context);
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
        visible: closeTopContainer,
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
                            child: PushNotificationGuideScreen(""),
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
              subTitleText: 'Notifier your groups N°:',
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
                    // ListView.builder(
                    //   shrinkWrap: true,
                    //   scrollDirection: Axis.vertical,
                    //   physics: const ScrollPhysics(),
                    //   itemCount: group?.length,
                    //   itemBuilder: (context, index) {
                    //     return Text(
                    //       ' Group Name (${index + 1}) ${group?[index].name} is_confirmed ${group?[index].confirmed ?? 'N/A'} ',
                    //       style: TextStyle(
                    //           fontSize: 14,
                    //           wordSpacing: 0.3,
                    //           letterSpacing: 0.2),
                    //     );
                    //   },
                    // ),
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
                            child:
                                PushNotificationGuideScreen("widget.guid?.id"),
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
      body: ListView.builder(
        controller: controller,
        itemCount: widget.notifications.length + 1,
        itemBuilder: (context, index) {
          if (index == widget.notifications.length) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    BlocProvider.of<NotificationsBloc>(context)
                        .add(GetAllNotificationsEvent(index: index + 5));
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

          final notification = widget.notifications[index];

          final dateFormat = DateFormat('MMMM d, yyyy');
          final timeFormat = DateFormat('hh:mm a');
          final formattedDate =
              dateFormat.format(notification.createdAt ?? DateTime.now());
          final formattedTime =
              timeFormat.format(notification.createdAt ?? DateTime.now());

          final bool isDifferentDate = index == 0 ||
              formattedDate !=
                  dateFormat.format(widget.notifications[index - 1].createdAt ??
                      DateTime.now());

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
                // onTap: () {
                //   print(notification.type);
                //   // Replace with your navigation logic to 'TransportDetailSecreen'
                //   // Get.to(TransportDetailSecreen(notification.category));
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NotificationDetailPage(
                          notification: widget.notifications[index]),
                    ),
                  );
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
                            // notification.creatorUser?.picture == null?
                            //      NotificationUserImage(
                            //         imageUrl:
                            //             "https://images.unsplash.com/photo-1575936123452-b67c3203c357?auto=format&fit=crop&q=80&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aW1hZ2V8ZW58MHx8MHx8fDA%3D&w=1000",
                            //         isCirculair: true,
                            //       )
                            //  :
                            ClipOval(
                              child: CachedNetworkImage(
                                height: 40,
                                width: 40,
                                cacheManager: CacheManager(Config(
                                  "fluttercampus",
                                  stalePeriod: const Duration(days: 7),
                                  //one week cache period
                                )),
                                imageUrl:
                                    "${baseUrls}/assets/uploads/traveller/${notification.creatorUser?.picture}",
                                fadeInCurve: Curves.fastOutSlowIn,
                                placeholder: (context, url) => SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: Icon(
                                    Icons.face,
                                    color: Colors.white30,
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.black87,
                                  width: 30,
                                  height: 30,
                                  child: Icon(
                                    Icons.face,
                                    color: Colors.white30,
                                  ),
                                ),
                              ),
                            )
                            // SizedBox(height: 20,width: 20,
                            //                            child: FittedBox(
                            //                              child: Container(
                            //                                child: CachedNetworkImage(
                            //                                      imageUrl: "https://www.fluttercampus.com/img/logo_small.webp",
                            //                                      placeholder: (context, url) => CircularProgressIndicator(backgroundColor: Colors.red),
                            //                                      errorWidget: (context, url, error) => Icon(Icons.error),
                            //                                  cacheManager: CacheManager(
                            //     Config(
                            //       "fluttercampus",
                            //       stalePeriod: const Duration(days: 7),
                            //       //one week cache period
                            //     )
                            // ), ),
                            //                              ),
                            //                            ),
                            //                          ),
                            // :
                            // // InkWell(onTap: () => Get.to(UserfromNotification(notification.creatorUser )),
                            // //   child:
                            // NotificationUserImage(
                            //     imageUrl:
                            //         "${baseUrls}/assets/uploads/traveller/${notification.creatorUser?.picture}",
                            //     isCirculair: true,
                            //     createduser: notification.creatorUser,
                            //   ),
                            // ),
                            ,
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
    );

    //  ListView.separated(
    //   separatorBuilder: (context, index) => Divider(height: 5),
    //   itemBuilder: (context, index) {
    //     return ListTile(
    //         leading: Text(notifications[index].title.toString()),
    //         title: Text(
    //           notifications[index].message.toString(),
    //         ));
    //   },
    //   itemCount: notifications.length,
    // );
  }
}
