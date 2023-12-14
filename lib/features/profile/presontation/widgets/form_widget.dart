import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:zenify_app/Secreens/Upload_Files/FilePickerUploader.dart';
import 'package:zenify_app/core/util/snackbar_message.dart';
import 'package:zenify_app/features/Activites/presontation/widgets/LodingNotificationWidgets.dart';
import 'package:zenify_app/features/notification/domain/entites/notification.dart'
    as no;
import 'package:zenify_app/features/notification/presontation/bloc/add_delet_update_notification/add_delet_update_notification_bloc.dart';
import 'package:zenify_app/features/notification/presontation/widgets/Notification_detail_page/form_submit_btn.dart';
import 'package:zenify_app/features/notification/presontation/widgets/Notification_detail_page/text_form_field_widget.dart';
import 'package:zenify_app/features/profile/presontation/bloc/UpdateProfileBloc/update_profle_bloc_bloc.dart';
import 'package:zenify_app/features/profile/presontation/bloc/UserProfileBloc/user_profile_bloc.dart';
import 'package:zenify_app/services/constent.dart';
import 'package:zenify_app/services/widget/profile_widget%20_appbar.dart';
import 'package:zenify_app/services/widget/profile_widget.dart';

import '../../domain/entity/user.dart';
import 'package:intl/intl.dart';
class FromProfileWidget extends StatefulWidget {
  final User? user;
   FromProfileWidget({
    Key? key,
    this.user,
  }) : super(key: key);

  @override
  State<FromProfileWidget> createState() => _FromProfileWidgetState();
}

class _FromProfileWidgetState extends State<FromProfileWidget> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _LastNameController = TextEditingController();
  TextEditingController _bodyController = TextEditingController();
  TextEditingController _birthdayController = TextEditingController();
  TextEditingController _LocationController = TextEditingController();
  DateTime? _selectedDate;FilePickerUploader uploader = FilePickerUploader();
  @override
  void initState() {
    _emailController.text = widget.user?.email ?? "";
    _LocationController.text = widget.user?.address ?? "";
    _LastNameController.text = widget.user?.lastName ?? "";
    _bodyController.text = widget.user?.firstName ?? "";
  _birthdayController.text = widget.user?.birthDate != null
    ? DateFormat('yyyy-MM-dd').format(widget.user!.birthDate??DateTime.now())
    : "";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(automaticallyImplyLeading :false,
    //       actions: [
    //         ProfileWidgetAppBar(
    //           imagePath:
    //               '${baseUrls}/assets/uploads/traveller/${widget.user?.picture}',
    //           onClicked: () async {
    //             // String? newData = await uploader.pickAndUploadFile(
    //             //   dynamicPath: 'traveller', // Replace with your dynamic path
    //             //   id: '${widget.user?.id}', // Replace with your id
    //             //   object: 'api/users', // Replace with your object
    //             //   field: 'picture', // Replace with your field
    //  }  )//
    //       ],
          title: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [ ProfileWidgetAppBar(
              imagePath:
                  '${baseUrls}/assets/uploads/traveller/${widget.user?.picture}',
              onClicked: () async {
                // String? newData = await uploader.pickAndUploadFile(
                //   dynamicPath: 'traveller', // Replace with your dynamic path
                //   id: '${widget.user?.id}', // Replace with your id
                //   object: 'api/users', // Replace with your object
                //   field: 'picture', // Replace with your field
     }  ),
              Row(
                children: [
                  Text("${widget.user?.firstName}   "), Text("${widget.user?.lastName}"),
                ],
              ),
             
            ],
          ),
          backgroundColor: Color(0xFFEB5F52),
        ),
        body: BlocConsumer<UpdateProfleBlocBloc, UpdateProfleBlocState>(
          listener: (context, state) {
            if (state is MessageUpdateProfileState) {
              SnackBarMessage().showSuccessSnackBar(
                  message: state.message, context: context);
              BlocProvider.of<UserProfileBloc>(context).add(RefreshUserEvent());
              // Navigator.of(context).pushAndRemoveUntil(
              //     MaterialPageRoute(builder: (_) => NotificationPage()),
              //     (route) => false);
              // Navigator.of(context);
              Navigator.pop(context);
            } else if (state is ErrorUpdateProfileState) {
              print("ErrorAddDeletUpdateNotificationState");
              SnackBarMessage()
                  .showErrorSnackBar(message: state.message, context: context);
            }
          },
          builder: (context, state) {
            if (state is LoadedUserState) {
              print("LoadingWidget");
              return Form(
                key: _formKey,
                child: Column(children: [
                  // _buildHeader(context: context,user:widget.user),
                  TextFormFieldWidget(
                      name: "email",
                      multiLines: false,
                      controller: _emailController),
                  TextFormFieldWidget(
                      name: "Last Name",
                      multiLines: false,
                      controller: _LastNameController),
                  TextFormFieldWidget(
                      name: "location ",
                      multiLines: false,
                      controller: _LocationController),
                  TextFormFieldWidget(
                      name: "first name",
                      multiLines: false,
                      controller: _bodyController),
                  GestureDetector(
                    onTap: () {
                      _selectDate(context);
                    },
                  child: TextFormField(
                        controller: _birthdayController,
                        decoration: InputDecoration(
                          labelText: 'Birthday',
                          // Add any other decoration properties as needed
                          suffixIcon:
                              Icon(Icons.calendar_today), // Add a calendar icon
                        ),
                      ),
                    
                  ),
                  FormSubmitBtn(
                      isUpdatePost: true,
                      onPressed: validateFormThenUpdateOrAddPost)
                ]),
              );
            } else if (state is LoadingUserState) {
              return LoadingWidgets();
            } else {
              return Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [  
                        // _buildHeader(context: context,user:widget.user),
                      TextFormFieldWidget(
                          name: "email",
                          multiLines: false,
                          controller: _emailController),
                      TextFormFieldWidget(
                          name: "Last Name",
                          multiLines: false,
                          controller: _LastNameController),
                      TextFormFieldWidget(
                          name: "location ",
                          multiLines: false,
                          controller: _LocationController),
                      TextFormFieldWidget(
                          name: "first name",
                          multiLines: false,
                          controller: _bodyController),
                      GestureDetector(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: AbsorbPointer(
                          child:
                           Padding(
                             padding: const EdgeInsets.all(12.0),
                             child: TextFormField(
                              controller: _birthdayController,
                              decoration: InputDecoration(
                                labelText: 'Birthday',
                                // Add any other decoration properties as needed
                                suffixIcon: Icon(
                                    Icons.calendar_today), // Add a calendar icon
                              ),
                                                     ),
                           ),
                        ),
                      ),
                      FormSubmitBtn(
                          isUpdatePost: true,
                          onPressed: validateFormThenUpdateOrAddPost)
                    ]),
              );
            }

            // return FormWidget(
            //     isUpdatePost: isUpdateNotifification,
            //     post: isUpdateNotifification ? notification : null);
          },
        ));
  }
