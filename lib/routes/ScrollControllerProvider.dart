import 'package:flutter/cupertino.dart';

class ScrollControllerProvider extends ChangeNotifier {
  ScrollController _controller = ScrollController();
  bool _closeTopContainer = true;
  bool hideitem = false;
  ScrollController get controller => _controller;
  bool get closeTopContainer => _closeTopContainer;
  ScrollControllerProvider() {
    _controller.addListener(_handleScroll);
  }
 

  void _handleScroll() {
    controller.position.isScrollingNotifier.addListener(() {
      if (!controller.position.isScrollingNotifier.value) {
        // Scroll has stopped
        // Perform actions you want when scrolling stops
        // For example, you can set closeTopContainer to false
        _closeTopContainer = true;
      } 
      // else if (controller.offset == 0) {
      //   print("${controller.offset} controller ==0");
      //   // Scroll has stopped
      //   // Perform actions you want when scrolling stops
      //   // For example, you can set closeTopContainer to false
      //   _closeTopContainer = true;
      // } 
      // else if (controller.position.hasListeners) {
      //   print("${controller.offset} controller >0");
      //   // Scroll has stopped
      //   // Perform actions you want when scrolling stops
      //   // For example, you can set closeTopContainer to false
      //   _closeTopContainer = false;
      // }
        if (controller.offset >= controller.position.maxScrollExtent &&
          !controller.position.outOfRange) {
        print("${controller.offset} maxScrollExtent ");
        _closeTopContainer = false;
      } else {
        // Scroll is in progress
        // Perform actions you want during scrolling
        // For example, you can set closeTopContainer to true
        _closeTopContainer = false;
      }
      // Notify listeners to update the UI
      notifyListeners();
    });
  }
}
