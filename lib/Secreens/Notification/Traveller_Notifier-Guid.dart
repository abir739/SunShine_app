import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zenify_app/Secreens/TravelerProvider.dart';
import 'package:zenify_app/Settings/AppSettings.dart';
import 'package:zenify_app/modele/traveller/TravellerModel.dart';
import 'package:zenify_app/routes/SettingsProvider.dart';
import 'package:zenify_app/services/constent.dart';
import 'package:zenify_app/theme.dart';
import '../../modele/TouristGuide.dart';
import '../../modele/activitsmodel/httpActivites.dart';
import '../../modele/activitsmodel/httpToristGroup.dart';
import '../../modele/activitsmodel/httpToristguid.dart';
import '../../modele/touristGroup.dart';

class TravellerNotifierGuide extends StatefulWidget {
  TravellerNotifierGuide({Key? key}) : super(key: key);

  @override
  _TravellerNotifierGuideState createState() => _TravellerNotifierGuideState();
}

class _TravellerNotifierGuideState extends State<TravellerNotifierGuide> {
  List<TouristGroup>? touristGroup;
  TouristGroup? selectedTouristGroup = TouristGroup();
  TouristGuide? selectedTouristGuide = TouristGuide();
  final GlobalKey<FormState> Notificationkey = GlobalKey<FormState>();
  final count = HTTPHandlerCount();
  Traveller? traveller;
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bigPictureController = TextEditingController();
  final TextEditingController _linkUrlController = TextEditingController();
  final httpHandler = HTTPHandlerhttpToristguid();

  List<TouristGuide>? touristGuides;
  List<TouristGroup>? group;
  List<TouristGroup>? groupOptions = [];
  String? token;
  String baseUrl = "";
  String? guidid = "";
  bool islite = true;
  // get selectedPlanning => PlanningMainModel();
  Color ActivityColor = Color.fromARGB(255, 21, 19, 1);
  Color tranfercolor = Color.fromARGB(255, 21, 19, 1);
  Color box = Color.fromARGB(255, 21, 19, 1);
  Map<String, List<String>> selectedTagsMap = {
    "Guids": [],
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

  // ignore: non_constant_identifier_names
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
    // _loadData();
  }

  Future<void> _initializeTravelerData() async {
    final travelerProvider =
        Provider.of<TravelerProvider>(context, listen: false);
    try {
      final result = await travelerProvider.loadTraveler();
      print("result");
      setState(() {
        traveller = result;
        print("id ${traveller?.userId}");
        print("touristGroup ${traveller?.touristGroup}");
      });
    } catch (error) {
      // Handle the error as needed
      print("Error initializing traveler data: $error");
    }

    // Other initialization code if needed
    // _loadDatagroup();
  }
  // void _loadData() async {
  //   setState(() {
  //     touristGuides = []; // initialize the list to an empty list
  //   });
  //   final data = await httpHandler.fetchData("/api/tourist-guides");

  //   setState(() {
  //     touristGuides = data.cast<TouristGuide>();
  //     selectedTouristGuide = data.first;
  //   });
  //   _loadDatagroup(); // Call _loadDatagroup after loading data
  // }

