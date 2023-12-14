import 'package:zenify_app/features/notification/presontation/bloc/add_delet_update_notification/add_delet_update_notification_bloc.dart';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteDialogWidget extends StatelessWidget {
  final String Notificationid;
  const DeleteDialogWidget({
    Key? key,
    required this.Notificationid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Are you Sure ?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            "No",
          ),
        ),
        TextButton(
          onPressed: () {
            BlocProvider.of<AddDeletUpdateNotificationBloc>(context).add(
              DeletNotificationEvent(notificationid: Notificationid),
            );
          },
          child: Text("Yes"),
        ),
      ],
    );
  }
}