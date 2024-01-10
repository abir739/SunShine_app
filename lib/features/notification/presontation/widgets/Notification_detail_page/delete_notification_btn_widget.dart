import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:SunShine/Secreens/Bottom_navigation_Guide.dart';
import 'package:SunShine/core/util/snackbar_message.dart';
import 'package:SunShine/features/Activites/presontation/widgets/LodingNotificationWidget.dart';
import 'package:SunShine/features/notification/presontation/bloc/NotificationsBlocs/notifications_bloc.dart';
import 'package:SunShine/features/notification/presontation/bloc/add_delet_update_notification/add_delet_update_notification_bloc.dart';
import 'package:SunShine/features/notification/presontation/pages/Notification_page.dart';
import 'package:SunShine/features/notification/presontation/widgets/Notification_detail_page/DeleteDialogWidget.dart';
import 'package:SunShine/guide_Screens/GuidCalander.dart';
import 'package:SunShine/modele/TouristGuide.dart';

class DeletePostBtnWidget extends StatelessWidget {
  final String Notificationid;
  const DeletePostBtnWidget({
    Key? key,
    required this.Notificationid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          Colors.redAccent,
        ),
      ),
      onPressed: () async {
        deleteDialog(context, Notificationid)
            .then((value) => Navigator.pop(context));
      },
      icon: Icon(Icons.delete_outline),
      label: Text("Delete"),
    );
  }

  Future<void> deleteDialog(BuildContext context, String Notificationid) async {
    await showDialog(
        context: context,
        builder: (context) {
          return BlocConsumer<AddDeletUpdateNotificationBloc,
              AddDeletUpdateNotificationState>(
            listener: (context, state) {
              if (state is MessageAddDeletUpdateNotificationState) {
                SnackBarMessage().showSuccessSnackBar(
                    message: state.message, context: context);

                // Navigator.of(context).pushAndRemoveUntil(
                //     MaterialPageRoute(
                //       builder: (_) => BottomNavBarDemo(TouristGuide()),
                //     ),
                //     (route) => false);
                BlocProvider.of<NotificationsBloc>(context)
                    .add(RefreshNotificationsEvent());
                Navigator.pop(context);
                //
              } else if (state is ErrorAddDeletUpdateNotificationState) {
                Navigator.of(context).pop();
                SnackBarMessage().showErrorSnackBar(
                    message: state.message, context: context);
              }
            },
            builder: (context, state) {
              if (state is LoadedAddDeletUpdateNotificationState) {
                return AlertDialog(
                  title: LoadingWidget(),
                );
              }
              return DeleteDialogWidget(Notificationid: Notificationid);
            },
          );
        });
  }
}
