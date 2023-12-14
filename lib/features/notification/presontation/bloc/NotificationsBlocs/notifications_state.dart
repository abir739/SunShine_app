part of 'notifications_bloc.dart';

sealed class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

final class NotificationsInitial extends NotificationsState {}

final class LoadingNotificationsState extends NotificationsState {}

final class LoadedNotificationsState extends NotificationsState {
  final List<Notification> notifications;

  LoadedNotificationsState({required this.notifications});
  @override
  List<Object> get props => [notifications];
}

final class ErrorNotificationsState extends NotificationsState {
  final String Message;

  ErrorNotificationsState({required this.Message});
  @override
  List<Object> get props => [Message];
}
