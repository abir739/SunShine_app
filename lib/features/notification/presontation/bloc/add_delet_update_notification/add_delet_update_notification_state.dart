part of 'add_delet_update_notification_bloc.dart';

sealed class AddDeletUpdateNotificationState extends Equatable {
  const AddDeletUpdateNotificationState();

  @override
  List<Object> get props => [];
}

final class AddDeletUpdateNotificationInitial
    extends AddDeletUpdateNotificationState {}

final class LoadingAddDeletUpdateNotificationState
    extends AddDeletUpdateNotificationState {}

final class LoadedAddDeletUpdateNotificationState
    extends AddDeletUpdateNotificationState {}

final class ErrorAddDeletUpdateNotificationState
    extends AddDeletUpdateNotificationState {
  final String message;

  ErrorAddDeletUpdateNotificationState({required this.message});
  
  @override
  List<Object> get props => [message];
}
final class MessageAddDeletUpdateNotificationState
    extends AddDeletUpdateNotificationState {
        final String message;

  MessageAddDeletUpdateNotificationState({required this.message});
          @override
  List<Object> get props => [message];
    }