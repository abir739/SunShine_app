import 'dart:async';
import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:gap/gap.dart';
import 'package:cr_calendar/cr_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/bottom_sheet/gf_bottom_sheet.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:get/get.dart';
import 'package:zenify_app/Secreens/CustomCalendarDataSource.dart';
import 'package:zenify_app/Secreens/widgetCard/cardClass.dart';
import 'package:zenify_app/Settings/AppSettings.dart';
import 'package:zenify_app/guide_Screens/ItemDetailsScreen.dart';
import 'package:zenify_app/modele/Event/Event.dart';
import 'package:zenify_app/modele/HttpTravellerssHandel.dart';
import 'package:zenify_app/modele/activitsmodel/activitesmodel.dart';
import 'package:zenify_app/modele/activitsmodel/httpActivites.dart';
import 'package:zenify_app/modele/activitsmodel/usersmodel.dart';
import 'package:zenify_app/modele/httpTasks.dart';
import 'package:zenify_app/modele/tasks/taskModel.dart';
import 'package:zenify_app/modele/transportmodel/ApiResponse.dart';
import 'package:zenify_app/modele/traveller/TravellerModel.dart';
import 'package:zenify_app/routes/ScrollControllerProvider.dart';
import 'package:zenify_app/routes/SettingsProvider.dart';
import 'package:zenify_app/services/GuideProvider.dart';
import 'package:zenify_app/services/ServiceWedget/ImageWithDynamicBackgrounListusers%20copy.dart';
import 'package:zenify_app/services/constent.dart';
import 'package:zenify_app/services/widget/LoadingScreen.dart';
import 'package:zenify_app/theme.dart';

import '../modele/accommodationsModel/accommodationModel.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:get/get.dart';
import '../modele/transportmodel/transportModel.dart';

import 'package:flutter/material.dart';
// import 'package:time_planner/time_planner.dart';

class GuidCalanderSecreen extends StatefulWidget {
  // String? Plannigid;

  @override
  GuidCalanderSecreen({Key? key}) : super(key: key);
  _GuidCalanderSecreenState createState() => _GuidCalanderSecreenState();
}

class Item {
  String? name;
  bool? selected;

  Item({
    this.name,
    this.selected = false,
  });
}

