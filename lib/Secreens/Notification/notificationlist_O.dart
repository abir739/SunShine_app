import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:provider/provider.dart';
import 'package:SunShine/Secreens/Notification/GuidPushnotification.dart';
import 'package:SunShine/Secreens/Notification/ImageViewScreen.dart';
import 'package:SunShine/login/Login.dart';
import 'package:SunShine/modele/HttpUserHandler.dart';
import 'package:SunShine/modele/TouristGuide.dart';
import 'package:SunShine/modele/activitsmodel/httpToristGroup.dart';
import 'package:SunShine/modele/activitsmodel/usersmodel.dart';
import 'package:SunShine/modele/touristGroup.dart';
import 'package:SunShine/routes/ScrollControllerProvider.dart';
import 'package:SunShine/services/ServiceWedget/ImageWithDynamicBackgrounListusers%20copy.dart';
import 'package:SunShine/services/ServiceWedget/NOtificationUserImage.dart';
import 'package:SunShine/services/constent.dart';
import '../../modele/HttpPushNotification.dart';
import '../../modele/activitsmodel/httpActivites.dart';
import '../../modele/activitsmodel/pushnotificationmodel.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

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
      if (user.email == null) {}
    } catch (error) {
      print('Error loading user: $error');
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
      bottomSheet: Visibility(
        // visible: closeTopContainer,
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
                              Text('Envoyer'),
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
                                  Text(' Fermer'),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    );
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
              titleText: 'Créer une nouvelle notification',
              subTitleText: 'Notifiez vos groupes N°:${group?.length}',
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
                    Text("C'est tous vos groupes"),
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
                              Text('  Envoyer '),
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
                                  Text(' Fermer'),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    );
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
                    'Informez vos Clients ',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          stickyFooterHeight: 50,
        ),
      ),
      body: RefreshIndicator(
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
                        "Voir moins de notifications",
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
                                  : NotificationUserImage(
                                      imageUrl:
                                          "${baseUrls}/assets/uploads/traveller/${notification.creatorUser?.picture}",
                                      isCirculair: true,
                                      createduser: notification.creatorUser,
                                    ),
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
                                                "Depuis ",
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
  }
}
