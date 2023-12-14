import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:zenify_app/Secreens/Notification/LoadingWidget.dart';
import 'package:zenify_app/Secreens/Profile/User_Profil.dart';
import 'package:intl/intl.dart';
import 'package:zenify_app/Secreens/Upload_Files/FilePickerUploader.dart';
import 'package:zenify_app/features/notification/presontation/bloc/NotificationsBlocs/notifications_bloc.dart';
import 'package:zenify_app/features/notification/presontation/pages/notification_add_update_page.dart';
import 'package:zenify_app/features/notification/presontation/widgets/ListNotification.dart';
import 'package:zenify_app/features/notification/presontation/widgets/LodingNotificationWidgets.dart';
import 'package:zenify_app/features/notification/presontation/widgets/MessageDisplay.dart';
import 'package:zenify_app/features/profile/presontation/bloc/UserProfileBloc/user_profile_bloc.dart';
import 'package:zenify_app/features/profile/presontation/widgets/form_widget.dart';
import 'package:zenify_app/login/Login.dart';
import 'package:zenify_app/services/constent.dart';
import 'package:zenify_app/services/widget/profile_widget%20_appbar.dart';

import '../../../../services/widget/profile_widget.dart';
import '../../domain/entity/user.dart';

class Profile extends StatelessWidget {
  Profile({super.key});
  FilePickerUploader uploader = FilePickerUploader();
 
  @override
  Widget build(BuildContext context) {
 
    return 
     Scaffold(
      // appBar: _buildAppBar(),
      body: _bodyProfile(context),
      // floatingActionButton: _buildFloatingBtn(context),
    );
  }

