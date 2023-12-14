part of 'activites_bloc.dart';

sealed class ActivitesState extends Equatable {
  const ActivitesState();
  
  @override
  List<Object> get props => [];
}

final class ActivitesInitial extends ActivitesState {}
final class LoadingactivitesState extends ActivitesState {}

final class LoadedActivitesState extends ActivitesState {
  final List<Activite> activite;

  LoadedActivitesState({required this.activite});
  @override
  List<Object> get props => [activite];
}

final class ErrorActivitesState extends ActivitesState {
  final String Message;

  ErrorActivitesState({required this.Message});
  @override
  List<Object> get props => [Message];
}