class _GuidCalanderSecreenState extends State<GuidCalanderSecreen> {
  ScrollController controller = ScrollController();
  ScrollController controllerCalander = ScrollController();
  final storage = const FlutterSecureStorage();
  bool closeTopContainer = false;
  double topContainer = 0;
  late List<DateTime> _currentViewVisibleDates;
  final CalendarController _controller = CalendarController();
  String? _headerText = '';
  String? date;
  List<Tasks> tasks = [];
  int flex = 2;
  bool ViewChanged = false;
  final GFBottomSheetController _gFBottomSheetController =
      GFBottomSheetController();
  double? _width = 0.0, cellWidth = 0.0;
  String _string = '';
  List<Activity>? activityList = [];
  List<Accommodations> accommodationList = [];
  List<Transport> transferList = [];
  final List<Map<String, dynamic>> travelersData = [];
  int selectedIndex = 0;
  Widget? card;
  HTTPHandlerActivites activiteshanhler = HTTPHandlerActivites();
  // HTTPHandleUsers usershandler = HTTPHandleUsers();
  HTTPHandlerTasks taskshanhler = HTTPHandlerTasks();
  List<Activity> Activityst = [];
  List<Tasks>? taskslist = [];
  List<String> userImages = [];
  double activityProgress = 0.0;
  List<User>? users;
  List<Traveller>? travellers;
  final travellersH = HTTPHandleTravellers();
  Map<CalendarEvent, Color> eventColors = {};
  double gethigth = Get.height * 0.185 / Get.height;
  List<Transport>? transfersList = [];
  final List<Appointment> appointments = [];
  final List<Appointment> _appointmentDetails = <Appointment>[];
  bool isweek = true;
  CalendarView currentView = CalendarView.month;
  // List<CalendarEvent> CalendarEvents = [];
  String dateString = DateTime.now().toString();
  // DateTime initialDate = DateTime.parse(dateString);
  // CalendarController calendarController = CalendarController();
  // List<CalendarEvent> calendarEvents = [];
  Map<DateTime, List<CalendarEvent>> eventsByDate = {};
  Map<String, Map<String, List<String>>> groupedTravelerImages = {};
  final List<String> viewOptions = ['Day', 'Week', 'Month', 'All DAta'];
  String selectedView = 'Month'; // Default selected view is Month
  Color ActivityColor = Color.fromARGB(255, 21, 19, 1);
  Color tranfercolor = Color.fromARGB(255, 21, 19, 1);
  bool loading = false;
  bool hideitem = false;
  String? guideid = "";
  List<String> groupIdsList = [];
  List<Traveller> travelersWithNonNullPictures = [];
  late Future<List<Transport>> _transportsFuture;
  _DataSource? calendarDataSource;
  // int completedCount = 0;
  Color cardcolor = Color.fromARGB(255, 21, 19, 1);
  List<Map<String, dynamic>> travelerss = [];
  List<Item> items = [
    Item(name: 'Activity', selected: false),
    Item(name: 'Task', selected: false),
    Item(name: 'Transfer', selected: false),
  ];
  Item? selitems;
  @override
  void initState() {
    super.initState();
    _initializeTravelerData();
    fetchTravelers();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   controllerCalander.addListener(() {
    //     print('scrolling');
    //     if (mounted) {
    //       setState(() {
    //         ViewChanged = true;
    //       });
    //     }
    //   });
    //   controllerCalander.position.isScrollingNotifier.addListener(() {
    //     if (!controllerCalander.position.isScrollingNotifier.value) {
    //       print('scroll is stopped');
    //       setState(() {
    //         // closeTopContainer = false;
    //       });
    //     }
    //     if (controllerCalander.offset >=
    //             controllerCalander.position.maxScrollExtent &&
    //         !controllerCalander.position.outOfRange) {
    //       // You've reached the bottom
    //       setState(() {
    //         debugPrint("Reached the bottom");
    //         // closeTopContainer = true;
    //       });
    //     } else {
    //       print('scroll is started');
    //       setState(() {
    //         ViewChanged = true;
    //       });
    //     }
    //   });
    // });
  
    _currentViewVisibleDates = [DateTime.now()];
    final eventColorProvider =
        Provider.of<SettingsProvider>(context, listen: false);
    final activitycolor =
        Provider.of<AppSettingsLoader>(context, listen: false);
    activitycolor.loadActivityColor().then((loadedColor) {
      if (loadedColor != null) {
        setState(() {
          ActivityColor = loadedColor;
        });
      }
    });
    final trasfercolor = Provider.of<AppSettingsLoader>(context, listen: false);
    activitycolor.loadTranferColor().then((loadedColor) {
      if (loadedColor != null) {
        setState(() {
          tranfercolor = loadedColor;
        });
      }
    });
    // fetchData();
    // fetchDataAndOrganizeEvents();_transportsFuture =
    //  transfersList1= fetchTransfers("/api/transfers/touristGuidId/${widget.guid!.id}") as List<Transport>;
    // _getCalendarDataSources();
  }

  Future<void> fetchTravelers() async {
    try {
      final travelersData = await fetchTravelersByGroupIds(groupIdsList);
      setState(() {
        travelerss = travelersData;
      });
    } catch (e) {
      // Handle errors as needed
    }
  }

  Future<void> fetchTasks() async {
    String? token = await storage.read(key: "access_token");
    String formatter(String url) {
      return baseUrls + url;
    }

    String url = formatter("/api/tasks?filters[touristGuideId]=$guideid");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> results = data["results"];
      tasks = results.map((groupData) => Tasks.fromJson(groupData)).toList();
      // Update the data source
      setState(() {});
    } else {
      print("Error fetching tourist groups: ${response.statusCode}");
      // Handle error here
    }
  }

  Future<List<Map<String, dynamic>>> fetchTravelersByGroupIds(
      List<String> groupIds) async {
    print("groupIdsgroupIds $groupIds");
    final groupIdsQueryParam = groupIds.map((id) => 'ids=$id').join('&');
    print("groupIdsQueryParam $groupIdsQueryParam");
    final response = await http.get(
        Uri.parse('${baseUrls}/api/travellers-mobile?$groupIdsQueryParam'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final results = jsonResponse['results'] as List;
      final List<String> userIds = results.map((result) {
        if (result.containsKey('userId')) {
          return result['userId'] as String;
        } else {
          return '';
        }
      }).toList();

      // Now, userIds list contains all the user IDs
      print("User IDs: $userIds");

      // Continue processing the results or return them as needed

      print(
          "Received travelers data: $results"); // Print the travelers data received

      return results.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load travelers');
    }
  }

  Future<void> _initializeTravelerData() async {
    final travelerProvider = Provider.of<guidProvider>(context, listen: false);

    try {
      final result = await travelerProvider.loadDataGuid();
      print("result");
      setState(() {
        guideid = result;
      });
    } catch (error) {
      // Handle the error as needed
      print("Error initializing traveler data: $error");
    }

    await _initializeData();
    try {
      print("First User's Email:$guideid");

      final Guide = await travelerProvider.loadDataGuidDetail();
      travellers = await travellersH.fetchData(
          "/api/travellers"); // Replace "/api/user/123" with your actual user data endpoint
      // Other initialization code if needed
      travelersWithNonNullPictures = travellers!
          .where((traveler) => traveler.user?.picture != null)
          .toList();

      // Access the first user's email
      String? images = travellers![0].user?.picture;
    } catch (e) {}
  }

  Future<void> fetchData() async {
    try {
      // Fetch transferList
      transferList =
          await fetchTransfers("/api/transfers/touristGuidId/$guideid");
    } catch (e) {
      // Handle error for transferList
      print("Error fetching transfer data: $e");
      // Handle error for transferList as needed, e.g., show an error message.
    }

    try {
      // Fetch Activityst with a specific touristGroupId
      Activityst = await activiteshanhler
          .fetchData("/api/activities?filters[touristGuideId]=$guideid");
    } catch (e) {
      // Handle error for Activityst
      print("Error fetching activity data: $e");
      // Handle error for Activityst as needed, e.g., show an error message.
    }
    try {
      // Fetch Activityst with a specific touristGroupId
      taskslist = await taskshanhler
          .fetchData("/api/tasks?filters[touristGuideId]=$guideid");
    } catch (e) {
      // Handle error for Activityst
      print("Error fetching task data: $e");
      // Handle error for Activityst as needed, e.g., show an error message.
    }
    // Now you have both transferList and Activityst fetched and can use them as needed.
    setState(() {
      // List<CalendarEvent> events =
      //     convertToCalendarEvents(transferList, Activityst, taskslist);
      // Update any state variables with the events.
    });
  }

  Future<void> _refrech() async {
    List<Transport> transfersList1 =
        await fetchTransfers("/api/transfers/touristGuidId/$guideid");
    List<Activity> Activityst1 = await activiteshanhler
        .fetchData("/api/activities?filters[touristGuideId]=$guideid");
    List<Tasks> taskslist1 = await taskshanhler
        .fetchData("/api/tasks?filters[touristGuideId]=$guideid");
    // _getCalendarDataSources(transfersList1);

    setState(() {
      calendarDataSource!.appointments?.clear();

      print("data refreshed");
      transfersList = transfersList1;
      activityList = Activityst1;
      taskslist = taskslist1;
      // scheduleAlarms(transfersList1);
      calendarDataSource =
          _getCalendarDataSources(transfersList1, Activityst1, taskslist1);
    });
  }

  Future<void> _initializeData() async {
    List<Transport>? transfersList1;
    List<Activity>? Activityst1;
    List<Tasks>? taskslist1;
    try {
      transfersList1 = await fetchTransfers("/api/transfers/");
    } catch (e) {
      // Handle the exception here, and assign an empty list to transfersList1.
      print("An exception occurred: $e");
      transfersList1 = [];
    }
    try {
      Activityst1 = await activiteshanhler
          .fetchData("/api/activities?filters[touristGuideId]=$guideid");
      print("An exception occurred Activity: 1 ");
    } catch (e) {
      // Handle the exception here, and assign an empty list to transfersList1.
      print("An exception occurred Activity: $e");
      Activityst1 = [];
    }
    try {
      taskslist1 = await taskshanhler
          .fetchData("/api/tasks?filters[touristGuideId]=$guideid");
    } catch (e) {
      // Handle the exception here, and assign an empty list to transfersList1.
      print("An exception occurred: $e");
      taskslist1 = [];
    }

    // try {
    //   for (Transport? transfer in transfersList1 ?? []) {
    //     if (transfer != null) {
    //       // Use a Set to ensure unique group IDs
    //       Set<String> uniqueGroupIds = Set();

    //       for (TouristGroup? group in transfer.touristGroups ?? []) {
    //         if (group != null) {
    //           String groupId = group.id ?? '';
    //           print(groupId);
    //           // Add the group ID to the Set to ensure uniqueness
    //           uniqueGroupIds.add(groupId);
    //         }
    //       }

    //       // Add the unique group IDs to the groupIdsList
    //       groupIdsList.addAll(uniqueGroupIds);
    //       print("$groupIdsList groupIdsList");
    //       List<String> uniqueGroupIdsList = uniqueGroupIds.toList();
    //       print("uniqueGroupIdsList $uniqueGroupIdsList");
    //       // Fetch travelers for all unique group IDs
    //       List<Map<String, dynamic>> travelers =
    //           await fetchTravelersByGroupIds(uniqueGroupIdsList);
    //       print("TravelersDetail: $travelers");

    //       // Filter relevant travelers based on the unique group IDs
    //       List<Map<String, dynamic>> relevantTravelers = travelers
    //           .where((traveler) =>
    //               uniqueGroupIdsList.contains(traveler['touristGroupId']))
    //           .toList();

    //       travelersData.addAll(relevantTravelers);
    //       print("Updated travelersData: $travelersData");
    //     }
    //   }
    // } catch (e) {
    //   print("An error occurred: $e");
    //   // Handle the error or take appropriate action
    // }

    setState(() {
      print("data refreshed");
      transfersList = transfersList1;
      activityList = Activityst1;
      taskslist = taskslist1;
      // scheduleAlarms(transfersList1);
      calendarDataSource =
          _getCalendarDataSources(transfersList1, Activityst1, taskslist1);
    });
  }
  // double calculateCompletedActivities(List<Activity> activities) {
  //   // int completedCount = 0;

  //   for (var activity in activities) {
  //     completedCount++;
  //   }

  //   return completedCount.toDouble();
  // }
  List<CalendarEvent> convertToCalendarEvents(List<Transport>? transfers,
      List<Activity> activities, List<Tasks> taskslists) {
    List<CalendarEvent> events = [];

    for (var transfer in transfers!) {
      events.add(CalendarEvent(
        title: "T-R ${transfer.note}",
        id: transfer.id,
        description: "Transfer Guid",
        startTime: transfer.date,
        type: transfer,
        endTime:
            transfer.date!.add(Duration(hours: transfer.durationHours ?? 0)),
        color: Color.fromARGB(200, 2, 152, 172),
      ));
    }
    for (var activty in activities) {
      events.add(CalendarEvent(
        title: "Ac",
        id: activty.id,
        description: "Activity Guid",
        type: activty,
        startTime: activty.departureDate ?? DateTime.now(),
        endTime: activty.returnDate ?? DateTime.now().add(Duration(hours: 5)),
        color: Color.fromARGB(214, 235, 6, 75),
      ));
    }
    for (var taskslist in taskslists) {
      events.add(CalendarEvent(
        title: "task",
        id: taskslist.id,
        description: " Guid Task",
        type: taskslist,
        startTime: taskslist.todoDate ?? DateTime.now(),
        endTime: taskslist.todoDate!.add(Duration(days: 1)),
        color: Color.fromARGB(214, 235, 6, 75),
      ));
    }
    return events;
  }
  // List<CalendarEvent> convertToCalendarEvents(
  //   // List<Accommodations> accommodations,
  //   // List<Activity> activities,

  //   List<Transport> transfers, List<Activity> activities
  // ) {
  //   // List<CalendarEvent> events = [];

  //   // Convert accommodations to events
  //   // for (var accommodation in accommodations) {
  //   //   events.add(CalendarEvent(
  //   //     title: "Accom: ${accommodation.note}",
  //   //     description: "A-T",
  //   //     id: accommodation.id,
  //   //     type: accommodation,
  //   //     startTime: accommodation.date,
  //   //     endTime: accommodation.date!
  //   //         .add(Duration(days: accommodation.countNights ?? 0)),
  //   //     color: Color.fromARGB(199, 245, 2, 253),
  //   //   ));
  //   // }
  //   // for (var activity in activities) {
  //   //   // Assuming 60 as total count
  //   //   events.add(CalendarEvent(
  //   //     displayNameTextStyle: TextStyle(
  //   //       fontStyle: FontStyle.italic,
  //   //       fontSize: 10,
  //   //       fontWeight: FontWeight.w400,
  //   //     ),
  //   //     title: "A-c :${activity.name}",
  //   //     id: activity.id,
  //   //     description: "Activity ${activity.name}",
  //   //     startTime: activity.departureDate,
  //   //     type: activity,
  //   //     endTime: activity.returnDate,
  //   //     color: Color.fromARGB(227, 239, 176, 3),
  //   //   ));
  //   // }
  //   List<CalendarEvent> CalendarEvents = [];
  //   for (var transfer in transfers) {
  //     CalendarEvents.add(CalendarEvent(
  //       title: "T-R ${transfer.note}",
  //       id: transfer.id,
  //       description: "Transfer Guid",
  //       startTime: transfer.date,
  //       type: transfer,
  //       endTime:
  //           transfer.date!.add(Duration(hours: transfer.durationHours ?? 0)),
  //       color: Color.fromARGB(200, 2, 152, 172),
  //     ));
  //   }
  //   return CalendarEvents;
  // }

  callback(refreshdate) {
    setState(() {
      _initializeData();
      _initializeData();
    });
  }

//   Future<void> fetchData() async {
//     try {
//       // activityList = await fetchActivities(
//       //     "/api/plannings/activitiestransfertaccommondation/${widget.Plannigid}");
//       // accommodationList = await fetchAccommodations(
//       //     "/api/plannings/activitiestransfertaccommondation/${widget.Plannigid}");
//       transferList =
//           await fetchTransfers("/api/transfers/touristGuidId/$guideid");

//       setState(() {
//         List<CalendarEvent> events = convertToCalendarEvents(
// //             accommodationList, activityList
// // ,
//             transferList);
//       });
//     } catch (e) {
//       // Handle error
//       print("Handle error $e");
//     }
//   }

  Future<Map<String, List<dynamic>>> fetchDataAndOrganizeEvents() async {
    try {
      // List<Activity> activitiesList = await fetchActivities(
      //   "/api/plannings/activitiestransfertaccommondation/${widget.Plannigid}",
      // );
      // List<Accommodations> accommodationsList = await fetchAccommodations(
      //   "/api/plannings/activitiestransfertaccommondation/${widget.Plannigid}",
      // );
      transfersList = await fetchTransfers(
        "/api/transfers/touristGuidId/$guideid",
      );
      Activityst = await activiteshanhler
          .fetchData("/api/activities?filters[touristGuideId]=$guideid");
      taskslist = await taskshanhler
          .fetchData("/api/tasks?filters[touristGuideId]=$guideid");
      List<CalendarEvent> CalendarEvents = convertToCalendarEvents(
          // accommodationsList,
          // activitiesList,
          transfersList!,
          Activityst,
          taskslist!);

      for (var event in CalendarEvents) {
        if (event.startTime != null) {
          DateTime dateKey = DateTime(
            event.startTime!.year,
            event.startTime!.month,
            event.startTime!.day,
          );

          if (!eventsByDate.containsKey(dateKey)) {
            eventsByDate[dateKey] = [];
          }
          setState(() {
            eventsByDate[dateKey]!.add(event);
          });
        } else {
          print(event.description);
        }
      }

      return {
        // 'activities': activitiesList,
        // 'accommodations': accommodationsList,
        'transfers': transfersList ?? [],
      };
    } catch (e) {
      // Handle error
      print("Error fetching data111: $e");
      throw e;
    }
  }

  CalendarDataSource _getCalendarDataSource() {
    List<CalendarEvent> CalendarEvents = [];
    eventsByDate.forEach((date, eventList) {
      CalendarEvents.addAll(eventList);
    });

    // Create an instance of CalendarDataSource with the events list
    return CustomCalendarDataSource(CalendarEvents, eventColors);
  }

  Future<List<Activity>> fetchActivities(String url) async {
    String? token = await storage.read(key: "access_token");
    String? baseUrl = await storage.read(key: "baseurl");
    String formatter(String url) {
      return baseUrls + url;
    }

    url = formatter(url);

    List<Activity> activityList = [];

    final response = await http.get(headers: {
      "Authorization": "Bearer $token",
      "Accept": "application/json, text/plain, */*",
      "Accept-Encoding": "gzip, deflate, br",
      "Accept-Language": "en-US,en;q=0.9",
      "Connection": "keep-alive",
    }, Uri.parse(url));

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);
      List<dynamic> resultList = data['activities'];
      print("resultList $resultList");
      activityList = resultList.map((e) => Activity.fromJson(e)).toList();
      return activityList;
    } else {
      throw Exception('${response.statusCode} err');
    }
  }