// Widget _buildHeader({ User? user, required BuildContext context}) {
//     return user?.picture == null
//         ? ProfileWidget(
//             imagePath:
//                 'https://4kwallpapers.com/images/walls/thumbs_2t/2167.jpg',
//             onClicked: () async {
//               // _onImageTap();
//               String? newData = await uploader.pickAndUploadFile(
//                 dynamicPath: 'traveller', // Replace with your dynamic path
//                 id: '${user?.id}', // Replace with your id
//                 object: 'api/users', // Replace with your object
//                 field: 'picture', // Replace with your field
//               ); // Call your async operation when the button is clicked
//             },
//           )
//         : Column(children: [
//             SizedBox(height: Get.height * 0.05),
//             ProfileWidget(
//               imagePath:
//                   '${baseUrls}/assets/uploads/traveller/${user?.picture}',
//               onClicked: () async {
//                 String? newData = await uploader.pickAndUploadFile(
//                   dynamicPath: 'traveller', // Replace with your dynamic path
//                   id: '${user?.id}', // Replace with your id
//                   object: 'api/users', // Replace with your object
//                   field: 'picture', // Replace with your field
//                 ); //
//                 _onRefresh(context);
//                 if (newData != null) {
//                   // You can use newData here
//                   print("Received data from FileUploadScreen: $newData");
//                   // setState(() {
//                   //   _onRefresh();
//                   //    BlocProvider.of<UserBloc>(context)
//                   //   .add( GetAllTodosEvent());
//                   // });
//                 } else {
//                   // Handle the case where newData is null
//                   print("No data received from FileUploadScreen");
//                 }
//               },
//             ),
//             // GestureDetector(
//             //   onTap: ()
//             //   async {
//             //     String? newData = await uploader.pickAndUploadFile(
//             //       dynamicPath:
//             //           'traveller', // Replace with your dynamic path
//             //       id: '$userId', // Replace with your id
//             //       object: 'api/users', // Replace with your object
//             //       field: 'picture', // Replace with your field
//             //     ); //
//             //     if (newData != null) {
//             //       // You can use newData here
//             //       print("Received data from FileUploadScreen: $newData");
//             //       setState(() {
//             //         _onRefresh();
//             //       });
//             //     } else {
//             //       // Handle the case where newData is null
//             //       print("No data received from FileUploadScreen");
//             //     }
//             //   },
//             //   // child: buildEditIcon(Colors.blue),
//             // )
//           ]);
//   }
// Future<void> _onRefresh(BuildContext context) async {
//     BlocProvider.of<UpdateProfleBlocBloc>(context);
//   }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
       builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          primaryColor: Colors.red, // Set your desired color for selected date
          // bottomSheetTheme: Colors.blue, // Set your desired color for the buttons
           colorScheme: ColorScheme.light(primary: Colors.red),
          // buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.values),
        ),
        child: child!,
      );
    },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _birthdayController.text =DateFormat('yyyy-MM-dd').format( _selectedDate!.toLocal());
      });
    }
  }

  Future<void> validateFormThenUpdateOrAddPost() async {
    final isValid = _formKey.currentState!.validate();
    DateTime? parsedDate = DateTime.tryParse(_birthdayController.text);
    String? isoDateString = parsedDate?.toIso8601String();
    // if (isValid) {
    final user = User(
      id: widget.user?.id,
      email: _emailController.text,
      firstName: _bodyController.text,
      lastName: _LastNameController.text,
      address: _LocationController.text,
      birthDate: parsedDate,
    );

    BlocProvider.of<UpdateProfleBlocBloc>(context)
        .add(UpdateProfileEvent(user: user));

    //               Navigator.pop(context);
    // }
    // BlocProvider.of<UserProfileBloc>(context).add(RefreshUserEvent());
    // Navigator.pop(context);
  }

  void update() {
    BlocProvider.of<UserProfileBloc>(context).add(RefreshUserEvent());
    Navigator.pop(context);
  }
}
