import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zenify_app/NetworkHandler.dart';
import 'package:zenify_app/guide_Screens/Guide_First_Page.dart';
import 'package:zenify_app/login/TravellerLoginPage_test.dart';
import 'package:zenify_app/modele/TouristGuide.dart';
import 'package:zenify_app/services/constent.dart';
import 'package:zenify_app/traveller_Screens/Traveller-First-Screen.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

bool _showPassword = false;
final GlobalKey<FormState> formKey = GlobalKey<FormState>();
TextEditingController emailControllerForget = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController confirmController = TextEditingController();
TextEditingController lastNameController = TextEditingController();
TextEditingController firstNameController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController confirmPasswordController = TextEditingController();
TextEditingController usernameController = TextEditingController();
TextEditingController urlc = TextEditingController();
int selectedRadio = 0;
TextEditingController forgetEmailController = TextEditingController();
bool circular = false;
late String errorText;
bool validate = false;
NetworkHandler networkHandler = NetworkHandler();
final storage = FlutterSecureStorage();
const String oneSignalAppId = 'ce7f9114-b051-4672-a9c5-0eec08d625e8';
late TouristGuide guid;

class _MyLoginState extends State<MyLogin> {
  @override
  void initState() {
    super.initState();
    _requestPermission();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    initPlatformState();
    OneSignal.shared.setAppId(oneSignalAppId);
    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      print("SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");
    });
  }

  Future<void> initPlatformState() async {
    OneSignal.shared.setAppId(
      oneSignalAppId,
    );
  }

  void _requestPermission() async {
    final status = await Permission.storage.request();
    print(status);
  }

  Future<void> storeAccessToken(String token) async {
    await storage.write(key: 'access_token', value: token);
    print(token);
  }

  void _handleLogin() async {
    if (formKey.currentState!.validate()) {
         setState(() {
            circular = true;
          });
      Map<String, String> data = {
        "username": emailController.text,
        "password": passwordController.text,
      };
      try {
        var response =
            await networkHandler.post("$baseUrls/api/auth/login", data);

        print(response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
           setState(() {
            circular = false;
          });
          Map<String, dynamic> output =
              Map<String, dynamic>.from(json.decode(response.body));

          print(output["access_token"]);
          print(output["data"]);
          storeAccessToken(output["access_token"]);
          // await storage.write(
          //     key: "access_token", value: output["access_token"]);
          await storage.write(key: "id", value: output["data"]["id"]);
          await storage.write(key: "Role", value: output["data"]["role"]);
          String? Role = output["data"]["role"];
          // Navigator.pushNamed(context, 'register');
          // Get.to(() => GoogleBottomBar());
          if (Role == "Administrator") {
            // Get.off(() => Consumer<guidProvider>(
            //       builder: (context, guideProvider, child) {
            //         return BottomNavBarDemo(guideProvider: guideProvider);
            //       },
            //     ));
            Get.to(() => const PlaningSecreen());
          } else {
            Get.off(() => const TravellerFirstScreen(
                  userList: [],
                ));
          }
        } else {
          Map<String, dynamic> output =
              Map<String, dynamic>.from(json.decode(response.body));

          print(output);
          Get.snackbar('Warning', output['message'],
              colorText: Colors.white,
              backgroundColor: const Color.fromARGB(255, 185, 4, 4));
          setState(() {
            circular = false;
          });
        }
      } catch (error) { 
       
           setState(() {
            circular = false;
          });
           Get.snackbar('Warning', " Check Your connaction...",
            backgroundGradient: const LinearGradient(
              colors: [Color(0xff979090), Color(0x31858489)],
            ),
            colorText: Colors.white,
            backgroundColor: const Color.fromARGB(255, 185, 4, 4));
        print('Network request failed: $error');
      
            
      }
    }
  }

  Future<void> sendPasswordResetEmailRequest(String email) async {
    final response = await http.post(
      Uri.parse('${baseUrls}/api/auth/forgot-password'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'email': email,
      }),
    );

    if (response.statusCode == 201) {
      await showResetDialogEmail(email);
      print('Password reset request sent successfully');
    } else {
      print('Failed to send password reset request');
    }
  }

  Future<void> showResetDialogEmail(String email) async {
    final TextEditingController resetTokenController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      animType: AnimType.BOTTOMSLIDE,
      title: 'Reset Password',
      body: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: resetTokenController,
              decoration:
                  const InputDecoration(labelText: '  Enter Reset Token'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the reset token';
                }
                return null;
              },
            ),
            TextFormField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: '  New Password'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the new password';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      btnOkText: 'Reset Password',
      btnCancelText: 'Cancel',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        if (formKey.currentState!.validate()) {
          final resetResponse = await http.post(
            Uri.parse(
                '${baseUrls}/api/auth/reset-password/${resetTokenController.text}'),
            headers: <String, String>{
              'Content-Type': 'application/json',
            },
            body: jsonEncode(<String, dynamic>{
              'email': email,
              'newPassword': newPasswordController.text,
            }),
          );

          if (resetResponse.statusCode == 201) {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.SUCCES,
              title: 'Success',
              desc: 'Password reset via email successful',
              btnOkText: 'OK',
              btnOkColor: Colors.green,
              dismissOnTouchOutside: true,
            ).show();
            Navigator.pop(context);
          } else {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.ERROR,
              title: 'Error',
              desc: 'Failed to reset password via email',
              btnOkText: 'OK',
              btnOkColor: const Color(0xff979090),
              dismissOnTouchOutside: true,
            ).show();
          }
        }
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 90.0), // Adjust this height as needed
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo of the app
                        SvgPicture.asset(
                          'assets/images/Group_Logo.svg',
                          // Replace with your logo image path
                          height: 100.0,
                          width: 100.0,
                        ),
                        const SizedBox(height: 60.0),
                        // Email and Password fields
                        TextFormField(
                          style: const TextStyle(color: Colors.black),
                          controller: emailController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              hintText: "Email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextFormField(
                          style: const TextStyle(),
                          obscureText: !_showPassword,
                          controller: passwordController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            hintText: "Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                              child: Icon(
                                _showPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: emailControllerForget,
                                          decoration: const InputDecoration(
                                            labelText:
                                                'Reset Password via mail',
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          // User chose to reset password via email
                                          sendPasswordResetEmailRequest(
                                              emailControllerForget.text);
                                          Navigator.of(context)
                                              .pop(); // Close the dialog
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: const Color(
                                              0xFFEB5F52), // Custom button color
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                        ),
                                        child: const Text('Reset Password'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Close the dialog
                                        },
                                        child: const Text(
                                          "Cancel",
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: const Text(
                                'Forget your password?',
                                style: TextStyle(
                                  color: Color(0xFF3A3557),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40.0),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          // key: formKey,
                          children: [
                           circular?CircularProgressIndicator(): ElevatedButton(
                              onPressed: _handleLogin,
                              style: ElevatedButton.styleFrom(
                                primary: const Color(
                                    0xFFEB5F52), // Custom button color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              child: Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15.0),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            // Divider with "OR" text
                            const Row(
                              children: [
                                Expanded(
                                  child: Divider(),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: Text('OR'),
                                ),
                                Expanded(
                                  child: Divider(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20.0),
                            ElevatedButton(
                              onPressed: () {
                                Get.off(() => const TravellerLoginPage());
                              },
                              style: ElevatedButton.styleFrom(
                                primary: const Color(
                                    0xFFEB5F52), // Custom button color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              child: Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15.0),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Login with code',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