  Future<List<Accommodations>> fetchAccommodations(String url) async {
    List<Accommodations> accommodationList = [];
    String? token = await storage.read(key: "access_token");
    String? baseUrl = await storage.read(key: "baseurl");

    String formatter(String url) {
      return baseUrls + url;
    }

    url = formatter(url);
    final response = await http
        .get(headers: {"Authorization": "Bearer $token"}, Uri.parse(url));

    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);
      List<dynamic> resultList = data['accommodations'];
      accommodationList =
          resultList.map((e) => Accommodations.fromJson(e)).toList();
      return accommodationList;
    } else {
      throw Exception('${response.statusCode}');
    }
  }

  Future<List<Transport>> fetchTransfers(String url) async {
    List<Transport> transferList = [];
    String? token = await storage.read(key: "access_token");
    String? baseUrl = await storage.read(key: "baseurl");

    String formatter(String url) {
      return baseUrls + url;
    }

    url = formatter(url);
    final response = await http
        .get(headers: {"Authorization": "Bearer $token"}, Uri.parse(url));

    if (response.statusCode == 200 || response.statusCode == 201) {
      // var data = jsone.enc(response.body);
      final data = json.decode(response.body);
      final ApiResponse responsei = ApiResponse.fromJson(data);

      // Access the inlineCount, results, and touristGroupIds
      print('inlineCount: ${responsei.inlineCount}');
      print('Results:');
      for (final transport in responsei.results) {
        print(
            'Transport ID: ${transport.id}, Tourist Guide ID: ${transport.touristGuideId}');
      }
      print('Tourist Group IDs: ${responsei.touristGroupIds}');

      List<dynamic> resultList = data["results"];

      transferList = resultList.map((e) => Transport.fromJson(e)).toList();
      return transferList;
    } else {
      throw Exception('${response.statusCode}');
    }
  }

  _getCalendarDataSources(List<Transport>? transports,
      List<Activity>? activities, List<Tasks>? taskes) {
    // Check if transports and activities are not null
    if (transports != null) {
      for (Transport transfer in transports) {
        appointments.add(Appointment(
          id: transfer.id,
          notes: transfer.note,
          recurrenceId: transfer,
          startTime: transfer.date ?? DateTime.now(),
          subject: '🚍 from ${transfer.from} to ${transfer.to}',
          endTime: (transfer.date ?? DateTime.now())
              .add(Duration(hours: transfer.durationHours ?? 0)),
          color: Colors.green,
        ));
      }
    }

    // Check if activities are not null
    if (activities != null) {
      for (Activity activity in activities) {
        if (activity != null) {
          appointments.add(Appointment(
            id: activity.id,
            notes: activity.name ?? "na",
            recurrenceId: activity,
            startTime: activity.departureDate ?? DateTime.now(),
            subject: '${activity.name ?? 'activity'}',
            endTime:
                activity.returnDate ?? DateTime.now().add(Duration(hours: 5)),
            color: Colors.blue,
          ));
        }
      }
    }

    if (taskes != null) {
      for (Tasks task in taskes) {
        if (task != null) {
          appointments.add(Appointment(
            id: task.id,
            notes: task.description ?? "",
            recurrenceId: task,
            startTime: task.todoDate ?? DateTime.now(),
            subject: '${task.description ?? 'Task'}',
            endTime: task.todoDate != null
                ? task.todoDate!.add(Duration(days: 5))
                : DateTime.now().add(Duration(hours: 5)),
            color: Colors.red,
          ));
        }
      }
    }
    return _DataSource(appointments);
  }

  // void scheduleAlarms(List<Transport> transports) async {
  //   final now = DateTime.now();
  //   void _showTransferNotification(int id) {
  //     // Display the notification using a notification plugin
  //     print('Showing notification for transport ID: $id');
  //     // ...
  //   }

  //   int id = 1;
  //   for (Transport transfer in transports) {
  //     final startTime = transfer.date;

  //     if (startTime != null) {
  //       final timeDifference = startTime.difference(now);
  //       final result = await loadAlarmSound();
  //       // Check if the transfer is within a day or less
  //       final isWithin1Day = timeDifference.inDays <= 1;

  //       // if (isWithin1Day) {
  //       //   final notificationTime = startTime.subtract(Duration(minutes: 15)); // 15 minutes before

  //       //   final transportId = int.tryParse(transfer.id ?? '');

  //       //   if (transportId != null) {
  //       //     await AndroidAlarmManager.oneShot(
  //       //       Duration(milliseconds: notificationTime.millisecondsSinceEpoch),
  //       //       id++, // Use the parsed integer value
  //       //       _showTransferNotification, // Callback function to show the notification
  //       //       exact: true,
  //       //       wakeup: true,
  //       //       alarmClock: true,
  //       //     );
  //       //   }
  //       // }
  //     }
  //   }
  // }

