import 'package:flutter/material.dart';

import 'package:SunShine/features/notification/domain/entites/notification.dart'
    as no;
import 'package:SunShine/features/notification/presontation/widgets/Notification_detail.dart';

class NotificationDetailPage extends StatelessWidget {
  final no.Notification notification;
  const NotificationDetailPage({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppbar() {
    return AppBar(
      title: Text("Post Detail"),
    );
  }

  Widget _buildBody() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: NotificationDetailWidget(notification: notification),
      ),
    );
  }
}
