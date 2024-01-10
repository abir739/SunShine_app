import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:SunShine/login/Login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: IntroScreen(),
    );
  }
}

class IntroScreen extends StatelessWidget {
  final pages = [
    PageViewModel(
      pageColor: Color.fromARGB(255, 251, 253, 253),
      body: const Text(
        'Let Zenify guide you towards extraordinary adventures, where every journey becomes a calming and enriching experience.',
        style: TextStyle(
          fontSize: 15.0,
          color: Color.fromARGB(255, 102, 101, 101),
        ),
      ),
      title: const Text(
        'Discover the world in complete\n serenity with Zenify.',
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 7, 7, 7),
        ),
      ),
      mainImage: SvgPicture.asset(
        'assets/images/Group_Scr1.svg', // Add your image asset
        width: 800.0,
        height: 500.0,
        alignment: Alignment.center,
      ),
    ),
    PageViewModel(
      pageColor: Color.fromARGB(255, 251, 253, 253),
      body: const Text(
        'Let us help you create unforgettable and cherished moments, one incredible journey at a time with Zenify',
        style: TextStyle(
          fontSize: 15.0,
          color: Color.fromARGB(255, 102, 101, 101),
        ),
      ),
      title: const Text(
        'Create cherished memories that\n last a lifetime.',
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 7, 7, 7),
        ),
      ),
      mainImage: SvgPicture.asset(
        'assets/images/screen2.svg', // Add your image asset
        width: 800.0,
        height: 500.0,
        alignment: Alignment.center,
      ),
    ),
    PageViewModel(
      pageColor: Color.fromARGB(255, 251, 253, 253),
      body: const Text(
        'Let Zenify transform your dreams into a beautiful reality, guiding you at every step of your incredible journey.',
        style: TextStyle(
          fontSize: 15.0,
          color: Color.fromARGB(255, 102, 101, 101),
        ),
      ),
      title: const Text(
        'Embark on planning your dream\n trip with Zenify.',
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 7, 7, 7),
        ),
      ),
      mainImage: SvgPicture.asset(
        'assets/images/screen3.svg', // Add your image asset
        width: 800.0,
        height: 500.0,
        alignment: Alignment.center,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => IntroViewsFlutter(
          pages,
          showSkipButton: true,
          onTapDoneButton: () {
            // Redirect to the main screen after the introduction.
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MyLogin()),
            );
          },
        ),
      ),
    );
  }
}
