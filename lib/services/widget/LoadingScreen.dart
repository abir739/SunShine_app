import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class LoadingScreen extends StatelessWidget {
  String? loadingText;
  String? cursor;

  LoadingScreen({this.loadingText, this.cursor});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  '${loadingText ?? 'laoding..'}',
                  cursor: '${cursor?? '*'}',
                  textStyle: const TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.normal,
                  ),
                  speed: const Duration(milliseconds: 200),
                ),
              ],
              totalRepeatCount: 4,
              pause: const Duration(milliseconds: 1000),
              displayFullTextOnTap: true,
              stopPauseOnTap: true,
            ),
            const SizedBox(height: 50),
            Container(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                strokeWidth: 20,
                backgroundColor: Color.fromARGB(255, 219, 10, 10),
                valueColor: new AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(207, 248, 135, 6)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