// Define the callback function to show the notification (same as previous answer)

// CalendarDataSource<Object?> calendarDataSource =
//       _getCalendarDataSources(transportsList1);

  // void calendarTapped(
  //     BuildContext context, CalendarTapDetails calendarTapDetails) {
  //   if (calendarTapDetails.targetElement == CalendarElement.appointment) {
  //     CalendarEvent event = calendarTapDetails.appointments![0];
  //     // Assuming the event.id is the unique identifier for your event
  //     // Modify the following line according to your event class structure
  //     String? eventId = event.id;

  //     // Retrieve the corresponding Transport object using eventId
  //     Transport transport =
  //         transfersList.firstWhere((transport) => transport.id == eventId);
  //     Get.off(EventView(
  //       event: transport,
  //     ));
  //     Activity activite =
  //         activityList.firstWhere((activite) => activite.id == eventId);
  //     Get.off(EventView(
  //       event: transport,
  //     ));
  //     // Navigator.of(context).pushAndRemoveUntil(
  //     //   MaterialPageRoute(
  //     //       builder: (context) => EventView(
  //     //             event: transport,
  //     // //           )),
  //     // );
  //   }
  // }
  // void calendarTapped(
  //     BuildContext context, CalendarTapDetails calendarTapDetails) {
  //   if (calendarTapDetails.targetElement == CalendarElement.appointment) {
  //     Appointment appointment =
  //         calendarTapDetails.appointments![0] as Appointment;
  //     // Navigator.of(context).push(
  //     //   MaterialPageRoute(
  //     //       builder: (context) => EventViewTraveller(appointment: appointment)),
  //     // );
  //   }
  // }
  void calendarTapped(
      BuildContext context, CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement == CalendarElement.appointment) {
      List<dynamic> appointments = calendarTapDetails.appointments ?? [];

      if (appointments.isNotEmpty) {
        Appointment eventId = appointments[0];
        AppointmentType appointmentType =
            eventId.appointmentType; // Get the appointment type

        // Check if the appointment type corresponds to a Transport event
        Transport? transport = transfersList!.firstWhereOrNull(
          (transport) =>
              transport.id == eventId.id, // Use eventId.id to check the ID
        );
        Tasks? task = taskslist!.firstWhereOrNull(
          (taskes) => taskes.id == eventId.id, // Use eventId.id to check the ID
        );
        // Check if the appointment type corresponds to an Activity event
        Activity? activity = activityList!.firstWhereOrNull(
          (activity) =>
              activity.id == eventId.id, // Use eventId.id to check the ID
        );

        if (transport != null) {
          // _onTransferAppointmentTapped(transport);
          _onAppointmentTapped(transport);
          // Get.to(EventView(
          //   event: transport,
          // ));
        } else if (activity != null) {
          _onAppointmentTapped(activity);
          // Get.to(EventView(
          //   event: activity,
          // ));
        } else if (task != null) {
          _onAppointmentTapped(task);
          // Get.to(EventView(
          //   event: activity,
          // ));
        } else {
          // Handle the case where the event type is unknown
          print('Unknown event type for eventId: $appointmentType');
        }
      }
    }
  }

  void calendarTappedInkwell(BuildContext context, dynamic appointmentObject) {
    print("$appointmentObject");
    if (appointmentObject is Transport) {
      _onAppointmentTapped(appointmentObject);
      // Navigate to the Transport view
    } else if (appointmentObject is Activity) {
      _onAppointmentTapped(appointmentObject);
      // Navigate to the Activity view
    } else if (appointmentObject is Tasks) {
      _onAppointmentTapped(appointmentObject);
      // Navigate to the Task view
    } else {
      // Handle the case where the event type is unknown
      print('Unknown event type for eventId: $appointmentObject');
    }
  }

//  fetchDataAndBuildCalendar()  {
//   CalendarDataSource<Object?> dataSource = await _getCalendarDataSources();

