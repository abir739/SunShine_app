import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:SunShine/Secreens/Notification/ImageViewScreen.dart';
import 'package:SunShine/Secreens/Upload_Files/FilePickerUploader.dart';
import 'package:SunShine/login/Login.dart';
import 'package:SunShine/modele/creatorUser.dart';
import 'package:SunShine/services/widget/profile_widget.dart';
import '../../NetworkHandler.dart';
import '../../services/constent.dart';
import '../../modele/HttpUserHandler.dart';
import '../../modele/TouristGuide.dart';
import '../../modele/activitsmodel/usersmodel.dart';
import 'package:http/http.dart' as http;
import '../../modele/planningmainModel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

String? baseUrl = "";

class UserfromNotification extends StatefulWidget {
  CreatorUser? creatorUser;
  UserfromNotification(this.creatorUser, {Key? key}) : super(key: key);

  @override
  _UserfromNotificationState createState() => _UserfromNotificationState();
}

class _UserfromNotificationState extends State<UserfromNotification> {
  FilePickerUploader uploader = FilePickerUploader();
  bool circular = true;
  String token = '';
  final httpUserHandler = HttpUserHandler();
  List<User>? users;
  User? selectedUser = User();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  FlutterSecureStorage storage = const FlutterSecureStorage();
  get selectedPlanning => PlanningMainModel();
  final RefreshController _refreshController = RefreshController();
  TouristGuide? get selectedTouristGuide => TouristGuide();
  ScrollController controller = ScrollController();
  bool closeTopContainer = true;
  User? user;
  String? userId;
  @override
  void initState() {
    super.initState();
    _loadUser();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.addListener(() {
        print('scrolling');
        setState(() {
          closeTopContainer = true;
        });
      });
      controller.position.isScrollingNotifier.addListener(() {
        if (!controller.position.isScrollingNotifier.value) {
          print('scroll is stopped');
          setState(() {
            closeTopContainer = false;
          });
        }
        if (controller.offset >= controller.position.maxScrollExtent &&
            !controller.position.outOfRange) {
          // You've reached the bottom
          setState(() {
            debugPrint("Reached the bottom");
            closeTopContainer = true;
          });
        } else {
          print('scroll is started');
          setState(() {
            closeTopContainer = false;
          });
        }
      });
    });
  }

  Future<void> _onRefresh() async {
    _loadUser();

    _refreshController.refreshCompleted();
  }

  Future<void> logout() async {
    await storage.deleteAll();

    Get.offNamed('login');
  }

  void _loadUser() async {
    token = (await storage.read(key: "access_token"))!;
    baseUrl = await storage.read(key: "baseurl");
    setState(() {
      users = []; // initialize the list to an empty list
    });
    print("token, $token");
    userId = await storage.read(key: "id");
    try {
      user = await httpUserHandler
          .fetchUser('/api/users/${widget.creatorUser?.id}');

      setState(() {
        selectedUser = user;
        circular = false;
      });
      if (user?.email == null) {}
    } catch (error) {
      print('Error loading user: $error');
    }
  }

  void updateUserDetail(String field, String updatedValue) async {
    final String? userId =
        await storage.read(key: "id"); // Replace with the actual user ID
    final String? baseUrl = await storage.read(key: "baseurl");
    final String apiUrl = '$baseUrls/api/users/$userId';
    final String? token = await storage.read(key: "access_token");

    try {
      final response = await http.patch(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {field: updatedValue},
      );

      if (response.statusCode == 200) {
        print('$field updated successfully');
        setState(() {
          switch (field) {
            case 'email':
              selectedUser?.email = updatedValue;
              break;
            case 'LastName':
              selectedUser?.lastName = updatedValue;
              break;
            case 'gender':
              selectedUser?.gender = updatedValue;
              break;
            case 'address':
              selectedUser?.address = updatedValue;
              break;
            case 'phone':
              selectedUser?.phone = updatedValue;
              break;
            case 'lastName':
              selectedUser?.lastName = updatedValue;
              break;
            case 'zipCode':
              selectedUser?.zipCode = updatedValue;
              break;
            case 'birthDate ':
              selectedUser?.birthDate = DateTime.parse(updatedValue);
              break;
            case 'password ':
              selectedUser?.password = updatedValue;
              break;
            // Add more cases for other fields as needed
          }
        });
      } else {
        print('Failed to update $field');
        print('Token: $token');
        print('User ID: $userId');
        print('Base URL: $baseUrls');
        print('API URL: $apiUrl');
      }
    } catch (error) {
      print('Error occurred while updating $field: $error');
    }
  }

  void handleDetailUpdate(String field, String updatedValue) {
    // Update the screen detail based on the field and updated value
    setState(() {
      if (field == 'gender') {
        selectedUser?.gender = updatedValue;
      } else if (field == 'phone') {
        selectedUser?.phone = updatedValue;
      } else if (field == 'email') {
        selectedUser?.email = updatedValue;
      } else if (field == 'password') {
        selectedUser?.password = updatedValue;
      }
      // Add more conditions for other fields if needed
    });
  }

  @override
  Widget build(BuildContext context) {
    double widthC = MediaQuery.of(context).size.width * 100;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 254, 253, 254),
      body: SingleChildScrollView(
        // controller:controller ,
        child: Column(
          children: <Widget>[
            Visibility(visible: closeTopContainer, child: _buildHeader()),
            _buildMainInfo(context, widthC),
            const SizedBox(height: 10.0),
            _buildInfo(context, widthC),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return user?.picture == null
        ? ProfileWidget(
            imagePath:
                'https://4kwallpapers.com/images/walls/thumbs_2t/2167.jpg',
            onClicked: () async {
              Get.to(ImageViewScreen(
                "${baseUrls}/assets/uploads/traveller/${user?.picture}",
              ));
            },
          )
        : Column(children: [
            SizedBox(height: Get.height * 0.05),
            ProfileWidget(
              imagePath:
                  '${baseUrls}/assets/uploads/traveller/${user?.picture}',
              onClicked: () async {
                Get.to(ImageViewScreen(
                  "${baseUrls}/assets/uploads/traveller/${user?.picture}",
                ));
              },
            ),
          ]);
  }

  Widget _buildMainInfo(BuildContext context, double width) {
    return Container(
      width: width,
      margin: const EdgeInsets.all(10),
      alignment: AlignmentDirectional.center,
      child: Column(
        children: <Widget>[
          Text(
            '${selectedUser?.firstName ?? "Loding data"} ${selectedUser?.lastName ?? "..."}',
            style: const TextStyle(
              fontSize: 20,
              color: Color.fromARGB(255, 94, 36, 228),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            selectedUser?.username ??
                'Loding ... Username', // Fallback value if null
            style: const TextStyle(
              color: Color.fromARGB(255, 10, 10, 10),
              fontStyle: FontStyle.italic,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfo(BuildContext context, double width) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Card(
        shape: RoundedRectangleBorder(
          side: const BorderSide(
              color: Colors.black,
              width: 1.0), // Set the border color and width
          borderRadius:
              BorderRadius.circular(10.0), // Set border radius as needed
        ),
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () async {
                  final email = Uri(
                    scheme: 'mailto',
                    path: '${selectedUser?.email ?? ""}',
                    query:
                        'subject=To ${selectedUser?.username ?? ""}&body=Zenify trip',
                  );
                  if (await canLaunchUrl(email)) {
                    launchUrl(email);
                  } else {
                    throw 'Could not launch $email';
                  }
                },
                child: ListTile(
                  leading: const Icon(
                    Icons.email,
                    color: Color(0xFFEB5F52),
                  ),
                  title: const Text("E-Mail"),
                  subtitle: Text(selectedUser?.email ?? 'N/A'),
                ),
              ),
              const Divider(),
              GestureDetector(
                onTap: () async {
                  final call =
                      Uri.parse('tel: ${selectedUser?.phone ?? 'N/A'}');
                  if (await canLaunchUrl(call)) {
                    launchUrl(call);
                  } else {
                    throw 'Could not launch $call';
                  }
                },
                child: ListTile(
                  leading: const Icon(
                    Icons.phone,
                    color: Color(0xFFEB5F52),
                  ),
                  title: const Text("Phone Number"),
                  subtitle: Text(selectedUser?.phone ?? 'N/A'),
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(
                  Icons.cake,
                  color: Color(0xFFEB5F52),
                ),
                title: const Text("Birth Date"),
                subtitle: Text(
                  selectedUser?.birthDate?.toString() ?? 'N/A',
                ),
              ),
              const Divider(),
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                leading: const Icon(
                  Icons.my_location,
                  color: Color(0xFFEB5F52),
                ),
                title: const Text("Location"),
                subtitle: Text(selectedUser?.address ?? 'N/A'),
              ),
              // const SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: () {
              //     showPasswordUpdateDialog(context); // Pass the context
              //   },
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor:
              //         const Color(0xFFEB5F52), // Set the background color
              //   ),
              //   child: const Text(
              //     'Change Password',
              //     style: TextStyle(
              //       color: Colors.white, // Set the text color
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 20),
              // const Divider(),
              // ListTile(
              //   title: const Text(
              //     'Logout',
              //     style: const TextStyle(
              //       fontSize: 18,
              //       color: Color.fromARGB(255, 94, 36, 228),
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              //   trailing: const Icon(
              //     Icons.logout,
              //     color: Color.fromARGB(255, 94, 36, 228),
              //     size: 28,
              //   ), // Icon for logout
              //   onTap: () {
              //     // Call the logout function to log the user out
              //     logout();
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

void showPasswordUpdateDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        String oldPassword = '';
        String newPassword = '';
        String confirmPassword = '';

        return AlertDialog(
          title: const Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                obscureText: true,
                onChanged: (value) {
                  oldPassword = value;
                },
                decoration: const InputDecoration(labelText: 'Old Password'),
              ),
              TextField(
                obscureText: true,
                onChanged: (value) {
                  newPassword = value;
                },
                decoration: const InputDecoration(labelText: 'New Password'),
              ),
              TextField(
                obscureText: true,
                onChanged: (value) {
                  confirmPassword = value;
                },
                decoration:
                    const InputDecoration(labelText: 'Confirm New Password'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Call the password update function here
                await updatePassword(oldPassword, newPassword);

                // Close the dialog
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
          ],
        );
      });
}

Future<void> updatePassword(String oldPassword, String newPassword) async {
  final String? userId = await storage.read(key: "id");
  final String? baseUrl = await storage.read(key: "baseurl");
  final String apiUrl = '$baseUrls/api/users/$userId/update-password';
  final String? token = await storage.read(key: "access_token");

  try {
    final response = await http.patch(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      },
    );

    if (response.statusCode == 200) {
      print('Password updated successfully');
      // Show a success message to the user
    } else {
      print('Failed to update password');
      // Show an error message to the user
    }
  } catch (error) {
    print('Error occurred while updating password: $error');
    // Show an error message to the user
  }
}
