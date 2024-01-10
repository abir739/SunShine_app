import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:SunShine/login/Login.dart';

class IntroScreen extends StatelessWidget {
  final List<PageViewModel> pages = [
    PageViewModel(
      title: "Discover the world in complete serenity with Zenify.",
      body:
          "Let Zenify guide you towards extraordinary adventures, where every journey becomes a calming and enriching experience.",
      image: SvgPicture.asset(
        'assets/images/Group_Scr1.svg',
        width: 800.0,
        height: 700.0,
        alignment: Alignment.center,
      ),
    ),
    PageViewModel(
      title: "Create cherished memories that last a lifetime.",
      body:
          "Let us help you create unforgettable and cherished moments, one incredible journey at a time with Zenify.",
      image: SvgPicture.asset(
        'assets/images/screen2.svg',
        width: 800.0,
        height: 700.0,
        alignment: Alignment.center,
      ),
    ),
    PageViewModel(
      title: "Embark on planning your dream trip with Zenify.",
      body:
          "Let Zenify transform your dreams into a beautiful reality, guiding you at every step of your incredible journey.",
      image: SvgPicture.asset(
        'assets/images/screen3.svg',
        width: 800.0,
        height: 700.0,
        alignment: Alignment.center,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IntroductionScreen(
          pages: pages,
          onDone: () {
            // Redirect to the main screen after the introduction.
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MyLogin()),
            );
          },
          showSkipButton: true,
          skip: const Text(
            'Skip',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFFEB5F52),
            ),
          ),
          done: const Text(
            'Done',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFFEB5F52),
            ),
          ),
          next: const Icon(
            Icons.arrow_forward,
            color: Color(0xFFEB5F52),
          ),
          dotsDecorator: DotsDecorator(
            size: const Size(10.0, 10.0),
            color: Colors.grey,
            activeSize: const Size(28.0, 10.0),
            activeColor: const Color(0xFFEB5F52),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
        ),
      ),
    );
  }
}
