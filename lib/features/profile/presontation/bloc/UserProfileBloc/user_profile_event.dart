part of 'user_profile_bloc.dart';

sealed class UserProfileEvent extends Equatable {
  const UserProfileEvent();

  @override
  List<Object> get props => [];
}
class GetUserEvent extends UserProfileEvent{  String? index;

  GetUserEvent({  this.index});
    List<Object> get props => [index??0];}
class RefreshUserEvent extends UserProfileEvent{}