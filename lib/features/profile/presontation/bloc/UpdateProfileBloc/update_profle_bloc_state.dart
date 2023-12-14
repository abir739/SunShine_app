part of 'update_profle_bloc_bloc.dart';

sealed class UpdateProfleBlocState extends Equatable {
  const UpdateProfleBlocState();
  
  @override
  List<Object> get props => [];
}

final class UpdateProfleBlocInitial extends UpdateProfleBlocState {}

final class LoadingUpdateProfileState
    extends UpdateProfleBlocState {}

final class LoadedUpdateProfileState
    extends UpdateProfleBlocState {}

final class ErrorUpdateProfileState
    extends UpdateProfleBlocState {
  final String message;

  ErrorUpdateProfileState({required this.message});
  
  @override
  List<Object> get props => [message];
}
final class MessageUpdateProfileState
    extends UpdateProfleBlocState {
        final String message;

  MessageUpdateProfileState({required this.message});
          @override
  List<Object> get props => [message];
    }