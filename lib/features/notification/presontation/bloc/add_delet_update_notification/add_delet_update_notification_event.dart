part of 'add_delet_update_notification_bloc.dart';

sealed class AddDeletUpdateNotificationEvent extends Equatable {
  const AddDeletUpdateNotificationEvent();

  @override
  List<Object> get props => [];
}

class UpdateNotificationEvent extends AddDeletUpdateNotificationEvent {
  final Notification notification;

  UpdateNotificationEvent({required this.notification});
    @override
  List<Object> get props => [notification];
}
class AddNotificationEvent extends AddDeletUpdateNotificationEvent {
  final Notification notification;

  AddNotificationEvent({required this.notification});
      @override
  List<Object> get props => [notification];
}
class DeletNotificationEvent extends AddDeletUpdateNotificationEvent {
  final String notificationid;

  DeletNotificationEvent({required this.notificationid});
      @override
  List<Object> get props => [notificationid];
}
