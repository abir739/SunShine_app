import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:SunShine/Secreens/Notification/Notifications_List_Guide.dart';
import 'package:SunShine/Secreens/TravelerProvider.dart';
import 'package:SunShine/Secreens/Welcome_Page.dart';
import 'package:SunShine/Settings/AppSettings.dart';
import 'package:SunShine/guide_Screens/GuidCalander.dart';
import 'package:SunShine/guide_Screens/Guide_First_Page.dart';
import 'package:SunShine/login/Login.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:SunShine/routes/ScrollControllerProvider.dart';
import 'package:SunShine/routes/SettingsProvider.dart';
import 'package:SunShine/services/GuideProvider.dart';
// import 'package:timezone/data/latest.dart' as tzdata;
import 'package:SunShine/traveller_Screens/Traveller-First-Screen.dart';
import 'Controller/dependency_injection.dart';
import 'Secreens/Notification/NotificationCountNotifierProvider.dart';

import 'Secreens/Notifications/NotificationDetails.dart';
import 'Secreens/TouristGroupProvider.dart';
import 'services/constent.dart';
import 'onesignal_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // OneSignalHandler.initialize(context);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotificationCountNotifier()),
        ChangeNotifierProvider(create: (_) => TouristGroupProvider()),
        ChangeNotifierProvider(create: (_) => TravelerProvider()),
        ChangeNotifierProvider(create: (_) => guidProvider()),
        ChangeNotifierProvider(create: (_) => TravelerProvider()),
        ChangeNotifierProvider(create: (_) => ScrollControllerProvider()),
        ChangeNotifierProvider(create: (_) => guidProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => AppSettingsLoader()),
        // ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: MyApp(),
    ),
  );
  DependencyInjection.init();
  // tzdata.initializeTimeZones();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    OneSignalHandler.initialize(context);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        'register': (context) => IntroScreen(),
        'login': (context) => const MyLogin(),
        'notificationScreen': (context) => NotificationScreen(
              groupsid: '',
            ),
        // 'planning': (context) => const PlaningSecreen(), // Add this route
        'Traveller': (context) => const TravellerFirstScreen(
              userList: [],
            ),
        'SplashScreen': (context) => SplashScreen(), // Add this route
        'planning': (context) => const PlaningSecreen(),
        'CalanderGuide': (context) => GuidCalanderSecreen(),
        'notification': (context) {
          final args =
              Get.arguments; // Get the arguments passed when navigating
          final id = args != null
              ? args['id'] as String
              : null; // Extract the 'id' argument
          final routname = args != null
              ? args['routename'] as String
              : null; // Extract the 'id' argument
          print("ID from route: $id"); // Print the 'id'
          print(" routename: $routname"); // Print the 'id'
          return ActivityDetailScreen(id: id);
        } // Add this routeActivityDetailScreen
      },
      initialRoute: 'SplashScreen',
    );
  }

  Future<String?> _getToken() async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    return await storage.read(key: "access_token");
  }

  Future<String?> _getRole() async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    return await storage.read(key: "Role");
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getInitialRoute(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                backgroundColor: Color.fromARGB(255, 219, 10, 10),
                valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 24, 10, 221)),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          String initialRoute = snapshot.data!;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed(initialRoute);
          });
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                backgroundColor: Color(0xFFEB5F52),
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color(0xFF3A3557),
                ),
              ),
            ),
          ); // Return an empty Scaffold while navigating
        }
      },
    );
  }

  Future<String> _getInitialRoute() async {
    Future<String?> _getToken() async {
      FlutterSecureStorage storage = const FlutterSecureStorage();
      return await storage.read(key: "access_token");
    }

    Future<String?> _getRole() async {
      FlutterSecureStorage storage = const FlutterSecureStorage();
      return await storage.read(key: "Role");
    }

    final bool tokenIsValid =
        await _validateToken(); // Replace with your validation logic
    String? role = await _getRole();
    print("$role Role");
    if ((tokenIsValid && (role == "Administrator" || role == "TouristGuide"))) {
      return 'register';
    } else if (role == "Traveller" && tokenIsValid) {
      return 'Traveller';
    } else {
      return 'register';
    }
  }

  Future<bool> _validateToken() async {
    // Replace this with your token validation logic
    FlutterSecureStorage storage = const FlutterSecureStorage();
    String? token = await storage.read(key: "access_token");

    // Call your API to refresh the token
    String? refreshedToken = await _refreshToken(token);

    if (refreshedToken != null) {
      // Update the stored token
      await storage.write(key: "access_token", value: refreshedToken);
      return true;
    } else {
      return false;
    }
  }

  Future<String?> _refreshToken(String? token) async {
    final refreshTokenUrl = Uri.parse('${baseUrls}/api/auth/refresh-token');
    print("$token token");
    try {
      // Create the request headers and payload
      final headers = {'Content-Type': 'application/json'};
      final payload = jsonEncode({'refreshToken': token});

      // Make the HTTP POST request to refresh the token
      final response =
          await http.post(refreshTokenUrl, headers: headers, body: payload);

      // Check the response status
      if (response.statusCode == 201) {
        // Token refresh successful, extract the new token from the response
        final responseBody = jsonDecode(response.body);

        final newToken = responseBody['accessToken'] as String;
        print("$newToken newToken");
        return newToken;
      } else {
        // Token refresh failed, return null
        return null;
      }
    } catch (error) {
      // Handle any errors that occur during the request
      print('Error refreshing token: $error');
      return null;
    }
  }
}
