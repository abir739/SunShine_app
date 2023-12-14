part of 'update_profle_bloc_bloc.dart';

sealed class UpdateProfleBlocEvent extends Equatable {
  const UpdateProfleBlocEvent();

  @override
  List<Object> get props => [];
}
class UpdateProfileEvent extends UpdateProfleBlocEvent {
  final User user;

  UpdateProfileEvent({required this.user});
    @override
  List<Object> get props => [user];
}