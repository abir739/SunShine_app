import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:SunShine/login/Login.dart';
import 'package:SunShine/modele/httpTravellerbyid.dart';
import 'package:SunShine/modele/traveller/TravellerModel.dart';

class TravelerProvider with ChangeNotifier {
  int notificationCount = 0;
  String userId = '';
  String? _groupid; // Initialize as a Future with a default value
  Traveller? _traveler;
  final HTTPHandlerTravellerbyId Travelleruserid = HTTPHandlerTravellerbyId();
  late SharedPreferences prefs; // Use 'late' for late initialization

  // Setter for groupid
  set groupids(String newName) {
    _groupid = newName;
    notifyListeners();
  }

  Traveller? get traveler => _traveler;
  String? get groupid => _groupid;
  Future<String?> loadTravelerData() async {
    try {
      // Replace this logic with your data fetching code
      userId = await storage.read(key: "id") ?? "";
      print("userid from provider $userId");
      final travelerDetail =
          await Travelleruserid.fetchData("/api/travellers/UserId/$userId");

      _groupid = travelerDetail.touristGroupId ?? "hhh";
      _traveler = travelerDetail;

      // Initialize prefs
      prefs = await SharedPreferences.getInstance();

      notificationCount = prefs.getInt('notificationCount') ?? 0;

      notifyListeners();
      loadTraveler();
    } catch (error) {
      print("ErrorError  traveler data: $error");
      // Handle the error as needed (e.g., show an error message).
    }
    return groupid;
  }

  Future<Traveller?> loadTraveler() async {
    try {
      // Replace this logic with your data fetching code
      userId = await storage.read(key: "id") ?? "";
      print("userid from provider $userId");
      final travelerDetail =
          await Travelleruserid.fetchData("/api/travellers/UserId/$userId");
      final travelerDetails = await Travelleruserid.fetchData(
          "/api/travellers-mobile/${travelerDetail.id}");

      _groupid = travelerDetail.touristGroupId ?? "hhh";
      _traveler = travelerDetails;

      notifyListeners();
    } catch (error) {
      print("ErrorError  traveler data: $error");
      // Handle the error as needed (e.g., show an error message).
    }
    return traveler;
  }
}
