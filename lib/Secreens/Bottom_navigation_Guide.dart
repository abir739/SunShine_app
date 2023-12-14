import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zenify_app/Secreens/Activities-Category/Categories-Icons.dart';
import 'package:zenify_app/Secreens/Notification/notificationlist_O.dart';
import 'package:zenify_app/Secreens/Profile/User_Profil.dart';
import 'package:zenify_app/guide_Screens/GuidCalander.dart';
import 'package:zenify_app/guide_Screens/travellers_list_screen.dart';
import 'package:zenify_app/modele/TouristGuide.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';






class BottomNavBarDemo extends StatefulWidget {
  TouristGuide? guid;

  BottomNavBarDemo(this.guid, {Key? key}) : super(key: key);

  @override
  _BottomNavBarDemoState createState() => _BottomNavBarDemoState();
}

class _BottomNavBarDemoState extends State<BottomNavBarDemo> {

   final Connectivity _connectivity = Connectivity();
   StreamSubscription? streamSubscription;
  String? travellergroupId = "";
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  final List<String> _pageTitles = [
    'Home',
    'Notification',
    'Groups',
    'Profile',
    'Calendar',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
       streamSubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
 
  }
void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      Get.rawSnackbar(
          messageText: const Text('PLEASE CONNECT TO THE INTERNET',
              style: TextStyle(color: Colors.white, fontSize: 14)),
          isDismissible: false,
          duration: const Duration(minutes: 2),
          backgroundColor: Color.fromARGB(255, 94, 83, 83)!,
          icon: const Icon(
            Icons.wifi_off,
            color: Colors.white,
            size: 35,
          ),
          margin: EdgeInsets.zero,
          snackStyle: SnackStyle.GROUNDED);
    } else {
      if (Get.isSnackbarOpen) {
        
      }
     
       streamSubscription!.cancel();
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onItemTapped(int index) {
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _pageTitles[_currentIndex],
              style: const TextStyle(color: Colors.black, fontSize: 22),
            ),
          ],
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications,
              size: 26,
            ), 
            onPressed: () {
              // Navigate to the notification page when the icon is pressed
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationScreen(
                      groupsid: travellergroupId, guid: widget.guid),
                ),
              );
            },
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: <Widget>[
          //EventCalendar(guideId: widget.guid!.id),
          ActivityCategoryPage(),
          NotificationScreen(groupsid: travellergroupId, guid: widget.guid),
          TravellersListScreen(guideId: widget.guid!.id),
          const MainProfile(),
          GuidCalanderSecreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFFEB5F52),
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Groups',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.calendarCheck),
            label: 'Calander',
          ),
        ],
      ),
    );
    
  }
}
