import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:palette_generator/palette_generator.dart';
import 'package:SunShine/modele/activitsmodel/activitesmodel.dart';
import 'package:SunShine/modele/activitsmodel/activityTempModel.dart';
import 'package:SunShine/modele/activitsmodel/httpActivitesTempid.dart';
import 'package:SunShine/modele/tasks/taskModel.dart';
import 'package:SunShine/modele/transportmodel/transportModel.dart';
import 'package:SunShine/services/ServiceWedget/ImageWithDynamicBackgroundColor.dart';
import 'package:SunShine/services/constent.dart';
import 'package:http/http.dart' as http;
import 'package:SunShine/services/widget/LoadingScreen.dart';

class WeatherData {
  final String location;
  final double temperature;
  final String weatherCondition;
  final String weatherdescription;
  final double speed;

  WeatherData({
    required this.location,
    required this.temperature,
    required this.weatherCondition,
    required this.weatherdescription,
    required this.speed,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    // Parse the JSON data and create a WeatherData object
    return WeatherData(
      location: json['name'],
      temperature: json['main']['temp'],
      weatherCondition: json['weather'][0]['main'],
      speed: json['wind']['speed'],
      weatherdescription: json['weather'][0]['description'],
    );
  }
}

class ItemDetailsScreen extends StatefulWidget {
  final dynamic item;

  ItemDetailsScreen({required this.item});

  @override
  _ItemDetailsScreenState createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  final TextEditingController descriptionController = TextEditingController();
  DateTime? selectedDate;
  HTTPHandlerActivitestempId handelactivitytmp = HTTPHandlerActivitestempId();
  ActivityTemplate? activityTemplate;

  WeatherData? weatherData;
  late Future<void> fetchDataAndFetchWeather;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchDataAndFetchWeather = fetchWeatherData();
  }

  Future<void> fetchWeatherData() async {
    final coordinates = await getActivityData();
    if (coordinates.isNotEmpty) {
      final latitude = coordinates['latitude'];
      final longitude = coordinates['longitude'];
      await fetchWeather(latitude, longitude);
    }
  }

  Future<void> fetchWeather(double? latitude, double? longitude) async {
    print("wather");
    final apiKey =
        '1ebac42f4be295e3a53248155259fe0c'; // Replace with your actual API key
    final apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        weatherData = WeatherData.fromJson(json.decode(response.body));
        // Process weatherData to get the weather information
        print("${weatherData?.weatherCondition} watherss");
      } else {
        throw Exception('Failed to load weather data watherss');
      }
    } catch (e) {
      print("$e");
    }
  }

  Future<Color> getImagePalette(ImageProvider imageProvider) async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(imageProvider);
    return paletteGenerator.dominantColor!.color;
  }

  Future<Map<String, double>> getActivityData() async {
    if (widget.item is Activity) {
      try {
        final activityData = await getActivityById(
            "/api/activity-templates/${widget.item.activityTemplateId}");
        if (activityData != null) {
          final Map<String, double> coordinatesMap = {};
          setState(() {
            activityTemplate = activityData;
            print("fetching Activity: ${activityTemplate?.coordinates}");
            if (activityTemplate != null &&
                activityTemplate?.coordinates != null) {
              final coordinates = activityTemplate?.coordinates!;
              final binaryCoordinates = jsonEncode(coordinates);
              final parsedCoordinates = parseCoordinates(binaryCoordinates);
              coordinatesMap['latitude'] = parsedCoordinates[0];
              coordinatesMap['longitude'] = parsedCoordinates[1];
            }
          });
          return coordinatesMap;
        }
      } catch (e) {
        // Handle errors, e.g., show an error message
        print("Error fetching Activity: $e");
      }
    }
    // Return null or an empty map in case of failure or when not fetching Activity data.
    return {};
  } //   List<double> parseCoordinates(String binaryCoordinates) {