  final httpHandlertorist = HTTPHandlerhttpGroup();
  String backendUrl = "";
  final storage = const FlutterSecureStorage();
  void _loadDatagroup() async {
    setState(() {
      touristGroup = [];
      group = []; // initialize the list to an empty list
      multiSelectItems = []; // initialize the list to an empty list
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
      "Guids": [],
    };

    for (var item in multiSelectItems) {
      if (item.selected) {
        String tagId = item.value.id!;
        selectedTagsMap["Guids"]!.add(tagId);
      }
    }

    return selectedTagsMap; // Always return the map
  }

  Future<void> sendNotification() async {
    try {
      token = (await storage.read(key: "access_token"));
      print("$token token");
      // selectedTagsMap = selectedTagsMapsendSelectedTags(multiSelectItems);
      var response = await http.post(
        Uri.parse('$baseUrls/api/push-notifications/guidNotifier'),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: json.encode({
          "message": _messageController.text, // Use the entered message
          "title": _titleController.text, // Use the entered title
          "type": _linkUrlController.text.isNotEmpty
              ? _linkUrlController.text
              : _bigPictureController
                  .text, // Use either link URL or picture URL
          "tags": {
            "Guids": ["${traveller?.touristGroup?.touristGuideId}"]
          },
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
        //  Navigator.of(context).pop();
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
    bool areItemsSelected = true;
    // selectedGroup.isNotEmpty;
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: const Color.fromARGB(255, 207, 207, 219),
      //   title: Row(
      //     children: [
      //       SvgPicture.asset(
      //         'assets/Frame.svg',
      //         fit: BoxFit.cover,
      //         height: 36.0,
      //       ),
      //       const SizedBox(width: 30),
      //       ShaderMask(
      //         shaderCallback: (Rect bounds) {
      //           return const LinearGradient(
      //             colors: [
      //               Color(0xFF3A3557),
      //               Color(0xFFCBA36E),
      //               Color(0xFFEB5F52),
      //             ],
      //           ).createShader(bounds);
      //         },
      //         child: const Text(
      //           'Push notification',
      //           style: TextStyle(
      //             fontSize: 24,
      //             color: Colors
      //                 .white, // You can adjust the font size and color here
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(3),
        child: Form(
          key: Notificationkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Card(
              //     margin: const EdgeInsets.all(14),
              //     shape: RoundedRectangleBorder(
              //       side: BorderSide(
              //         color: settingsProvider.isDarkMode
              //             ? MyThemes.lightTheme.splashColor
              //             : MyThemes.darkTheme.splashColor,
              //       ),
              //       borderRadius: BorderRadius.circular(15),
              //     ),
              //     child: guidid != null
              //         ? MultiSelectDialogField<TouristGroup>(
              //             items: multiSelectItems,
              //             isDismissible: false,
              //             initialValue: selectedGroup.toList(),
              //             dialogHeight: Get.height * 0.2,
              //             barrierColor: const Color.fromARGB(146, 129, 129, 129),
              //             title: const Text('Your Group List'),
              //             separateSelectedItems: true,
              //             selectedColor: settingsProvider.isDarkMode
              //                 ? MyThemes.lightTheme.splashColor.withOpacity(0.8)
              //                 : MyThemes.darkTheme.splashColor.withOpacity(0.8),
              //             searchable: true,
              //             selectedItemsTextStyle: TextStyle(
              //               fontWeight: FontWeight.bold,
              //               fontSize: 18,
              //               color: settingsProvider.isDarkMode
              //                   ? MyThemes.lightTheme.splashColor.withOpacity(0.8)
              //                   : MyThemes.darkTheme.splashColor.withOpacity(0.8),
              //             ),
              //             unselectedColor: Color.fromARGB(255, 177, 159, 2),
              //             validator: (value) {
              //               if (value == null || value.isEmpty) {
              //                 return 'Please select at least one group';
              //               }

              //               return null;
              //             },
              //             onConfirm: (List<TouristGroup> values) {
              //               setState(() {
              //                 selectedGroup = values.toSet();
              //               });
              //             },
              //             chipDisplay: MultiSelectChipDisplay<TouristGroup>(),
              //           )
              //         : SizedBox()),
              // // Container(
              //     decoration: const BoxDecoration(
              //       borderRadius: BorderRadius.all(Radius.circular(10)),
              //       color: Color.fromARGB(47, 181, 89, 3),
              //     ),
              //     alignment: Alignment.center,
              //     padding: const EdgeInsets.all(2.0),
              //     margin: const EdgeInsets.only(left: 20, right: 20),
              //     child: touristGuides!.isEmpty
              //         ? ElevatedButton(
              //             onPressed: () {
              //               // Handle button press, navigate to desired screen or perform any action
              //               // Get.to(AddTouristGuideScreen());
              //             },
              //             child: const Text(
              //                 'you are not effect to any tourist guid'),
              //           )
              //         : SizedBox(
              //             width: 880, // Set the desired width
              //             height: 50, // Set the desired height
              //             child: Row(
              //               children: [
              //                 DropdownButton<TouristGuide>(
              //                   borderRadius:
              //                       const BorderRadius.all(Radius.circular(20)),
              //                   dropdownColor:
              //                       const Color.fromARGB(255, 229, 224, 224),
              //                   iconEnabledColor:
              //                       const Color.fromARGB(160, 245, 241, 241),
              //                   iconDisabledColor:
              //                       const Color.fromARGB(255, 158, 158, 158),
              //                   value: selectedTouristGuide,
              //                   items: touristGuides!.map((touristGuide) {
              //                     return DropdownMenuItem<TouristGuide>(
              //                       value: touristGuide,
              //                       child: Row(
              //                         children: [
              //                           const Icon(
              //                             Icons.person,
              //                             size:
              //                                 20, // Set the desired size of the icon
              //                           ),
              //                           const SizedBox(
              //                               width:
              //                                   8), // Add some spacing between the icon and text
              //                           Text(
              //                             touristGuide.name ?? 'h',
              //                             style: const TextStyle(
              //                                 fontSize: 16,
              //                                 color:
              //                                     Color.fromARGB(255, 103, 1, 1)),
              //                           ),
              //                         ],
              //                       ),
              //                     );
              //                   }).toList(),
              //                   onChanged: (TouristGuide? newValue) {
              //                     selectedTouristGuide = newValue!;

              //                     _loadDatagroup();
              //                   },
              //                 ),
              //               ],
              //             ),
              //           )),
              const SizedBox(height: 32),
              // TextFields for title, message, picture URL, and link URL
              TextFormField(
                controller: _titleController,
                style: TextStyle(), // Set text style
                decoration: InputDecoration(
                  filled: true,
                  labelText: "Title", // Use labelText instead of hintText

                  floatingLabelBehavior:
                      FloatingLabelBehavior.auto, // Move the label to the top
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter Title';
                  }
                  if (value!.length < 4) {
                    return 'title Maste contain 4 caracter at mini';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _messageController, // Add this line
                decoration: InputDecoration(
                  filled: true,
                  labelText: "message", // Use labelText instead of hintText

                  floatingLabelBehavior:
                      FloatingLabelBehavior.auto, // Move the label to the top
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the Message ';
                  }
                  if (value!.length < 10) {
                    return 'Message Maste contain 10 caracter at mini';
                  }
                  return null;
                },
              ),
              //           const SizedBox(height: 32),
              //           TextField(
              //             controller: _bigPictureController,
              //              decoration: InputDecoration(
              //   filled: true,
              //   labelText: "URL", // Use labelText instead of hintText

              //   floatingLabelBehavior: FloatingLabelBehavior.auto, // Move the label to the top
              //   border: OutlineInputBorder(
              //     borderRadius: BorderRadius.circular(10),
              //   ),
              // ),
              //             keyboardType: TextInputType.url,
              //             textInputAction: TextInputAction.done,
              //             inputFormatters: [
              //               FilteringTextInputFormatter.deny(RegExp(
              //                   r'[^\s]+')), // Allow only spaces and characters from the URL
              //             ],
              //           ),
              //           const SizedBox(height: 32),
              //           TextField(
              //             controller: _linkUrlController,
              //              decoration: InputDecoration(
              //   filled: true,
              //   labelText: "image_link", // Use labelText instead of hintText

              //   floatingLabelBehavior: FloatingLabelBehavior.auto, // Move the label to the top
              //   border: OutlineInputBorder(
              //     borderRadius: BorderRadius.circular(10),
              //   ),
              // ),
              //             keyboardType: TextInputType.url,
              //             textInputAction: TextInputAction.done,
              //             inputFormatters: [
              //               FilteringTextInputFormatter.deny(RegExp(
              //                   r'[^\s]+')), // Allow only spaces and characters from the URL
              //             ],
              //           ),

              const SizedBox(height: 30),

              Visibility(
                visible: areItemsSelected,
                child: InkWell(
                  onTap: () {
                    if (Notificationkey.currentState!.validate()) {
                      sendNotification();
                    }
                  },
                  child: Chip(
                    padding: EdgeInsets.only(
                        top: 20, bottom: 20, left: 10, right: 10),
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

              // ElevatedButton(
              //   onPressed: () {
              //     sendNotification();
              //   },
              //   child: Text('Send Notification'),
              // ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: AppBottomNavigationBar(),
    );
  }
}