//   // Now you can build your widget with the dataSource
//   setState(() {
//     // Update your state or UI components with the dataSource
//   });
// }
  @override
  Widget build(BuildContext context) {
    ScrollControllerProvider scrollControllerProvider = ScrollControllerProvider();

// Set the value of closeTopContainer using the setter


    // Replace the API endpoint
 WidgetsBinding.instance.addPostFrameCallback((timeStamp) {  
  controller.addListener(() {
      double value = controller.offset / 2;

      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 20;
 
        hideitem = closeTopContainer;
   
        // Timer(Duration(microseconds: 1), () {
          // This function will be executed after 1 second

          // Update the UI or perform any action here
          setState(() {
            hideitem = closeTopContainer;
            // Modify your UI state here
            // For example, set a flag or update a variable to hide an item
          });
        // });
      });
    });});
    final Size size = MediaQuery.of(context).size;
    final double categoryHeight = size.height * 0.30;
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final width = MediaQuery.of(context).size.width;
    final bool isSmallScreen = width < 600;
    final bool isLargeScreen = width > 800;
    if (taskslist!.isEmpty == true &&
        activityList!.isEmpty == true &&
        transferList!.isEmpty == true) {
      return LoadingScreen(
        loadingText: "Loading.😊.😊.😊.",
        cursor: "_❤",
      );
//       Scaffold(
//         body: Center(
//           child: Column(mainAxisAlignment: MainAxisAlignment.center,
//             children: [Center(child: Text("Loafing..")),
//             AnimatedTextKit(
//   animatedTexts: [
//     TypewriterAnimatedText(
//       'Loading....',
//       textStyle: const TextStyle(
//         fontSize: 32.0,
//         fontWeight: FontWeight.bold,
//       ),
//       speed: const Duration(milliseconds: 1000),
//     ),
//   ],

//   totalRepeatCount: 4,
//   pause: const Duration(milliseconds: 1000),
//   displayFullTextOnTap: true,
//   stopPauseOnTap: true,
// ),
//             Gap(80),
//               CircularProgressIndicator(
//                 backgroundColor: Color.fromARGB(255, 219, 10, 10),
//                 valueColor: new AlwaysStoppedAnimation<Color>(
//                     Color.fromARGB(207, 248, 135, 6)),
//               ),
//             ],
//           ),
//         ),
//       );
// // Or any loading indicator
    }
    return Scaffold(
      bottomSheet:
          //  closeTopContainer
          //     ? SizedBox()
          //     :
          Visibility(
        visible: !closeTopContainer,
        child: GFBottomSheet(
          controller: _gFBottomSheetController,
          maxContentHeight: 200,
          stickyHeaderHeight: 40,
          stickyHeader: Container(
            decoration: BoxDecoration(
                color: Color.fromARGB(0, 128, 128, 129),
                boxShadow: [
                  BoxShadow(color: Color.fromARGB(0, 233, 2, 36), blurRadius: 0)
                ]),
            child: GFListTile(
              avatar: InkWell(
                onTap: () {
                  // print("tapeddddd");
                  // Get.to(ImageViewScreen(
                  //   "${baseUrls}/assets/uploads/traveller/${selectedUser?.picture}",
                  // ));
                },
                child: Container(),
              ),
              subTitle: Text(
                'Task Name : ',
                // is_confirmed: ${task.isConfirmed ? 'Yes' : 'No'}',
                style: TextStyle(
                  fontSize: 6,
                  wordSpacing: 0.3,
                  letterSpacing: 0.2,
                ),
              ),
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
                    Text("Those all of Your Today task "),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: taskslist?.length ?? 0,
                      itemBuilder: (context, index) {
                        final task = taskslist![index];
                        final now = DateTime.now()
                            .toLocal(); // Get the current date and time

                        if (task.todoDate != null) {
                          // Check if the task has a valid todoDate
                          if (task.todoDate!.toLocal().isBefore(now) &&
                              task.todoDate!
                                  .toLocal()
                                  .isAfter(now.subtract(Duration(days: 1)))) {
                            // Check if the task's todoDate is within today
                            return Text(
                              'Task (${index + 1}) Name : ${task.description}',
                              // is_confirmed: ${task.isConfirmed ? 'Yes' : 'No'}',
                              style: TextStyle(
                                fontSize: 14,
                                wordSpacing: 0.3,
                                letterSpacing: 0.2,
                              ),
                            );
                          }
                        }
                        return SizedBox
                            .shrink(); // Hidden if the todoDate is null or not within today
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
                            // child: PushNotificationGuideScreen(widget.guid?.id),
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
          stickyFooterHeight: 20,
        ),
      ),
      body: Column(
        children: [
          //  FittedBox(
          //    child: Container(
          //     // Specify the height as needed
          //     height: 50,width: 100,
          //    child: ListView.builder(
          //     scrollDirection: Axis.horizontal, // Display items horizontally
          //     itemCount: items.length,
          //     itemBuilder: (context, index) {
          //       return Container(
          //     // Add spacing between items
          //         child: Column(
          //           children: [
          //             Text(items[index].name??"select"),
          //             Checkbox(
          //               value: items[index].selected,
          //               onChanged: (bool? value) {
          //                 setState(() {
          //                   items[index].selected = value ?? false;
          //                 });

          //               },
          //             ),
          //           ],
          //         ),
          //       );
          //     },
          //    ),),
          //  ),
          //         // hideitem
          //     ? SizedBox()
          //     :
          Visibility(
            visible: !hideitem,
            child: FittedBox(
              child: Container(
                height: Get.height * 0.364,
                width: 500,
                child: RefreshIndicator(
                  onRefresh: _refrech,
                  child: ListView(
                    controller: controllerCalander,
                    shrinkWrap: true,
                    children: [
                      SfCalendar(
                        onSelectionChanged: selectionChanged,
                        todayHighlightColor: Color.fromARGB(255, 242, 186, 3),
                        showTodayButton: true,
                        //  onSelectionChanged: onSelectionChanged,
                        //

                        headerStyle: CalendarHeaderStyle(
                          textStyle: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: settingsProvider.isDarkMode
                                  ? Color.fromARGB(255, 173, 10, 173)
                                  : Color.fromARGB(255, 201, 181, 6)),
                        ),
                        monthCellBuilder: monthCellBuilder,
                        headerHeight: 30,
                        controller: _controller,
                        todayTextStyle: TextStyle(
                            fontStyle: FontStyle.normal,
                            fontSize: 60,
                            fontWeight: FontWeight.w900,
                            color: settingsProvider.isDarkMode
                                ? Color.fromARGB(255, 238, 234, 238)
                                : Color.fromARGB(255, 14, 13, 14)),

                        view: CalendarView.month,

                        scheduleViewMonthHeaderBuilder: (BuildContext context,
                            ScheduleViewMonthHeaderDetails details) {
                          // You can return a custom widget here to be displayed as the header.
                          return SizedBox(
                            height: 10,
                            child: Chip(
                              // Set your desired background color
                              label: Center(
                                child: Text(
                                  'Custom Header', // Set your desired header text
                                  style: TextStyle(
                                    color: Colors
                                        .white, // Set your desired text color
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },

                        viewNavigationMode: ViewNavigationMode.snap,
                        scheduleViewSettings: ScheduleViewSettings(
                            hideEmptyScheduleWeek:
                                settingsProvider.hideEmptyScheduleWeek),

                        onTap: (CalendarTapDetails details) {
                          calendarTapped(context,
                              details); // Call your calendarTapped function
                        },
                        showDatePickerButton: true,
                        resourceViewSettings: ResourceViewSettings(
                            visibleResourceCount: 4,
                            showAvatar: false,
                            displayNameTextStyle: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 12,
                                fontWeight: FontWeight.w400)),

                        // allowedViews: <CalendarView>[
                        //   CalendarView.day,
                        //   CalendarView.week,
                        //   CalendarView.workWeek,
                        //   CalendarView.month,
                        //   CalendarView.schedule
                        // ],
                        initialDisplayDate: DateTime.parse(dateString),
                        dataSource: calendarDataSource,

                        monthViewSettings: MonthViewSettings(
                            navigationDirection:
                                MonthNavigationDirection.vertical,
                            showAgenda: false,
                            appointmentDisplayMode:
                                MonthAppointmentDisplayMode.indicator,
                            numberOfWeeksInView: 4,

                            ///           appointmentDisplayCount: 2,

                            //  isLargeScreen
                            //     ? Get.height * 0.5
                            //     : Get.height * 0.4,
                            monthCellStyle: MonthCellStyle(
                              todayBackgroundColor: Colors.red,
                              textStyle: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            agendaStyle: AgendaStyle(
                              backgroundColor: settingsProvider.isDarkMode
                                  ? MyThemes.lightTheme.splashColor
                                      .withOpacity(0.9)
                                  : MyThemes.darkTheme.splashColor
                                      .withBlue(200),
                              appointmentTextStyle: TextStyle(
                                  fontSize: 20,
                                  fontStyle: FontStyle.italic,
                                  color: Color.fromARGB(239, 236, 235, 234)),
                              dateTextStyle: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                              dayTextStyle: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          //   ),
          // ),
          Visibility(
            child: Column(
              children: [
           
//                 DropdownButton<Item>(
//   value: selitems,

//   onChanged: (Item? newValue) {
//     setState(() {
//       selitems = newValue;
//     });
//   },
//   items: items.map<DropdownMenuItem<Item>>((Item user) {
//     return DropdownMenuItem<Item>(
//       value: user,
//       child: Text(user.name??""),
//     );
//   }).toList(),
// ),

                SafeArea(
                  child: FittedBox(
                    child: Container(
                      height: hideitem ? Get.height * 1.62 : Get.height * 1,
                      width: Get.width * 2,
                      // height: Get.height * 0.7, width: Get.width * 1.3,
                      child: SafeArea(
                        child: ListView.separated(
                          shrinkWrap: true,
                          controller: controller,
                          // physics: BouncingScrollPhysics(),
                          itemCount: _appointmentDetails.length,
                          itemBuilder: (BuildContext context, int index) {
                            double scale = 1.0;
                            if (topContainer > 0.5) {
                              scale = index - topContainer;

                              if (scale < 0) {
                                scale = 0;
                              } else if (scale > 1) {
                                scale = 1;
                              }
                            }
                            final appointment = _appointmentDetails[index];

                            // Fetch the corresponding object based on appointment.id
                            final appointmentObject =
                                getAppointmentObject(appointment.id as String?);

                            // Define variables for image, name, and other details
                            String imageName =
                                ''; // Provide an initial value, or set it based on your logic
                            String name =
                                ''; // Provide an initial value, or set it based on your logic
                            String additionalDetails =
                                ''; // Provide an initial value, or set it based on your logic
                            DateTime startedAt = DateTime.now();
                            DateTime endAt = DateTime.now();

                            if (appointmentObject is Activity) {
                              card =
                                  ActivityCard(appointmentObject as Activity);
                            } else if (appointmentObject is Transport) {
                              // Handle Transport type
                              card = TransferCard(
                                  appointmentObject as Transport,
                                  travelersData);
                              // TransferCard(appointmentObject as Transport, groupIdsList,
                              //     travelersData);
                              imageName =
                                  "data:image/jpeg;base64,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"
                                      as String; // Replace with the actual image
                              name = appointmentObject.to as String;
                              additionalDetails = appointmentObject.from ??
                                  'Additional details for Transport';
                            } else if (appointmentObject is Tasks) {
                              card = TaskCard(appointmentObject as Tasks);
                              // Handle Task type
                              imageName =
                                  "data:image/jpeg;base64,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"
                                      as String; // Replace with the actual image
                              name =
                                  'Task'; // You may get the name from the task object
                              //  additionalDetails = appointmentObject.description ??
                              'Additional details for task';
                            }

                            return Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: InkWell(
                                  onTap: () {
                                    calendarTappedInkwell(context,
                                        appointmentObject); // Call your calendarTapped function with the 'details' parameter
                                  },
                                  child: card),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(
                            height: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// void getSelectedDateAppointments(DateTime? selectedDate) {
//   print('Selected Date: $selectedDate');
//   setState(() {
//     appointments.clear();
//   });

//   if (calendarDataSource == null || selectedDate == null) {
//     return;
//   }

//   for (int i = 0; i < calendarDataSource!.appointments!.length; i++) {
//     final Appointment appointment = calendarDataSource!.appointments![i] as Appointment;

//     // Print details of each appointment
//     print('Appointment: ${appointment.subject}');
//     print('Start Date: ${appointment.startTime}');
//     print('End Date: ${appointment.endTime}');

//     // Rest of your code
//   }
// }
  dynamic getAppointmentObject(String? appointmentId) {
    // Assuming you have lists or data sources for activities, transfers, and tasks
    // Replace these with your actual data sources

    // Try to find the appointment in each list based on the appointmentId
    Transport? transport = transfersList!
        .firstWhereOrNull((transport) => transport.id == appointmentId);
    Tasks? task =
        taskslist!.firstWhereOrNull((task) => task.id == appointmentId);
    Activity? activity = activityList!
        .firstWhereOrNull((activity) => activity.id == appointmentId);

    // Determine the type of appointment and return the corresponding object
    if (activity != null) {
      return activity;
    } else if (transport != null) {
      return transport;
    } else if (task != null) {
      return task;
    } else {
      // Handle cases where the appointmentId doesn't match any object
      print("Handle cases where the appointmentId doesn't match any object");
      return null;
    }
  }

  void selectionChanged(CalendarSelectionDetails calendarSelectionDetails) {
    getSelectedDateAppointments(calendarSelectionDetails.date);
  }

  void getSelectedDateAppointments(DateTime? selectedDate) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      setState(() {
        _appointmentDetails.clear();
      });
      // print("selected date $selectedDate");

      if (calendarDataSource!.appointments == null ||
          calendarDataSource!.appointments!.isEmpty) {
        return;
      }

      final selectedDateOnly =
          DateTime(selectedDate!.year, selectedDate.month, selectedDate.day);

      for (final appointment in calendarDataSource!.appointments!) {
        // print("$selectedDateOnly selected date");
        // print("${appointment.startTime} appointment startTime");
        // print("${appointment.endTime} appointment endTime date");

        final appointmentStartDate =
            appointment.startTime.toLocal(); // Convert to local time
        final appointmentEndDate =
            appointment.endTime.toLocal(); // Convert to local time

        if (appointmentStartDate.isBefore(selectedDate!.add(Duration(
                days:
                    1))) && // Add 1 day to the selected date to cover the entire day
            appointmentEndDate.isAfter(selectedDate)) {
          setState(() {
            _appointmentDetails.add(appointment);
          });
        }
      }
    });
  }
  // void getSelectedDateAppointments(DateTime? selectedDate) {
  //   SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
  //     setState(() {
  //       _appointmentDetails.clear();
  //     });
  //     print("selected date $selectedDate");
  //     print("selected date $selectedDate");
  //     if (calendarDataSource.appointments == null ||
  //         calendarDataSource.appointments!.isEmpty) {
  //       return;
  //     }
  //     final selectedDateOnly =
  //         DateTime(selectedDate!.year, selectedDate.month, selectedDate.day);

  //    for (final appointment in calendarDataSource.appointments!) {
  //     print("$selectedDateOnly seleced date");
  //       print("${DateTime(appointment.startTime.year, appointment.startTime.month,
  //               appointment.startTime.day)} appointment startTime");
  //                   print("${DateTime(appointment.startTime.year, appointment.startTime.month,
  //               appointment.endTime.day)} appointment endTime date");
  //     if (DateTime(appointment.startTime.year, appointment.startTime.month,
  //               appointment.startTime.day)==selectedDateOnly|| appointment.startTime.isAfter(selectedDateOnly)) {
  //       if (appointment.endTime.isBefore(selectedDateOnly)) {
  //         setState(() {
  //           _appointmentDetails.add(appointment);
  //         });
  //       }
  //     }
  //   }
  // });
  // }

  Widget monthCellBuilder(BuildContext context, MonthCellDetails details) {
    var length = details.appointments.length;
    if (details.appointments.isNotEmpty) {
      return Container(
        child: details.date.day != DateTime.now().day
            ? Column(
                children: <Widget>[
                  Column(
                    children: [
                      Text(
                        details.date.day.toString(),
                      ),
                      Icon(
                        Icons.event_available_rounded,
                        color: Colors.red,
                        size: 10,
                      ),
                      (Platform.isAndroid || Platform.isIOS)
                          ? Column(
                              children: [
                                Text(
                                  '$length',
                                  style: TextStyle(color: Colors.deepPurple),
                                )
                              ],
                            )
                          : SizedBox()
                    ],
                  )
                ],
              )
            : Column(
                children: <Widget>[
                  Column(
                    children: [
                      Text(
                        details.date.day.toString(),
                      ),
                      Container(
                        color: Color.fromARGB(20, 247, 54, 6),
                        child: Icon(
                          Icons.event_available_rounded,
                          color: Color.fromARGB(255, 28, 134, 1),
                          size: 18,
                        ),
                      ),
                      (Platform.isAndroid || Platform.isIOS)
                          ? Column(
                              children: [
                                Text(
                                  '$length',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 1, 69, 90)),
                                )
                              ],
                            )
                          : SizedBox()
                    ],
                  )
                ],
              ),
      );
    }
    return Container(
      child: Text(
        details.date.day.toString(),
        textAlign: TextAlign.center,
      ),
    );
  }

  Future<void> _showAddItemDialog(BuildContext context, dynamic item) async {
    final TextEditingController descriptionController = TextEditingController();
    DateTime? selectedDate;
    String itemTypeText = '';

    if (item is Tasks) {
      itemTypeText = 'Task';
    } else if (item is Activity) {
      itemTypeText = 'Activity';
    } else if (item is Transport) {
      itemTypeText = 'Transport';
    }
    final result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          if (itemTypeText == 'Task') {
            return AlertDialog(
              title: Text(
                "Add ${itemTypeText}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Task Description',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );

                      if (pickedDate != null && pickedDate != selectedDate) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                    child: const Text('Select Date'),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false); // Return false on cancel
                  },
                ),
                TextButton(
                  child: const Text(
                    'Add',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                  onPressed: () async {
                    if (descriptionController.text.isEmpty) {
                      // Show an error message if the description is empty
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a description'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      String newTaskDescription = descriptionController.text;
                      String? newTaskTodoDate;

                      if (selectedDate != null) {
                        newTaskTodoDate = selectedDate?.toLocal().toString();
                      }

                      // Send a POST request to add the task
                      String? token = await storage.read(key: "access_token");
                      String url = "$baseUrls/api/tasks";
                      final response = await http.post(
                        Uri.parse(url),
                        headers: {
                          "Authorization": "Bearer $token",
                          "Content-Type": "application/json",
                        },
                        body: jsonEncode({
                          "touristGuideId": guideid,
                          "description": newTaskDescription,
                          "todoDate": newTaskTodoDate,
                          // Add other task properties as needed
                        }),
                      );

                      if (response.statusCode == 201) {
                        // Task added successfully, update the calendar
                        fetchTasks();
                        Navigator.of(context)
                            .pop(true); // Return true on success
                      } else {
                        // Handle error
                        print("Error adding task: ${response.statusCode}");
                      }
                    }
                  },
                ),
              ],
            );
          } else if (itemTypeText == 'Activity') {
            return AlertDialog(
              title: Text(
                "Add ${itemTypeText}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Activity  Description',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );

                      if (pickedDate != null && pickedDate != selectedDate) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                    child: const Text('Select Activity start Date'),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false); // Return false on cancel
                  },
                ),
                TextButton(
                  child: const Text(
                    'Add',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                  onPressed: () async {
                    if (descriptionController.text.isEmpty) {
                      // Show an error message if the description is empty
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter activity  description'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      String newTaskDescription = descriptionController.text;
                      String? newTaskTodoDate;

                      if (selectedDate != null) {
                        newTaskTodoDate = selectedDate?.toLocal().toString();
                      }

                      // Send a POST request to add the task
                      String? token = await storage.read(key: "access_token");
                      String url = "$baseUrls/api/tasks";
                      final response = await http.post(
                        Uri.parse(url),
                        headers: {
                          "Authorization": "Bearer $token",
                          "Content-Type": "application/json",
                        },
                        body: jsonEncode({
                          "touristGuideId": guideid,
                          "description": newTaskDescription,
                          "todoDate": newTaskTodoDate,
                          // Add other task properties as needed
                        }),
                      );

                      if (response.statusCode == 201) {
                        // Task added successfully, update the calendar
                        fetchTasks();
                        Navigator.of(context)
                            .pop(true); // Return true on success
                      } else {
                        // Handle error
                        print("Error adding task: ${response.statusCode}");
                      }
                    }
                  },
                ),
              ],
            );
          } else
            return AlertDialog(
              title: Text(
                "Add ${itemTypeText}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Task Description',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );

                      if (pickedDate != null && pickedDate != selectedDate) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                    child: const Text('Select Start Date'),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false); // Return false on cancel
                  },
                ),
                TextButton(
                  child: const Text(
                    'Add',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                  onPressed: () async {
                    if (descriptionController.text.isEmpty) {
                      // Show an error message if the description is empty
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a description'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      String newTaskDescription = descriptionController.text;
                      String? newTaskTodoDate;

                      if (selectedDate != null) {
                        newTaskTodoDate = selectedDate?.toLocal().toString();
                      }

                      // Send a POST request to add the task
                      String? token = await storage.read(key: "access_token");
                      String url = "$baseUrls/api/tasks";
                      final response = await http.post(
                        Uri.parse(url),
                        headers: {
                          "Authorization": "Bearer $token",
                          "Content-Type": "application/json",
                        },
                        body: jsonEncode({
                          "touristGuideId": guideid,
                          "description": newTaskDescription,
                          "todoDate": newTaskTodoDate,
                          // Add other task properties as needed
                        }),
                      );

                      if (response.statusCode == 201) {
                        // Task added successfully, update the calendar
                        fetchTasks();
                        Navigator.of(context)
                            .pop(true); // Return true on success
                      } else {
                        // Handle error
                        print("Error adding task: ${response.statusCode}");
                      }
                    }
                  },
                ),
              ],
            );
        });

    if (result == true) {
      // Task was added successfully
    }
  }

  Future<void> _showeditItemDialog(BuildContext context, dynamic item) async {
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController name = TextEditingController();
    final TextEditingController noteController = TextEditingController();
    final TextEditingController messageController =
        TextEditingController(); // Initialize controllers
    final TextEditingController titleController =
        TextEditingController(); // Initialize controllers
    final TextEditingController typeController =
        TextEditingController(); // Initialize controllers

    DateTime? selectedDate;
    DateTime? selectedreturnDate;
    String itemTypeText = '';

    if (item is Tasks) {
      itemTypeText = 'Task';
    } else if (item is Activity) {
      itemTypeText = 'Activity';
    } else if (item is Transport) {
      itemTypeText = 'Transport';
    }
    final result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          if (itemTypeText == 'Task') {
            return AlertDialog(
              title: Text(
                "Update ${itemTypeText}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Task Description',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );

                      if (pickedDate != null && pickedDate != selectedDate) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                    child: const Text('Select Date'),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false); // Return false on cancel
                  },
                ),
                TextButton(
                  child: const Text(
                    'update',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                  onPressed: () async {
                    if (descriptionController.text.isEmpty) {
                      // Show an error message if the description is empty
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a activity'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      String newTaskDescription = descriptionController.text;
                      String? newTaskTodoDate;

                      if (selectedDate != null) {
                        newTaskTodoDate = selectedDate?.toLocal().toString();
                      }

                      // Send a POST request to add the task
                      String? token = await storage.read(key: "access_token");
                      String url = "$baseUrls/api/tasks";
                      final response = await http.post(
                        Uri.parse(url),
                        headers: {
                          "Authorization": "Bearer $token",
                          "Content-Type": "application/json",
                        },
                        body: jsonEncode({
                          "touristGuideId": guideid,
                          "description": newTaskDescription,
                          "todoDate": newTaskTodoDate,
                          // Add other task properties as needed
                        }),
                      );

                      if (response.statusCode == 201) {
                        // Task added successfully, update the calendar
                        fetchTasks();
                        Navigator.of(context)
                            .pop(true); // Return true on success
                      } else {
                        // Handle error
                        print("Error adding task: ${response.statusCode}");
                      }
                    }
                  },
                ),
              ],
            );
          } else if (itemTypeText == 'Activity') {
            return AlertDialog(
              title: Text(
                "update ${itemTypeText}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Activity  name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );

                      if (pickedDate != null && pickedDate != selectedDate) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                    child: const Text('Select Activity return Date'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedreturnDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );

                      if (pickedDate != null &&
                          pickedDate != selectedreturnDate) {
                        setState(() {
                          selectedreturnDate = pickedDate;
                        });
                      }
                    },
                    child: const Text('Select Activity start Date'),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false); // Return false on cancel
                  },
                ),
                TextButton(
                  child: const Text(
                    'update',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                  onPressed: () async {
                    if (descriptionController.text.isEmpty) {
                      // Show an error message if the description is empty
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter activity  description'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      String newTaskDescription = descriptionController.text;
                      String? newTaskTodoDate;

                      if (selectedreturnDate != null) {
                        newTaskTodoDate =
                            selectedreturnDate?.toLocal().toString();
                      }

                      // Send a POST request to add the task
                      String? token = await storage.read(key: "access_token");
                      String url = "$baseUrls/api/activities/${item.id}";
                      final response = await http.patch(
                        Uri.parse(url),
                        headers: {
                          "Authorization": "Bearer $token",
                          "Content-Type": "application/json",
                        },
                        body: jsonEncode({
                          "name": newTaskDescription,

                          // Add other task properties as needed
                        }),
                      );

                      if (response.statusCode == 201) {
                        // Task added successfully, update the calendar
                        // fetchTasks();
                        Navigator.of(context)
                            .pop(true); // Return true on success
                      } else {
                        // Handle error
                        print("Error adding task: ${response.statusCode}");
                      }
                    }
                  },
                ),
              ],
            );
          } else
            return AlertDialog(
              title: Text(
                "update ${itemTypeText}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: noteController,
                    decoration: const InputDecoration(
                      labelText: 'transfer note ',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a note';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedreturnDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );

                      if (pickedDate != null && pickedDate != selectedDate) {
                        setState(() {
                          selectedreturnDate = pickedDate;
                        });
                      }
                    },
                    child: const Text(' selected returnDate Date'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );

                      if (pickedDate != null && pickedDate != selectedDate) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                    child: const Text('Select Start Date'),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false); // Return false on cancel
                  },
                ),
                TextButton(
                  child: const Text(
                    'patch',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                  onPressed: () async {
                    if (noteController.text.isEmpty) {
                      // Show an error message if the description is empty
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a note'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      String newTaskDescription = noteController.text;
                      String? newTaskTodoDate;

                      if (selectedDate != null) {
                        newTaskTodoDate = selectedDate?.toLocal().toString();
                      }

                      // Send a POST request to add the task
                      String? token = await storage.read(key: "access_token");
                      String url = "$baseUrls/api/tasks";
                      final response = await http.patch(
                        Uri.parse(url),
                        headers: {
                          "Authorization": "Bearer $token",
                          "Content-Type": "application/json",
                        },
                        body: jsonEncode({
                          "touristGuideId": guideid,
                          "note": noteController.text,
                          "todoDate": newTaskTodoDate,
                          // Add other task properties as needed
                        }),
                      );

                      if (response.statusCode == 201) {
                        // Task added successfully, update the calendar
                        fetchTasks();
                        Navigator.of(context)
                            .pop(true); // Return true on success
                      } else {
                        // Handle error
                        print("Error adding task: ${response.statusCode}");
                      }
                    }
                  },
                ),
              ],
            );
        });

    if (result == true) {
      // Task was added successfully
    }
  }

  void _onTransferAppointmentTapped(Transport? transfer) {
    print("${transfer}''''");
    print("${transfer}fff");
    print("${transfer}fff");
    print("${transfer}fff");
    print("${transfer}");
    // Navigator.of(context).push(
    // MaterialPageRoute(
    //   builder: (context) => EventView(
    //     transport: transfer,
    //     onSave: handleEventSave, // Pass the method
    //   ),
    //   // ),
    // );
  }

  Future<void> _deleteItem(BuildContext context, dynamic item) async {
    String? token = await storage.read(key: "access_token");

    if (item is Tasks) {
      // Handle Tasks deletion
      String url = "$baseUrls/api/tasks/${item.id}";
      final response = await http.delete(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 204) {
        // Task deleted successfully from the server
        // Remove the task from the local list
        taskslist!.remove(item);
        // Update the UI
        setState(() {
          _initializeData();
        });
      } else {
        // Handle error
        print("Error deleting task: ${response.statusCode}");
      }
    } else if (item is Activity) {
      // Handle Activity deletion
      // ...
      print("deleting activity");
      String url = "$baseUrls/api/activities/${item.id}";
      final response = await http.delete(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 204) {
        // Task deleted successfully from the server
        // Remove the task from the local list
        activityList!.remove(item);
        // Update the UI
        setState(() {
          _initializeData();
        });
      } else {
        // Handle error
        print("Error deleting activity: ${response.statusCode}");
      }
    } else if (item is Transport) {
      print("deleting transport");
      String url = "$baseUrls/api/transfers/${item.id}";
      final response = await http.delete(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 204) {
        // Task deleted successfully from the server
        // Remove the task from the local list
        transferList.remove(item);
        // Update the UI
        setState(() {
          _initializeData();
        });
      } else {
        // Handle error
        print("Error deleting trasfer: ${response.statusCode}");
      }
    }
  }

  Future<void> _deleteTask(Tasks task) async {
    // Send an HTTP DELETE request to delete the task on the server
    String? token = await storage.read(key: "access_token");
    String url =
        "$baseUrls/api/tasks/${task.id}"; // Replace with your API endpoint

    final response = await http.delete(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 204) {
      // Task deleted successfully from the server
      // Remove the task from the local list
      tasks.remove(task);
      // Update the UI
      setState(() {});
    } else {
      // Handle error
      print("Error deleting task: ${response.statusCode}");
    }
  }

  void _onAppointmentTapped(dynamic item) {
    print('Tapped on object of type: ${item.runtimeType}');

    if (item is Tasks) {
      Tasks task = item as Tasks;
      print('Tapped on task with ID: ${task.id}');
      // Handle the task-specific logic
    } else if (item is Activity) {
      Activity activity = item as Activity;
      print('Tapped on activity with ID: ${activity.id}');
      // Handle the activity-specific logic
    } else if (item is Transport) {
      Transport transport = item as Transport;
      print('Tapped on transport with ID: ${transport.id}');
      // Handle the transport-specific logic
    } else {
      print('Tapped on an object of an unknown type.');
      // Handle unknown type logic or show an error message.
    }

    showItemDetailsScreen(context, item);
    // showModalBottomSheet(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return SizedBox(
    //       height: 200,
    //       child: Center(
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           mainAxisSize: MainAxisSize.min,
    //           children: <Widget>[
    //             ListTile(
    //               leading: const Icon(Icons.add),
    //               title: const Text('Add New'),
    //               onTap: () {
    //                 if (item is Tasks) {
    //                   _showAddItemDialog(context, item as Tasks);
    //                 } else if (item is Activity) {
    //                   _showAddItemDialog(context, item as Activity);
    //                 } else if (item is Transport) {
    //                   _showAddItemDialog(context, item as Transport);
    //                   // _deleteTransport(item as Transport);
    //                 }
    //                 // _showAddTaskDialog(context,);
    //               },
    //             ),
    //             ListTile(
    //               leading: const Icon(Icons.delete),
    //               title: const Text('Delete'),
    //               onTap: () {
    //                 if (item is Tasks) {
    //                   _deleteItem(context, item as Tasks);
    //                 } else if (item is Activity) {
    //                   // _deleteActivity(item as Activity);
    //                   _deleteItem(context, item as Activity);
    //                 } else if (item is Transport) {
    //                   // _deleteTransport(item as Transport);
    //                   _deleteItem(context, item as Transport);
    //                 }
    //                 Navigator.of(context).pop();
    //               },
    //             ),
    //             ListTile(
    //               leading: const Icon(Icons.edit),
    //               title: const Text('Edit'),
    //               onTap: () {
    //                 if (item is Tasks) {
    //                   // Handle edit for Tasks
    //                   _showeditItemDialog(context, item);
    //                 } else if (item is Activity) {
    //                   // Handle edit for Activity
    //                   _showeditItemDialog(context, item);
    //                 } else if (item is Transport) {
    //                   // Handle edit for Transport
    //                   print("tranfercolor");
    //                   _showeditItemDialog(context, item);
    //                   // Get.to(
    //                   //   EventViewDetail(
    //                   //     transport: item,
    //                   //     onSave: handleEventSave, // Pass the method
    //                   //   ),
    //                   // );
    //                 }
    //                 // Navigator.pop(context);
    //               },
    //             ),
    //           ],
    //         ),
    //       ),
    //     );
    //   },
    // );
  }

  void showItemDetailsScreen(BuildContext context, dynamic item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ItemDetailsScreen(item: item),
      ),
    );
  }

  void handleEventSave(Transport updatedEvent) {
    setState(() {
      // Update the event list with the changes
      int index =
          transferList.indexWhere((element) => element.id == updatedEvent.id);
      if (index != -1) {
        transferList[index] = updatedEvent;
      }
    });
  }

  void dragEnd(AppointmentDragEndDetails appointmentDragEndDetails) {
    var targetResource = appointmentDragEndDetails.targetResource;
    var sourceResource = appointmentDragEndDetails.sourceResource;
    _showDialog(targetResource!, sourceResource!);
  }

  void _showAppointmentDetails(Appointment appointment) {
    // Implement code to show the details of the clicked appointment
    // This could involve opening a dialog, a new screen, or any other UI mechanism
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(appointment.subject ?? "subject"),
          content: Text(appointment.notes ?? "notes"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showDialog(
      CalendarResource targetResource, CalendarResource sourceResource) async {
    await showDialog(
      builder: (context) => AlertDialog(
        title: const Text("Dropped resource details"),
        contentPadding: const EdgeInsets.all(16.0),
        content: Text("You have dropped the appointment from " +
            sourceResource.displayName +
            " to " +
            targetResource.displayName),
        actions: <Widget>[
          TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
      context: context,
    );
  }

  Widget appointmentBuilder(BuildContext context,
      CalendarAppointmentDetails calendarAppointmentDetails) {
    final Appointment appointment =
        calendarAppointmentDetails.appointments.first;
    if (_controller.view != CalendarView.month &&
        _controller.view != CalendarView.schedule) {
      setState(() {
        ViewChanged = true;
      });
    }
    return Column(
      children: [
        Container(
            width: calendarAppointmentDetails.bounds.width,
            height: calendarAppointmentDetails.bounds.height / 2,
            color: appointment.color,
            child: Center(
              child: Icon(
                Icons.group,
                color: Colors.black,
              ),
            )),
        Container(
          width: calendarAppointmentDetails.bounds.width,
          height: calendarAppointmentDetails.bounds.height / 2,
          color: appointment.color,
          child: Text(
            appointment.subject +
                DateFormat(' (hh:mm a').format(appointment.startTime) +
                '-' +
                DateFormat('hh:mm a)').format(appointment.endTime),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10),
          ),
        )
      ],
    );
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment>? source) {
    appointments = source;
  }
}
