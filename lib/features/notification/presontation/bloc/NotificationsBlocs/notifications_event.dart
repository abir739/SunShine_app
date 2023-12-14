part of 'notifications_bloc.dart';

sealed class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object> get props => [];

 
}
class GetAllNotificationsEvent extends NotificationsEvent{  int? index;

  GetAllNotificationsEvent({  this.index});
    List<Object> get props => [index??0];}
class RefreshNotificationsEvent extends NotificationsEvent{}