  Widget _bodyProfile(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(2),
        child: 
        
        BlocBuilder<UserProfileBloc, UserProfileState>(
          builder: (context, state) {
            print("$state");
            if (state is LoadingUserState) {
              return LoadingWidget();
            } else if (state is LoadedUserState) {
       
              return
               Scaffold(
floatingActionButton: _buildFloatingBtn(context,state.user,),
      body: 
       RefreshIndicator(
                  onRefresh: () => _onRefresh(context),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Visibility(
                            visible: true,
                            child:
                                _buildHeader(user: state.user, context: context)),
                        _buildMainInfo(context, user: state.user),
                        const SizedBox(height: 10.0),
                        _buildInfo(context,state.user),
                        
                      ],
                    ),
                  )));
              // ListNotificationWidget(notifications: state.user));
            } else if (state is ErrorUserState) {
              return MessageDisplay(Message: state.Message);
            }
            return LoadingWidgets();
          },
        ),
      );
    
  }

  AppBar _buildAppBar() => AppBar(title: Text("NotificationPage"));
  Future<void> _onRefresh(BuildContext context) async {
    BlocProvider.of<UserProfileBloc>(context).add(RefreshUserEvent());
  }

  Widget _buildHeader({required User user, required BuildContext context}) {
    return user?.picture == null
        ? ProfileWidget(
            imagePath:
                'https://4kwallpapers.com/images/walls/thumbs_2t/2167.jpg',
            onClicked: () async {
              // _onImageTap();
              String? newData = await uploader.pickAndUploadFile(
                dynamicPath: 'traveller', // Replace with your dynamic path
                id: '${user?.id}', // Replace with your id
                object: 'api/users', // Replace with your object
                field: 'picture', // Replace with your field
              ); // Call your async operation when the button is clicked
            },
          )
        : Column(children: [
            SizedBox(height: Get.height * 0.05),
            ProfileWidget(
              imagePath:
                  '${baseUrls}/assets/uploads/traveller/${user?.picture}',
              onClicked: () async {
                String? newData = await uploader.pickAndUploadFile(
                  dynamicPath: 'traveller', // Replace with your dynamic path
                  id: '${user.id}', // Replace with your id
                  object: 'api/users', // Replace with your object
                  field: 'picture', // Replace with your field
                ); //
                _onRefresh(context);
                if (newData != null) {
                  // You can use newData here
                  print("Received data from FileUploadScreen: $newData");
                  // setState(() {
                  //   _onRefresh();
                  //    BlocProvider.of<UserBloc>(context)
                  //   .add( GetAllTodosEvent());
                  // });
                } else {
                  // Handle the case where newData is null
                  print("No data received from FileUploadScreen");
                }
              },
            ),
            // GestureDetector(
            //   onTap: ()
            //   async {
            //     String? newData = await uploader.pickAndUploadFile(
            //       dynamicPath:
            //           'traveller', // Replace with your dynamic path
            //       id: '$userId', // Replace with your id
            //       object: 'api/users', // Replace with your object
            //       field: 'picture', // Replace with your field
            //     ); //
            //     if (newData != null) {
            //       // You can use newData here
            //       print("Received data from FileUploadScreen: $newData");
            //       setState(() {
            //         _onRefresh();
            //       });
            //     } else {
            //       // Handle the case where newData is null
            //       print("No data received from FileUploadScreen");
            //     }
            //   },
            //   // child: buildEditIcon(Colors.blue),
            // )
          ]);
  }

  Widget _buildMainInfo(BuildContext context, {required User user}) {
    return Container(
      width: Get.width * 2,
      margin: const EdgeInsets.all(2),
      alignment: AlignmentDirectional.center,
      child: Column(
        children: <Widget>[
          Text(
            '${user?.firstName ?? "Loding data"} ${user?.lastName ?? "..."}',
            style: const TextStyle(
              fontSize: 20,
              color: Color.fromARGB(255, 94, 36, 228),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            user?.username ?? 'Loding ... Username', // Fallback value if null
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

  Widget _buildInfo(BuildContext context,  User? user) {
    return SingleChildScrollView(
      child: Container(
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
                ListTile(
                  leading: const Icon(
                    Icons.email,
                    color: Color(0xFFEB5F52),
                  ),
                  title: const Text("E-Mail"),
                  subtitle: Text(user?.email ?? 'N/A'),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.phone,
                    color: Color(0xFFEB5F52),
                  ),
                  title: const Text("Phone Number"),
                  subtitle: Text(user?.phone ?? 'N/A'),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.cake,
                    color: Color(0xFFEB5F52),
                  ),
                  title: const Text("Birth Date"),
                  subtitle: Text(
                   DateFormat('yyyy-MM-dd').format( user?.birthDate??DateTime.now() )?? 'N/A',
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
                  subtitle: Text(user?.address ?? 'N/A'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    showPasswordUpdateDialog(context); // Pass the context
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFFEB5F52), // Set the background color
                  ),
                  child: const Text(
                    'Change Password',
                    style: TextStyle(
                      color: Colors.white, // Set the text color
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(),
                ListTile(
                  title: const Text(
                    'Logout',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 94, 36, 228),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.logout,
                    color: Color.fromARGB(255, 94, 36, 228),
                    size: 28,
                  ), // Icon for logout
                  onTap: () {
                    // Call the logout function to log the user out
                    logout();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> logout() async {
  // Delete sensitive data from secure storage
  await storage.deleteAll();

  // Clear data associated with the private screen (if applicable)
  // Example: clear private screen-related variables or state
  // ...

  // Navigate to the login screen
  Get.offNamed('login');
}

Widget _buildFloatingBtn(BuildContext context,user) {

  // return  BlocBuilder<UserProfileBloc, UserProfileState>(
  //       builder: (context, state) {
  //         print("$state");
  //         if (state is LoadingUserState) {
  //           return LoadingWidget();
  //         } else if (state is LoadedUserState) {
          
           return SingleChildScrollView(
              child   :  ProfileWidgetAppBar(
              imagePath:
                  '${baseUrls}/assets/uploads/traveller/${user?.picture}',
              onClicked: () async {
                Navigator.push(
         context, MaterialPageRoute(builder: (_) => FromProfileWidget(user: user,)));
   
    
                // String? newData = await uploader.pickAndUploadFile(
                //   dynamicPath: 'traveller', // Replace with your dynamic path
                //   id: '${widget.user?.id}', // Replace with your id
                //   object: 'api/users', // Replace with your object
                //   field: 'picture', // Replace with your field
     } ) );
  //                FloatingActionButton(backgroundColor: const Color(0xFFEB5F52),
  //   onPressed: () {
  
  //      Navigator.push(
  //          context, MaterialPageRoute(builder: (_) => FromProfileWidget(user: user,)));
   
  //   },
  //   child: Icon(Icons.update),
  // ) );    
   }    
               
      //       );
      //       // ListNotificationWidget(notifications: state.user));
      //     } else if (state is ErrorUserState) {
      //       return MessageDisplay(Message: state.Message);
      //     }
      //     return LoadingWidgets();
      //   },
      // );
    

