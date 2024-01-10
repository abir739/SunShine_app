import 'package:flutter/material.dart';
import 'package:SunShine/features/notification/domain/entites/notification.dart'
    as no;
import 'package:SunShine/features/notification/presontation/pages/notification_add_update_page.dart';

class UpdateNotificationBtnWidget extends StatelessWidget {
  final no.Notification post;
  const UpdateNotificationBtnWidget({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NotificationAddUpdatePage(
                isUpdateNotifification: true,
                notification: post,
              ),
            ));
      },
      icon: Icon(Icons.edit),
      label: Text("Edit"),
    );
  }
}
