import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zenify_app/Secreens/Activities-Category/Categories-Icons.dart';
// import 'package:zenify_app/Secreens/Notification/notificationlist_Guide.dart';
import 'package:zenify_app/Secreens/Notification/notificationlist_O.dart';
import 'package:zenify_app/Secreens/Profile/User_Profil.dart';
import 'package:zenify_app/guide_Screens/Events.dart';
import 'package:zenify_app/guide_Screens/GuidCalander.dart';
import 'package:zenify_app/guide_Screens/travellers_list_screen.dart';
import 'package:zenify_app/modele/TouristGuide.dart';
import 'package:zenify_app/routes/ScrollControllerProvider.dart';
// import 'package:zenify_app/guide_Screens/GuidCalander.dart';

class BottomNavBarDemo extends StatefulWidget {
  TouristGuide? guid;

  BottomNavBarDemo(this.guid, {Key? key}) : super(key: key);

  @override
  _BottomNavBarDemoState createState() => _BottomNavBarDemoState();
}

class _BottomNavBarDemoState extends State<BottomNavBarDemo> {
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 100.0),
            Text(
              _pageTitles[_currentIndex],
              style: const TextStyle(color: Colors.black, fontSize: 22),
            ),
          ],
        ),
        elevation: 0, // Remove appbar shadow
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
    // }
    //   return Scaffold(
    //     appBar: AppBar(
    //       backgroundColor: Colors.white,
    //       // centerTitle: true,
    //       title: Row(
    //         mainAxisAlignment: MainAxisAlignment.start,
    //         // crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //           // const Icon(
    //           //   Icons.arrow_back,
    //           //   color: Color(0xFFEB5F52),
    //           // ),
    //           const SizedBox(width: 100.0),
    //           Text(
    //             _pageTitles[_currentIndex],
    //             style: const TextStyle(color: Colors.black, fontSize: 22),
    //           ),
    //         ],
    //       ),
    //       elevation: 0, // Remove appbar shadow
    //     ),
    //     body: PageView(
    //       controller: _pageController,
    //       onPageChanged: _onPageChanged,
    //       children: <Widget>[
    //         // TaskListPage(guideId: widget.guid!.id),
    //         EventCalendar(guideId: widget.guid!.id),
    //         NotificationScreen(groupsid: travellergroupId, guid: widget.guid),
    //         TravellersListScreen(guideId: widget.guid!.id),
    //         const MainProfile(),
    //         GuidCalanderSecreen(),
    //       ],
    //     ),
    //  );
  }
}
