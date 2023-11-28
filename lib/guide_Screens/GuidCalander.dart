import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/bottom_sheet/gf_bottom_sheet.dart';
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
import 'package:zenify_app/services/constent.dart';
import 'package:zenify_app/services/widget/LoadingScreen.dart';
import 'package:zenify_app/theme.dart';
import '../modele/accommodationsModel/accommodationModel.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../modele/transportmodel/transportModel.dart';

class GuidCalanderSecreen extends StatefulWidget {
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
  String dateString = DateTime.now().toString();
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
  }

  Future<void> fetchTravelers() async {
    try {
      final travelersData = await fetchTravelersByGroupIds(groupIdsList);
      setState(() {
        travelerss = travelersData;
      });
    } catch (e) {}
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

      print("User IDs: $userIds");

      print("Received travelers data: $results");

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
      print("Error initializing traveler data: $error");
    }

    await _initializeData();
    try {
      print("First User's Email:$guideid");

      final Guide = await travelerProvider.loadDataGuidDetail();
      travellers = await travellersH.fetchData("/api/travellers");
      travelersWithNonNullPictures = travellers!
          .where((traveler) => traveler.user?.picture != null)
          .toList();

      String? images = travellers![0].user?.picture;
    } catch (e) {}
  }

  Future<void> fetchData() async {
    try {
      transferList =
          await fetchTransfers("/api/transfers/touristGuidId/$guideid");
    } catch (e) {
      // Handle error for transferList
      print("Error fetching transfer data: $e");
    }

    try {
      // Fetch Activityst with a specific touristGroupId
      Activityst = await activiteshanhler
          .fetchData("/api/activities?filters[touristGuideId]=$guideid");
    } catch (e) {
      print("Error fetching activity data: $e");
    }
    try {
      // Fetch Activityst with a specific touristGroupId
      taskslist = await taskshanhler
          .fetchData("/api/tasks?filters[touristGuideId]=$guideid");
    } catch (e) {
      print("Error fetching task data: $e");
    }

    setState(() {});
  }

  Future<void> _refrech() async {
    List<Transport> transfersList1 =
        await fetchTransfers("/api/transfers/touristGuidId/$guideid");
    List<Activity> Activityst1 = await activiteshanhler
        .fetchData("/api/activities?filters[touristGuideId]=$guideid");
    List<Tasks> taskslist1 = await taskshanhler
        .fetchData("/api/tasks?filters[touristGuideId]=$guideid");

    setState(() {
      calendarDataSource!.appointments?.clear();

      print("data refreshed");
      transfersList = transfersList1;
      activityList = Activityst1;
      taskslist = taskslist1;

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
      print("An exception occurred: $e");
      transfersList1 = [];
    }
    try {
      Activityst1 = await activiteshanhler
          .fetchData("/api/activities?filters[touristGuideId]=$guideid");
      print("An exception occurred Activity: 1 ");
    } catch (e) {
      print("An exception occurred Activity: $e");
      Activityst1 = [];
    }
    try {
      taskslist1 = await taskshanhler
          .fetchData("/api/tasks?filters[touristGuideId]=$guideid");
    } catch (e) {
      print("An exception occurred: $e");
      taskslist1 = [];
    }

    setState(() {
      print("data refreshed");
      transfersList = transfersList1;
      activityList = Activityst1;
      taskslist = taskslist1;

      calendarDataSource =
          _getCalendarDataSources(transfersList1, Activityst1, taskslist1);
    });
  }

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

  callback(refreshdate) {
    setState(() {
      _initializeData();
      _initializeData();
    });
  }

  Future<Map<String, List<dynamic>>> fetchDataAndOrganizeEvents() async {
    try {
      transfersList = await fetchTransfers(
        "/api/transfers/touristGuidId/$guideid",
      );
      Activityst = await activiteshanhler
          .fetchData("/api/activities?filters[touristGuideId]=$guideid");
      taskslist = await taskshanhler
          .fetchData("/api/tasks?filters[touristGuideId]=$guideid");
      List<CalendarEvent> CalendarEvents =
          convertToCalendarEvents(transfersList!, Activityst, taskslist!);

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
      final data = json.decode(response.body);
      final ApiResponse responsei = ApiResponse.fromJson(data);

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
          color: Color.fromARGB(255, 235, 235, 202),
        ));
      }
    }

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
            color: Color.fromARGB(206, 153, 153, 152),
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
            color: Color.fromARGB(255, 211, 127, 17),
          ));
        }
      }
    }
    return _DataSource(appointments);
  }

  void calendarTapped(
      BuildContext context, CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement == CalendarElement.appointment) {
      List<dynamic> appointments = calendarTapDetails.appointments ?? [];

      if (appointments.isNotEmpty) {
        Appointment eventId = appointments[0];
        AppointmentType appointmentType = eventId.appointmentType;

        Transport? transport = transfersList!.firstWhereOrNull(
          (transport) => transport.id == eventId.id,
        );
        Tasks? task = taskslist!.firstWhereOrNull(
          (taskes) => taskes.id == eventId.id,
        );

        Activity? activity = activityList!.firstWhereOrNull(
          (activity) => activity.id == eventId.id,
        );

        if (transport != null) {
          _onAppointmentTapped(transport);
        } else if (activity != null) {
          _onAppointmentTapped(activity);
        } else if (task != null) {
          _onAppointmentTapped(task);
        } else {
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

  @override
  Widget build(BuildContext context) {
    ScrollControllerProvider scrollControllerProvider =
        ScrollControllerProvider();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.addListener(() {
        double value = controller.offset / 2;

        setState(() {
          topContainer = value;
          closeTopContainer = controller.offset > 20;

          hideitem = closeTopContainer;
          setState(() {
            hideitem = closeTopContainer;
          });
        });
      });
    });
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
        loadingText: "Loading...",
      );
    }
    return Scaffold(
      bottomSheet: Visibility(
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
                            return Text(
                              'Task (${index + 1}) Name : ${task.description}',
                              style: TextStyle(
                                fontSize: 14,
                                wordSpacing: 0.3,
                                letterSpacing: 0.2,
                              ),
                            );
                          }
                        }
                        return SizedBox.shrink();
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
                            width: 400,
                            height: 300,
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
              ],
            ),
          ),
          stickyFooterHeight: 20,
        ),
      ),
      body: Column(
        children: [
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
                        todayHighlightColor: const Color(0xFFEB5F52),
                        todayTextStyle: const TextStyle(
                            fontStyle: FontStyle.normal,
                            fontSize: 27,
                            fontWeight: FontWeight.w900,
                            color: Color.fromARGB(255, 238, 234, 238)),
                        monthCellBuilder:
                            (BuildContext context, MonthCellDetails details) {
                          return Container(
                            decoration: BoxDecoration(
                              color: details.date.month == DateTime.now().month
                                  ? const Color.fromARGB(255, 245, 242, 242)
                                  : const Color.fromARGB(255, 179, 228, 236),
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 207, 207, 219),
                                  width: 0.5),
                            ),
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Text(
                                  details.date.day.toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: details.visibleDates
                                            .contains(details.date)
                                        ? Colors.black87
                                        : const Color.fromARGB(
                                            255, 158, 158, 158),
                                  ),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  details.appointments.length.toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: details.visibleDates
                                            .contains(details.date)
                                        ? const Color.fromARGB(255, 87, 6, 134)
                                        : const Color.fromARGB(255, 87, 6, 134),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        headerHeight: 35,
                        controller: _controller,
                        view: CalendarView.month,
                        scheduleViewMonthHeaderBuilder: (BuildContext context,
                            ScheduleViewMonthHeaderDetails details) {
                          return SizedBox(
                            height: 20,
                            child: Chip(
                              label: Center(
                                child: Text(
                                  'Custom Header',
                                  style: TextStyle(
                                    color: Colors.white,
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
                          calendarTapped(context, details);
                        },
                        showDatePickerButton: true,
                        resourceViewSettings: ResourceViewSettings(
                            visibleResourceCount: 4,
                            showAvatar: true,
                            displayNameTextStyle: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 12,
                                fontWeight: FontWeight.w400)),
                        initialDisplayDate: DateTime.parse(dateString),
                        dataSource: calendarDataSource,
                        monthViewSettings: MonthViewSettings(
                            navigationDirection:
                                MonthNavigationDirection.vertical,
                            showAgenda: false,
                            appointmentDisplayMode:
                                MonthAppointmentDisplayMode.indicator,
                            numberOfWeeksInView: 3,
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
          Visibility(
            child: Column(
              children: [
                SafeArea(
                  child: FittedBox(
                    child: Container(
                      height: hideitem ? Get.height * 1.62 : Get.height * 1,
                      width: Get.width * 2,
                      child: SafeArea(
                        child: ListView.separated(
                          shrinkWrap: true,
                          controller: controller,
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

                            final appointmentObject =
                                getAppointmentObject(appointment.id as String?);

                            String imageName = '';
                            String name = '';
                            String additionalDetails = '';
                            DateTime startedAt = DateTime.now();
                            DateTime endAt = DateTime.now();
                            if (appointmentObject is Activity) {
                              card =
                                  ActivityCard(appointmentObject as Activity);
                            } else if (appointmentObject is Transport) {
                              card = TransferCard(
                                  appointmentObject as Transport,
                                  travelersData);
                              imageName =
                                  "data:image/jpeg;base64,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"
                                      as String;
                              name = appointmentObject.to as String;
                              additionalDetails = appointmentObject.from ??
                                  'Additional details for Transport';
                            } else if (appointmentObject is Tasks) {
                              card = TaskCard(appointmentObject as Tasks);

                              imageName =
                                  "data:image/jpeg;base64,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"
                                      as String;
                              name = 'Task';

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

  dynamic getAppointmentObject(String? appointmentId) {
    Transport? transport = transfersList!
        .firstWhereOrNull((transport) => transport.id == appointmentId);
    Tasks? task =
        taskslist!.firstWhereOrNull((task) => task.id == appointmentId);
    Activity? activity = activityList!
        .firstWhereOrNull((activity) => activity.id == appointmentId);

    if (activity != null) {
      return activity;
    } else if (transport != null) {
      return transport;
    } else if (task != null) {
      return task;
    } else {
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

      if (calendarDataSource!.appointments == null ||
          calendarDataSource!.appointments!.isEmpty) {
        return;
      }

      final selectedDateOnly =
          DateTime(selectedDate!.year, selectedDate.month, selectedDate.day);

      for (final appointment in calendarDataSource!.appointments!) {
        final appointmentStartDate = appointment.startTime.toLocal();
        final appointmentEndDate = appointment.endTime.toLocal();

        if (appointmentStartDate
                .isBefore(selectedDate!.add(Duration(days: 1))) &&
            appointmentEndDate.isAfter(selectedDate)) {
          setState(() {
            _appointmentDetails.add(appointment);
          });
        }
      }
    });
  }

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
                        }),
                      );

                      if (response.statusCode == 201) {
                        fetchTasks();
                        Navigator.of(context).pop(true);
                      } else {
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
                        fetchTasks();
                        Navigator.of(context).pop(true);
                      } else {
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
                        }),
                      );

                      if (response.statusCode == 201) {
                        fetchTasks();
                        Navigator.of(context).pop(true);
                      } else {
                        print("Error adding task: ${response.statusCode}");
                      }
                    }
                  },
                ),
              ],
            );
        });

    if (result == true) {}
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
                    Navigator.of(context).pop(false);
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
                        }),
                      );

                      if (response.statusCode == 201) {
                        Navigator.of(context).pop(true);
                      } else {
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
                    Navigator.of(context).pop(false);
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
                        }),
                      );

                      if (response.statusCode == 201) {
                        fetchTasks();
                        Navigator.of(context).pop(true);
                      } else {
                        print("Error adding task: ${response.statusCode}");
                      }
                    }
                  },
                ),
              ],
            );
        });

    if (result == true) {}
  }

  void _onTransferAppointmentTapped(Transport? transfer) {
    print("${transfer}''''");
    print("${transfer}fff");
    print("${transfer}fff");
    print("${transfer}fff");
    print("${transfer}");
  }

  Future<void> _deleteItem(BuildContext context, dynamic item) async {
    String? token = await storage.read(key: "access_token");

    if (item is Tasks) {
      String url = "$baseUrls/api/tasks/${item.id}";
      final response = await http.delete(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 204) {
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
      print("deleting activity");
      String url = "$baseUrls/api/activities/${item.id}";
      final response = await http.delete(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 204) {
        activityList!.remove(item);

        setState(() {
          _initializeData();
        });
      } else {
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
        transferList.remove(item);

        setState(() {
          _initializeData();
        });
      } else {
        print("Error deleting trasfer: ${response.statusCode}");
      }
    }
  }

  Future<void> _deleteTask(Tasks task) async {
    String? token = await storage.read(key: "access_token");
    String url = "$baseUrls/api/tasks/${task.id}";

    final response = await http.delete(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 204) {
      tasks.remove(task);

      setState(() {});
    } else {
      print("Error deleting task: ${response.statusCode}");
    }
  }

  void _onAppointmentTapped(dynamic item) {
    print('Tapped on object of type: ${item.runtimeType}');

    if (item is Tasks) {
      Tasks task = item as Tasks;
      print('Tapped on task with ID: ${task.id}');
    } else if (item is Activity) {
      Activity activity = item as Activity;
      print('Tapped on activity with ID: ${activity.id}');
    } else if (item is Transport) {
      Transport transport = item as Transport;
      print('Tapped on transport with ID: ${transport.id}');
    } else {
      print('Tapped on an object of an unknown type.');
    }

    showItemDetailsScreen(context, item);
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
