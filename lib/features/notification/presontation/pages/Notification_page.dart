import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenify_app/Secreens/Notification/LoadingWidget.dart';
import 'package:zenify_app/features/notification/presontation/bloc/NotificationsBlocs/notifications_bloc.dart';
import 'package:zenify_app/features/notification/presontation/pages/notification_add_update_page.dart';
import 'package:zenify_app/features/notification/presontation/widgets/ListNotification.dart';
import 'package:zenify_app/features/notification/presontation/widgets/LodingNotificationWidgets.dart';
import 'package:zenify_app/features/notification/presontation/widgets/MessageDisplay.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: _buildAppBar(),
      body: _bodyNotification(),
      // floatingActionButton: _buildFloatingBtn(context),
    );
  }

  Widget _bodyNotification() {
    return Padding(
      padding:  EdgeInsets.all(2),
      child: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (context, state) {
          print("$state");
          if (state is LoadingNotificationsState) {
            return LoadingWidget();
          } else if (state is LoadedNotificationsState) {
            return RefreshIndicator(
                onRefresh: () => _onRefresh(context),
                child:ListNotificationWidget(notifications: state.notifications));
          } else if (state is ErrorNotificationsState) {
            return MessageDisplay(Message: state.Message);
          }
          return LoadingWidgets();
        },
      ),
    );
  }

  AppBar _buildAppBar() => AppBar(title: Text("NotificationPage"));
   Future<void> _onRefresh(BuildContext context) async {
    BlocProvider.of<NotificationsBloc>(context).add(RefreshNotificationsEvent());
  }
  Widget _buildFloatingBtn(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => NotificationAddUpdatePage(
                      isUpdateNotifification: false,
                    )));
      },
      child: Icon(Icons.add),
    );
  }
}
