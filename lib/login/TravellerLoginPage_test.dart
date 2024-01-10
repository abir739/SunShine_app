import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/svg.dart';
import 'package:SunShine/login/Login.dart';
import 'package:SunShine/traveller_Screens/transfers_ByCode.dart';
import '../services/constent.dart';
import '../modele/traveller/TravellerModel.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:get/get.dart';

class TravellerLoginPage extends StatefulWidget {
  final Key? key;

  const TravellerLoginPage({this.key}) : super(key: key);

  @override
  _TravellerLoginPageState createState() => _TravellerLoginPageState();
}

class _TravellerLoginPageState extends State<TravellerLoginPage> {
  final TextEditingController codeController = TextEditingController();
  List<Traveller> travellers = [];
  String errorMessage = '';
  bool loading = false;
  Future<void> fetchTravellersByCode(String code) async {
    final url =
        Uri.parse('$baseUrls/api/travellers-mobile?filters[code]=$code');

    try {
      setState(() {
        loading = true;
      });
      final response = await http.get(
        url,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List r = responseData["results"];
        final List<Traveller> fetchedTravellers =
            r.map((data) => Traveller.fromJson(data)).toList();
        print(responseData["inlineCount"]);
        setState(() {
          travellers = fetchedTravellers;
          errorMessage = ''; // Clear error message if successful
          loading = false;
        });
        if (responseData["inlineCount"] == 0) {
          Get.snackbar('Warning', " Check Your Code...",
              backgroundGradient: const LinearGradient(
                colors: [Color(0xff979090), Color(0x31858489)],
              ),
              colorText: Colors.white,
              backgroundColor: const Color.fromARGB(255, 185, 4, 4));
          setState(() {
            loading = false;
          });
        }
      } else {
        Get.snackbar('Warning', " Check Your Code...",
            backgroundGradient: const LinearGradient(
              colors: [Color(0xff979090), Color(0x31858489)],
            ),
            colorText: Colors.white,
            backgroundColor: const Color.fromARGB(255, 185, 4, 4));

        setState(() {
          loading = false;
        });
      }
    } catch (error) {
      Get.snackbar('Warning', " Check Your connaction...",
          backgroundGradient: const LinearGradient(
            colors: [Color(0xff979090), Color(0x31858489)],
          ),
          colorText: Colors.white,
          backgroundColor: const Color.fromARGB(255, 185, 4, 4));

      setState(() {
        loading = false;
      });
    }
  }

  void _navigateToCalendarPage(Traveller selectedTraveller) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CalendarPage(selectedTraveller: selectedTraveller),
      ),
    );
  }

  void _handleSearchButton() {
    String code = codeController.text;
    if (code.isNotEmpty) {
      fetchTravellersByCode(code);
    } else {
      // Show the AlertDialog for empty code
      _showInvalidCodeDialog();
    }
  }

  void _showInvalidCodeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Invalid Code'),
          content: const Text(
              'Please verify the code or enter another correct code.'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Added image and text
            Column(
              children: [
                const SizedBox(height: 67.0), // Add space here
                SvgPicture.asset(
                  'assets/images/Group_Logo.svg',
                  height: 100.0,
                  width: 100.0,
                ),
                const SizedBox(height: 24),
                const Text(
                  "Enter Traveller Code",
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25.0),
            TextField(
              controller: codeController,
              decoration: const InputDecoration(labelText: 'Code: '),
            ),
            const SizedBox(height: 30),
            loading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _handleSearchButton, // Add this line
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFFEB5F52),
                      fixedSize: const Size(321, 43),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Search',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
            const SizedBox(height: 8),
            // if (errorMessage.isNotEmpty)
            //   Text(
            //     errorMessage,
            //     style: const TextStyle(color: Colors.red),
            //   ),
            if (travellers.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: travellers.length,
                  itemBuilder: (ctx, index) {
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(travellers[index].title ?? ''),
                        subtitle: Text(
                          ' ${travellers[index].user?.email ?? ''}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        onTap: () {
                          _navigateToCalendarPage(travellers[index]);
                          try {
                            OneSignal.shared.setAppId(
                                'ce7f9114-b051-4672-a9c5-0eec08d625e8');
                            OneSignal.shared.setSubscriptionObserver(
                                (OSSubscriptionStateChanges changes) {
                              print(
                                  "SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");
                            });
                            OneSignal.shared
                                .promptUserForPushNotificationPermission();
                            OneSignal.shared.sendTags({
                              'Groupids': '${travellers[index].touristGroupId}'
                            }).then((success) {
                              print("Tags created successfully");
                              Navigator.of(context).pop();
                              _navigateToCalendarPage(travellers[index]);
                              setState(() {
                                // Set loading state to true
                              });
                            }).catchError((error) {
                              print("Error creating tags: $error");
                            });
                          } catch (e) {
                            print('Error initializing OneSignal: $e');
                          }
                        },
                      ),
                    );
                  },
                ),
              ),

            // const SizedBox(height: 20.0),
            const Row(
              children: [
                Expanded(
                  child: Divider(),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text('OR'),
                ),
                Expanded(
                  child: Divider(),
                ),
              ],
            ),
            const SizedBox(height: 5.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const MyLogin(), // Replace MyLoginPage with the actual page you want to navigate to
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFFEB5F52),
                fixedSize: const Size(321, 43),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Login with mail',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
