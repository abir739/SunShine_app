import 'package:flutter/material.dart';
import 'package:SunShine/features/notification/domain/entites/notification.dart'
    as no;
import 'package:SunShine/features/notification/presontation/widgets/Notification_detail_page/delete_notification_btn_widget.dart';
import 'package:SunShine/features/notification/presontation/widgets/Notification_detail_page/update_notification_btn_widget.dart';

class NotificationDetailWidget extends StatelessWidget {
  final no.Notification notification;
  const NotificationDetailWidget({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Text(
            notification.title.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(
            height: 50,
          ),
          Text(
            notification.creatorUser.toString(),
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Divider(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              UpdateNotificationBtnWidget(post: notification),
              DeletePostBtnWidget(Notificationid: notification.id!)
            ],
          )
        ],
      ),
    );
  }
}
