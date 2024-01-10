import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:SunShine/features/Activites/presontation/widgets/LodingNotificationWidget.dart';
import 'package:SunShine/features/notification/presontation/bloc/NotificationsBlocs/notifications_bloc.dart';
import 'package:SunShine/features/notification/presontation/bloc/add_delet_update_notification/add_delet_update_notification_bloc.dart';
import 'package:SunShine/features/notification/presontation/pages/Notification_page.dart';
import 'package:SunShine/features/notification/presontation/widgets/Notification_detail_page/form_widget.dart';

import '../../../../core/util/snackbar_message.dart';
import 'package:SunShine/features/notification/domain/entites/notification.dart'
    as no;

class NotificationAddUpdatePage extends StatelessWidget {
  final no.Notification? notification;
  final bool isUpdateNotifification;
  const NotificationAddUpdatePage(
      {Key? key, this.notification, required this.isUpdateNotifification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppbar() {
    return AppBar(
        title: Text(isUpdateNotifification
            ? "Edit Notification"
            : "Add Notifications"));
  }

  Widget _buildBody() {
    return Center(
      child: Padding(
          padding: EdgeInsets.all(10),
          child: BlocConsumer<AddDeletUpdateNotificationBloc,
              AddDeletUpdateNotificationState>(
            listener: (context, state) {
              if (state is MessageAddDeletUpdateNotificationState) {
                SnackBarMessage().showSuccessSnackBar(
                    message: state.message, context: context);
                BlocProvider.of<NotificationsBloc>(context)
                    .add(RefreshNotificationsEvent());
                // Navigator.of(context).pushAndRemoveUntil(
                //     MaterialPageRoute(builder: (_) => NotificationPage()),
                //     (route) => false);
                // Navigator.of(context);
                Navigator.pop(context);
              } else if (state is ErrorAddDeletUpdateNotificationState) {
                print("ErrorAddDeletUpdateNotificationState");
                SnackBarMessage().showErrorSnackBar(
                    message: state.message, context: context);
              }
            },
            builder: (context, state) {
              if (state is LoadingAddDeletUpdateNotificationState) {
                print("LoadingWidget");
                return LoadingWidget();
              }

              return FormWidget(
                  isUpdatePost: isUpdateNotifification,
                  post: isUpdateNotifification ? notification : null);
            },
          )),
    );
  }
}
