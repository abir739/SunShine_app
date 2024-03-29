import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:http/http.dart' as http;
import 'package:SunShine/guide_Screens/Event_Details.dart';
import 'package:SunShine/login/Login.dart';
import 'package:SunShine/services/constent.dart';
import 'dart:convert';
import 'package:SunShine/modele/activitsmodel/activitesmodel.dart';
import 'package:SunShine/modele/tasks/taskModel.dart';
import 'package:SunShine/modele/transportmodel/transportModel.dart';
import 'package:get/get.dart';

class EventCalendarDataSource extends CalendarDataSource {
  EventCalendarDataSource(List<Appointment> source) {
    appointments = source;
  }
}

class EventCalendar extends StatefulWidget {
  final String? guideId;

  EventCalendar({required this.guideId});

  @override
  _EventCalendarState createState() => _EventCalendarState();
}

class _EventCalendarState extends State<EventCalendar> {
  List<Activity> activities = [];
  List<Tasks> tasks = [];
  List<Transport> transfers = [];
  final CalendarController _controller = CalendarController();

  @override
  void initState() {
    super.initState();
    fetchActivities();
    fetchTasks();
    fetchTransfers();
  }

  Future<void> fetchActivities() async {
    String? token = await storage.read(key: "access_token");
    String formatter(String url) {
      return baseUrls + url;
    }

    String url =
        formatter("/api/activities?filters[touristGuideId]=${widget.guideId}");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> results = data["results"];
      activities =
          results.map((groupData) => Activity.fromJson(groupData)).toList();
      // Update the data source
      setState(() {});
    } else {
      print("Error fetching tourist groups: ${response.statusCode}");
      // Handle error here
    }
  }

  Future<void> fetchTasks() async {
    String? token = await storage.read(key: "access_token");
    String formatter(String url) {
      return baseUrls + url;
    }

    String url =
        formatter("/api/tasks?filters[touristGuideId]=${widget.guideId}");

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

  Future<void> fetchTransfers() async {
    String? token = await storage.read(key: "access_token");
    String formatter(String url) {
      return baseUrls + url;
    }

    String url = formatter("/api/transfers/touristGuidId/${widget.guideId}");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> results = data["results"];
      transfers =
          results.map((groupData) => Transport.fromJson(groupData)).toList();
      // Update the data source
      setState(() {});
    } else {
      print("Error fetching tourist groups: ${response.statusCode}");
      // Handle error here
    }
  }

  void _onTransferAppointmentTapped(Transport transfer) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EventView(
          transport: transfer,
          onSave: handleEventSave, // Pass the method
        ),
      ),
    );
  }

  void handleEventSave(Transport updatedEvent) {
    setState(() {
      // Update the event list with the changes
      int index =
          transfers.indexWhere((element) => element.id == updatedEvent.id);
      if (index != -1) {
        transfers[index] = updatedEvent;
      }
    });
  }

  Future<void> _showAddTaskDialog(BuildContext context) async {
    final TextEditingController descriptionController = TextEditingController();
    DateTime? selectedDate;

    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Add Task",
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
                      "touristGuideId": widget.guideId,
                      "description": newTaskDescription,
                      "todoDate": newTaskTodoDate,
                      // Add other task properties as needed
                    }),
                  );

                  if (response.statusCode == 201) {
                    // Task added successfully, update the calendar
                    fetchTasks();
                    Navigator.of(context).pop(true); // Return true on success
                  } else {
                    // Handle error
                    print("Error adding task: ${response.statusCode}");
                  }
                }
              },
            ),
          ],
        );
      },
    );

    if (result == true) {
      // Task was added successfully
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

  // Function to show the edit task dialog
  Future<void> _showEditTaskDialog(BuildContext context, Tasks task) async {
    final TextEditingController descriptionController =
        TextEditingController(text: task.description);
    DateTime? selectedDate = task.todoDate;

    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Edit Task",
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
                'Save',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
              onPressed: () async {
                String updatedTaskDescription = descriptionController.text;
                String? updatedTaskTodoDate;

                if (selectedDate != null) {
                  updatedTaskTodoDate = selectedDate?.toLocal().toString();
                }

                // Send a PUT request to update the task
                String? token = await storage.read(key: "access_token");
                String url = "$baseUrls/api/tasks/${task.id}";
                final response = await http.put(
                  Uri.parse(url),
                  headers: {
                    "Authorization": "Bearer $token",
                    "Content-Type": "application/json",
                  },
                  body: jsonEncode({
                    "description": updatedTaskDescription,
                    "todoDate": updatedTaskTodoDate,
                    // Add other task properties as needed
                  }),
                );

                if (response.statusCode == 200) {
                  // Task updated successfully, update the calendar
                  fetchTasks();
                  Navigator.of(context).pop(true); // Return true on success
                } else {
                  // Handle error
                  print("Error updating task: ${response.statusCode}");
                }
              },
            ),
          ],
        );
      },
    );

    if (result == true) {
      // Task was edited successfully
    }
  }

  void _onTaskAppointmentTapped(Tasks task) {
    print('Tapped on task with ID: ${task.id}');
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.add),
                  title: const Text('Add New'),
                  onTap: () {
                    _showAddTaskDialog(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Delete'),
                  onTap: () {
                    _deleteTask(task);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Edit'),
                  onTap: () {
                    // Handle "Edit" option
                    Navigator.of(context).pop();
                    _showEditTaskDialog(context, task); // Call the edit dialog
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: 435, // Fixed width of 335px
          height: 660,
          child: SfCalendar(
            todayHighlightColor: const Color(0xFFEB5F52),
            todayTextStyle: const TextStyle(
                fontStyle: FontStyle.normal,
                fontSize: 27,
                fontWeight: FontWeight.w900,
                color: Color.fromARGB(255, 238, 234, 238)),
            monthCellBuilder: (BuildContext context, MonthCellDetails details) {
              return Container(
                decoration: BoxDecoration(
                  color: details.date.month == DateTime.now().month
                      ? const Color.fromARGB(255, 245, 242, 242)
                      : const Color.fromARGB(255, 179, 228, 236),
                  border: Border.all(
                      color: const Color.fromARGB(255, 207, 207, 219),
                      width: 0.5),
                ),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(
                      details.date.day.toString(),
                      style: TextStyle(
                        fontSize: 20,
                        color: details.visibleDates.contains(details.date)
                            ? Colors.black87
                            : const Color.fromARGB(255, 158, 158, 158),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      details.appointments.length.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        color: details.visibleDates.contains(details.date)
                            ? const Color.fromARGB(255, 87, 6, 134)
                            : const Color.fromARGB(255, 87, 6, 134),
                      ),
                    ),
                  ],
                ),
              );
            },
            headerHeight: 50,
            controller: _controller,
            allowedViews: const <CalendarView>[
              CalendarView.month,
              CalendarView.schedule,
            ],
            view: CalendarView.month,
            showDatePickerButton: true,
            monthViewSettings: const MonthViewSettings(
              showAgenda: true,
              agendaViewHeight: 350,
              numberOfWeeksInView: 3,
              agendaItemHeight: 90,
            ),
            dataSource: EventCalendarDataSource(_getCalendarAppointments()),
            onTap: (CalendarTapDetails details) {
              if (details.targetElement == CalendarElement.appointment) {
                Appointment tappedAppointment = details.appointments![0];
                String appointmentSubject = tappedAppointment.subject;

                if (appointmentSubject.startsWith('Task')) {
                  // Find the associated task
                  Tasks task = tasks.firstWhere(
                    (t) => 'Task: ${t.description}' == appointmentSubject,
                    orElse: () => Tasks(description: ''),
                  );

                  // Show Options for the task appointment
                  _onTaskAppointmentTapped(task);
                } else if (appointmentSubject.startsWith('Transfer')) {
                  Transport transfer = transfers.firstWhere(
                    (t) =>
                        'Transfer: ${t.from} to ${t.to}' == appointmentSubject,
                    orElse: () => Transport(),
                  );

                  _onTransferAppointmentTapped(transfer);
                }
              }
            },
          ),
        ),
      ),
    );
  }

  List<Appointment> _getCalendarAppointments() {
    List<Appointment> appointments = [];

    // Add activities to the calendar
    for (var activity in activities) {
      appointments.add(Appointment(
        startTime: activity.departureDate!,
        endTime: activity.returnDate!,
        subject: '$surfingEmoji 🏕️ Activity: ${activity.agency}',
        color: const Color.fromARGB(255, 240, 70, 223),
      ));
    }

    // Add tasks to the calendar
    for (var task in tasks) {
      appointments.add(Appointment(
        startTime: task.todoDate!,
        endTime: task.todoDate!,
        subject: '$calendarEmoji Task: ${task.description}',
        color: Colors.green,
      ));
    }

    // Add transfers to the calendar
    for (var transfer in transfers) {
      appointments.add(Appointment(
        startTime: transfer.date!,
        endTime:
            transfer.date!.add(Duration(hours: transfer.durationHours ?? 0)),
        subject:
            '$transportEmoji ✈️ Transport: ${transfer.from} to ${transfer.to}',
        color: const Color(0xFFCBA36E),
      ));
    }

    return appointments;
  }
}
