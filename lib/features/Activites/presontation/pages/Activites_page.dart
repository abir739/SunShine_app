import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zenify_app/Secreens/Notification/LoadingWidget.dart';
import 'package:zenify_app/features/Activites/presontation/bloc/Activites/activites_bloc.dart';
import 'package:zenify_app/features/Activites/presontation/widgets/ActivitesList.dart';
import 'package:zenify_app/features/notification/presontation/bloc/NotificationsBlocs/notifications_bloc.dart';
import 'package:zenify_app/features/notification/presontation/widgets/ListNotification.dart';
import 'package:zenify_app/features/notification/presontation/widgets/LodingNotificationWidgets.dart';
import 'package:zenify_app/features/notification/presontation/widgets/MessageDisplay.dart';

class ActivitesPage extends StatelessWidget {
  const ActivitesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _bodyNotification(),
    );
  }

  Widget _bodyNotification() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: BlocBuilder<ActivitesBloc, ActivitesState>(
        builder: (context, state) {
          print("$state");
          if (state is LoadingactivitesState) {
            return LoadingWidget();
          } else if (state is LoadedActivitesState) {
            return ListActivitesWidget(activites: state.activite);
          } else if (state is ErrorActivitesState) {
            return MessageDisplay(Message: state.Message);
          }
          return LoadingWidgets();
        },
      ),
    );
  }

  AppBar _buildAppBar() => AppBar(title: Text("ActivitesPage"));
}
