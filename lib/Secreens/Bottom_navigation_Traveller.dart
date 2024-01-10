import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:SunShine/HTTPHandlerObject.dart';
import 'package:SunShine/Secreens/Profile/traveller_Profil.dart';
import 'package:SunShine/modele/httpTravellerbyid.dart';
import 'package:SunShine/modele/traveller/TravellerModel.dart';
import 'package:SunShine/traveller_Screens/Notifications.dart';
import 'package:SunShine/traveller_Screens/call_Guide.dart';
import 'package:SunShine/traveller_Screens/transfers_ByVoyMail.dart';

class BottomNavBarDemo extends StatefulWidget {
  String? group;
  Traveller? traveller;

  BottomNavBarDemo({Key? key, this.group, this.traveller}) : super(key: key);

  @override
  _BottomNavBarDemoState createState() => _BottomNavBarDemoState();
}

class _BottomNavBarDemoState extends State<BottomNavBarDemo> {
  late Traveller traveller;
  final Travelleruserid = HTTPHandlerTravellerbyId();
  HTTPHandler<Traveller> handler = HTTPHandler<Traveller>();
  String? travellergroupId = "";
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  final List<String> _pageTitles = [
    'Calendar',
    'Notification',
    'Your Guide',
    'Profile',
  ];
  final storage = const FlutterSecureStorage();
  int selectedIndex = 0;
  double activityProgress = 0.0;

  @override
  void initState() {
    super.initState();
    // Initialize 'traveller' here using the value passed from the widget
    traveller = widget.traveller!;
  }

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
        // centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // const Icon(
            //   Icons.arrow_back,
            //   color: Color(0xFFEB5F52),
            // ),
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
          TravellerCalendarPage(
            group: traveller.touristGroupId,
            traveller: traveller, // Pass the traveller object here
          ),
          NotificationScreen(groupsid: travellergroupId),
          TouristGuideProfilePage(
            traveller: widget.traveller, // Pass the Traveller object here
          ),
          const MainProfile(),
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
            label: 'Your Guide',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Home Screen'),
    );
  }
}