//     final jsonMap = jsonDecode(binaryCoordinates);
//     final coordinates = jsonMap['coordinates'] as List<dynamic>;
//     final latitude = coordinates[0] as double;
//     final longitude = coordinates[1] as double;
//     return [latitude, longitude];
//   }

  // void openMapApp(
  //   double latitude,
  //   double longitude, {
  //   String? placeQuery,
  //   bool trackLocation = false,
  //   bool map_action = true,
  //   Color? color,
  //   AssetImage? markerImage = const AssetImage('assets/Male.png'),
  //   // markerImage = const AssetImage('assets/Male.png'),
  // }) {
  //   double zoomLevel = 40;
  //   String url =
  //       'geo:$latitude,$longitude?z=$zoomLevel&color=${color!.value.toRadixString(16)}';
  //   if (placeQuery != null) {
  //     url += '&q=$placeQuery'; // Add the q parameter with the place query
  //   }
  //   if (markerImage != null) {
  //     url += '&marker=$color'; // Add the marker with the coordinates
  //   }
  //   if (placeQuery != null) {
  //     placeQuery = placeQuery!.replaceAll('{latitude}', '$latitude');
  //     placeQuery = placeQuery.replaceAll('{longitude}', '$longitude');
  //     url +=
  //         '&q=$placeQuery'; // Add the q parameter with the modified place query
  //   }
  //   // if (trackLocation) {
  //   //   Location().enableBackgroundMode(enable: true);
  //   // }
  //   url += '&map_action=map';
  //   print('url $url');
  //   final encodedUrl = Uri.encodeFull(url);
  //   launch(encodedUrl);
  // }
  // List<double> parseCoordinates(String binaryCoordinates) {
  //   final jsonMap = jsonDecode(binaryCoordinates);
  //   final coordinates = jsonMap['coordinates'] as List<dynamic>;
  //   final latitude = coordinates[0] as double;
  //   final longitude = coordinates[1] as double;
  //   return [latitude, longitude];
  // }
  Future<ActivityTemplate?> getActivityById(String? activityId) async {
    try {
      final activityData = await handelactivitytmp.fetchData(activityId!);
      return activityData;
    } catch (e) {
      // Handle errors, e.g., show an error message or return null
      print("Error fetching Activity: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildScaffold();
  }

  Scaffold buildScaffold() {
    if (widget.item is Tasks) {
      // UI for Tasks
      return Scaffold(
        appBar: AppBar(
          title: Text('Item Task'),
        ),
        body: ListView(
            // Your content for Tasks
            ),
      );
    } else if (widget.item is Activity) {
      // UI for Activity
      return Scaffold(
        appBar: AppBar(
          title: Text('Item Activity'),
          actions: [
            IconButton(
              icon: Icon(
                Icons.map,
              ),
              onPressed: () async {
                if (activityTemplate != null &&
                    activityTemplate?.coordinates != null) {
                  final coordinates = activityTemplate?.coordinates!;
                  final binaryCoordinates = jsonEncode(coordinates);
                  final parsedCoordinates = parseCoordinates(binaryCoordinates);
                  double latitude = parsedCoordinates[0];
                  double longitude = parsedCoordinates[1];
                  final placeQuery = '$latitude $longitude';
                  final c = Colors.blue;
                  // getLocationZone(latitude, longitude);
                  openMapApp(
                    latitude!,
                    longitude!,
                    placeQuery: placeQuery,
                    trackLocation: true,
                    color: c,
                    markerImage: const AssetImage('assets/Male.png'),
                    map_action: true,
                  );

                  print("binaryCoordinates $binaryCoordinates");
                  print("latitude $latitude");
                  print("longitude $longitude");
                  await fetchWeather(latitude, longitude);
                }
              },
            ),
          ],
        ),
        body: ListView(
          children: <Widget>[
            SizedBox(
              height: 7,
            ),
            if (widget.item is Tasks) ...{
              // UI for Tasks
              // Create text fields, buttons, and logic for editing, adding, and deleting tasks
              // Use descriptionController and selectedDate for input fields
            } else if (widget.item is Activity) ...{
              FutureBuilder(
                future: fetchDataAndFetchWeather,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Column(
                      children: <Widget>[
                        // ImageWithDynamicBackgroundColor(
                        //   imageUrl: '${baseUrls}${activityTemplate?.picture}',
                        //   isCirculair: true,
                        // ),
                        // ImageWithDynamicBackgroundColor(
                        //     imageUrl:
                        //         'https://cdn.pixabay.com/photo/2018/01/31/07/36/secret-3120483_1280.jpg',
                        //     isCirculair: true),
                        // ImageWithDynamicBackgroundColor(
                        //   imageUrl:
                        //       'https://media.istockphoto.com/id/502735520/photo/fairy-tree-in-mystic-forest.jpg?s=2048x2048&w=is&k=20&c=8aO5pRxIWv4AFjj9tJ9mE8Railn0IcBp96RG_Sbzbn0=',
                        //   isCirculair: false,
                        // ),

                        ListTile(
                          title: Text(
                              'Currency: ${widget.item.currency ?? 'N/A'}'),
                        ),
                        ListTile(
                          title: Text(
                              'Departure Note: ${widget.item.departureNote ?? 'N/A'}'),
                        ),
                        ListTile(
                          title: Text(
                              'Return Note: ${widget.item.returnNote ?? 'N/A'}'),
                        ),
                        // Add more details as needed
                        Divider(
                          color: Theme.of(context).focusColor,
                          height: 2,
                          thickness: 2,
                        ),
                        ListTile(
                          title: Text(
                              'activityTemplate Note:  ${activityTemplate?.coordinates ?? 'n/A'}'),
                        ),
                        ListTile(
                          title: Text(
                              'activityTemplate Note:  ${activityTemplate?.images ?? 'n/A'}'),
                        ),
                        ListTile(
                          title: Text(
                              'Return Note: ${activityTemplate?.picture ?? 'N/A'}'),
                        ),
                        ListTile(
                          title: Text(
                              'Weather : ${weatherData?.weatherCondition}'),
                        ),
                        ListTile(
                          title: Text('speed : ${weatherData?.speed ?? "na"}'),
                        ),
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: FittedBox(
                            child: SfRadialGauge(
                                axes: <RadialAxis>[
                                  RadialAxis(
                                      minimum: 0,
                                      maximum: 70,
                                      annotations: <GaugeAnnotation>[
                                        GaugeAnnotation(
                                            widget: Container(
                                                child: Text(
                                                    '${weatherData?.speed ?? 0}',
                                                    style: TextStyle(
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.bold))),
                                            angle: 90,
                                            positionFactor: 0.5)
                                      ],
                                      pointers: <GaugePointer>[
                                        RangePointer(
                                            value: weatherData?.speed ?? 0,
                                            width: 20,
                                            enableAnimation: true,
                                            color: Color.fromARGB(
                                                255, 5, 56, 196)),
                                        MarkerPointer(
                                            value: weatherData?.speed ?? 0,
                                            markerType: MarkerType.image,
                                            markerHeight: 30,
                                            markerWidth: 30,
                                            imageUrl: 'assets/wind-solid.svg'),
                                        NeedlePointer(
                                            knobStyle: KnobStyle(
                                                knobRadius: 10,
                                                sizeUnit:
                                                    GaugeSizeUnit.logicalPixel,
                                                color: Colors.red),
                                            enableAnimation: true,
                                            needleStartWidth: 1,
                                            needleEndWidth: 5,
                                            value: weatherData?.speed ?? 0)
                                      ],
                                      ranges: <GaugeRange>[
                                        GaugeRange(
                                            startValue: 0,
                                            endValue: 20,
                                            color: Colors.green,
                                            startWidth: 10,
                                            endWidth: 10),
                                        GaugeRange(
                                            startValue: 20,
                                            endValue: 50,
                                            color: Colors.orange,
                                            startWidth: 10,
                                            endWidth: 10),
                                        GaugeRange(
                                            startValue: 50,
                                            endValue: 70,
                                            color: Colors.red,
                                            startWidth: 10,
                                            endWidth: 10)
                                      ])
                                ],
                                title: GaugeTitle(
                                    text: 'wind speed',
                                    textStyle: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold))),
                          ),
                        )
                        //  HtmlWidget(
                        //      activityTemplate?.longDescription ??
                        //        "longDescription",
                        //  ),
                      ],
                    );
                    // Build your scaffold with the data you've fetched
                  }
                  // else if (snapshot.connectionState == ConnectionState.waiting) {
                  //    LoadingScreen(
                  //     loadingText: "Loading Activity.😊.😊.",
                  //     cursor: "_❤",
                  //   );
                  // }
                  else {
                    return LoadingScreen(
                      loadingText: "Loading Activity.😊.😊.",
                      cursor: "_❤_",
                    ); // You can display a loading indicator while waiting for the data.
                  }
                },
              )

              // UI for Activity
              // Create text fields, buttons, and logic for editing, adding, and deleting activities
              // Use descriptionController and selectedDate for input fields
            } else if (widget.item is Transport) ...{
              // UI for Transport
              // Create text fields, buttons, and logic for editing, adding, and deleting transports
              // Use descriptionController and selectedDate for input fields
            },
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          // color: Colors.blue, // Customize the color as needed
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  // Handle adding an item

                  // Show a dialog or navigate to a screen for adding
                },
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  if (widget.item is Activity) {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) =>
                    //         // EditActivityScreen(item: widget.item as Activity),
                    //   ),
                    // );
                  } else if (widget.item is Tasks) {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => EditTaskScreen(item: widget.item as Tasks),
                    //   ),
                    // );
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  // Handle deleting the item
                  // Show a confirmation dialog or perform the deletion
                },
              ),
            ],
          ),
        ),
      );
    } else if (widget.item is Transport) {
      // UI for Transport
      return Scaffold(
        appBar: AppBar(
          title: Text('Item Transport'),
        ),
        body: ListView(
            // Your content for Transport
            ),
      );
    } else {
      // Handle the case when the item type is unknown
      return Scaffold(
        appBar: AppBar(
          title: Text('Item Details'),
        ),
        body: Center(
          child: Text('Unknown item type: ${widget.item.runtimeType}'),
        ),
      );
    }
  }
}
