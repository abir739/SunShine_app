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
import 'package:zenify_app/guide_Screens/Activity_Details.dart';
import 'package:zenify_app/guide_Screens/Event_Details.dart';
import 'package:zenify_app/guide_Screens/task_Details.dart';

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

  void calendarTappedInkwell(BuildContext context, dynamic appointmentObject) {
    print("$appointmentObject");
    if (appointmentObject is Transport) {
      _onAppointmentTapped(appointmentObject);
      // Navigate to the Transport view
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EventView(
            transport: appointmentObject,
            onSave: handleEventSave, // Pass the method
          ),
        ),
      );
    } else if (appointmentObject is Activity) {
      _onAppointmentTapped(appointmentObject);
      // Navigate to the Activity view
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ActivityView(
            activity: appointmentObject,
          ),
        ),
      );
    } else if (appointmentObject is Tasks) {
      _onAppointmentTapped(appointmentObject);
      // Navigate to the Task view
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TaskView(
            task: appointmentObject,
          ),
        ),
      );
    } else {
      // Handle the case where the event type is unknown
      print('Unknown event type for eventId: $appointmentObject');
    }
  }

  @override
  Widget build(BuildContext context) {
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

    final settingsProvider = Provider.of<SettingsProvider>(context);

    if (taskslist!.isEmpty == true &&
        activityList!.isEmpty == true &&
        transferList!.isEmpty == true) {
      return LoadingScreen(
        loadingText: "Loading...",
      );
    }
    return Scaffold(
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

                            if (appointmentObject is Activity) {
                              card =
                                  ActivityCard(appointmentObject as Activity);
                            } else if (appointmentObject is Transport) {
                              card = TransferCard(
                                  appointmentObject as Transport,
                                  travelersData);
                            } else if (appointmentObject is Tasks) {
                              card = TaskCard(appointmentObject as Tasks);
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
  }
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment>? source) {
    appointments = source;
  }
}
