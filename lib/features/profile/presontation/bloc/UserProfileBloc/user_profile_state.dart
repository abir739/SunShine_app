part of 'user_profile_bloc.dart';

sealed class UserProfileState extends Equatable {
  const UserProfileState();
  
  @override
  List<Object> get props => [];
}

final class UserProfileInitial extends UserProfileState {}

final class LoadingUserState extends UserProfileState {}

final class LoadedUserState extends UserProfileState {
  final User user;

  LoadedUserState({required this.user});
  @override
  List<Object> get props => [user];
}

final class ErrorUserState extends UserProfileState {
  final String Message;

  ErrorUserState({required this.Message});
  @override
  List<Object> get props => [Message];
}
final class MessageAddDeletUpdateNotificationState
    extends UserProfileState {
        final String message;

  MessageAddDeletUpdateNotificationState({required this.message});
          @override
  List<Object> get props => [message];
    }