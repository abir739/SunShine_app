import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:SunShine/Settings/AppSettings.dart';
import 'package:SunShine/routes/SettingsProvider.dart';
import 'package:SunShine/services/GuideProvider.dart';
import 'package:SunShine/services/constent.dart';
import 'package:SunShine/theme.dart';
import '../../modele/TouristGuide.dart';
import '../../modele/activitsmodel/httpActivites.dart';
import '../../modele/activitsmodel/httpToristGroup.dart';
import '../../modele/activitsmodel/httpToristguid.dart';
import '../../modele/touristGroup.dart';

class PushNotificationGuideScreen extends StatefulWidget {
  String? guid;
  PushNotificationGuideScreen(this.guid, {Key? key}) : super(key: key);

  @override
  _PushNotificationGuideScreenState createState() =>
      _PushNotificationGuideScreenState();
}

class _PushNotificationGuideScreenState
    extends State<PushNotificationGuideScreen> {
  List<TouristGuide>? touristGuides;
  List<TouristGroup>? group;
  List<TouristGroup>? groupOptions = [];
  List<TouristGroup>? touristGroup;
  TouristGroup? selectedTouristGroup = TouristGroup();
  TouristGuide? selectedTouristGuide = TouristGuide();
  final count = HTTPHandlerCount();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bigPictureController = TextEditingController();
  final TextEditingController _linkUrlController = TextEditingController();
  final httpHandler = HTTPHandlerhttpToristguid();

  String token = "";
  String baseUrl = "";
  String? guidid = "";
  bool islite = true;
  // get selectedPlanning => PlanningMainModel();
  Color ActivityColor = Color.fromARGB(255, 21, 19, 1);
  Color tranfercolor = Color.fromARGB(255, 21, 19, 1);
  Color box = Color.fromARGB(255, 21, 19, 1);
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

  List<String> Tags = [];

  Set<TouristGroup> selectedGroup = {};
  @override
  void initState() {
    super.initState();
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
    _initializeTravelerData();
    print("$guidid{widget.guid}");
  }

  Future<void> _initializeTravelerData() async {
    final travelerProvider = Provider.of<guidProvider>(context, listen: false);

    try {
      final result = await travelerProvider.loadDataGuid();
      print("result");
      setState(() {
        guidid = result;
        print("$guidid{widget.guid}");
      });
    } catch (error) {
      print("Error initializing traveler data: $error");
    }

    _loadDatagroup();
  }

  final httpHandlertorist = HTTPHandlerhttpGroup();
  String backendUrl = "";
  final storage = const FlutterSecureStorage();
  void _loadDatagroup() async {
    setState(() {
      touristGroup = [];
      group = [];
      multiSelectItems = [];
    });
    final data = await httpHandlertorist
        .fetchData("/api/tourist-groups?filters[touristGuideId]=$guidid");

    setState(() {
      touristGroup = data.cast<TouristGroup>();
      selectedTouristGroup = data.first;
      group = touristGroup;
      initializeMultiSelectItems();
    });
  }

  Map<String, List<String>> selectedTagsMapsendSelectedTags(
    List<MultiSelectItem<TouristGroup>> multiSelectItems,
  ) {
    Map<String, List<String>> selectedTagsMap = {
      "Groupids": [],
    };

    for (var item in multiSelectItems) {
      if (item.selected) {
        String tagId = item.value.id!;
        selectedTagsMap["Groupids"]!.add(tagId);
      }
    }

    return selectedTagsMap;
  }

  Future<void> sendNotification() async {
    try {
      selectedTagsMap = selectedTagsMapsendSelectedTags(multiSelectItems);
      var response = await http.post(
        Uri.parse('$baseUrls/api/push-notificationsMobile/notification'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "message": _messageController.text, // Use the entered message
          "title": _titleController.text, // Use the entered title
          "type": _linkUrlController.text.isNotEmpty
              ? _linkUrlController.text
              : _bigPictureController
                  .text, // Use either link URL or picture URL
          "tags": selectedTagsMap,
          "mutable_content": false,
          "android_sound": null,
          "small_icon": null,
          "large_icon": null,
          "big_picture":
              "https://www.destinationtunisie.info/wp-content/uploads/2019/05/hotel_barcelo_sousse_-marhaba.jpg",
          "android_led_color": "ed0000",
          "android_accent_color": "ed0000",
          "android_group": null,
          "android_visibility": 0,
          "app_id": "****"
        }),
      );

      if (response.statusCode == 201) {
        // Notification sent successfully
        print('Selected Tags Map: $selectedTagsMap');
        print('Notification sent successfully!');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Custom Dialog'),
              content: Container(
                width: 200, // Adjust the width as needed
                height: 200, // Adjust the height as needed
                child: Column(
                  children: [
                    Text('Rsend again'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('resend'),
                ),
              ],
            );
          },
        );
      } else {
        print(
            'Failed to send notification. Status code: ${response.statusCode}');
        print('Selected Tags Map: $selectedTagsMap');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    islite = settingsProvider.isDarkMode;
    bool areItemsSelected = selectedGroup.isNotEmpty;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
                margin: const EdgeInsets.all(14),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: settingsProvider.isDarkMode
                        ? MyThemes.lightTheme.splashColor
                        : MyThemes.darkTheme.splashColor,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: guidid != null
                    ? MultiSelectDialogField<TouristGroup>(
                        items: multiSelectItems,
                        isDismissible: false,
                        initialValue: selectedGroup.toList(),
                        dialogHeight: Get.height * 0.2,
                        barrierColor: const Color.fromARGB(146, 129, 129, 129),
                        title: const Text('Your Group List'),
                        separateSelectedItems: true,
                        selectedColor: settingsProvider.isDarkMode
                            ? MyThemes.lightTheme.splashColor.withOpacity(0.8)
                            : MyThemes.darkTheme.splashColor.withOpacity(0.8),
                        searchable: true,
                        selectedItemsTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: settingsProvider.isDarkMode
                              ? MyThemes.lightTheme.splashColor.withOpacity(0.8)
                              : MyThemes.darkTheme.splashColor.withOpacity(0.8),
                        ),
                        unselectedColor: Color.fromARGB(255, 177, 159, 2),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select at least one group';
                          }

                          return null;
                        },
                        onConfirm: (List<TouristGroup> values) {
                          setState(() {
                            selectedGroup = values.toSet();
                          });
                        },
                        chipDisplay: MultiSelectChipDisplay<TouristGroup>(),
                      )
                    : SizedBox()),
            const SizedBox(height: 32),
            TextField(
              controller: _titleController,
              style: TextStyle(),
              decoration: InputDecoration(
                filled: true,
                labelText: "Title",
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                filled: true,
                labelText: "message",
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 60),
            Visibility(
              visible: areItemsSelected,
              child: InkWell(
                onTap: () {
                  sendNotification();
                },
                child: Chip(
                  padding:
                      EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
                  backgroundColor: settingsProvider.isDarkMode
                      ? MyThemes.lightTheme.splashColor.withOpacity(0.8)
                      : MyThemes.darkTheme.splashColor.withOpacity(0.8),
                  label: Text(
                    'Send Notification To Your Group',
                    style: TextStyle(
                      color: settingsProvider.isDarkMode
                          ? MyThemes.buttoncolor
                          : MyThemes.buttoncolor,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
