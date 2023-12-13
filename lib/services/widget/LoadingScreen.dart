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
                  // cursor: '${cursor?? '*'}',
                  textStyle: const TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.normal,
                  ),
                  speed: const Duration(milliseconds: 100),
                ),
              ],
              totalRepeatCount: 2,
              pause: const Duration(milliseconds: 300),
              displayFullTextOnTap: true,
              stopPauseOnTap: true,
            ),
            const SizedBox(height: 50),
            Container(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                strokeWidth: 10,
                backgroundColor: Colors.white
                ,
                valueColor: new AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(207, 123, 193, 243)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
