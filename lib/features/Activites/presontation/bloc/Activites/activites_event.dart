part of 'activites_bloc.dart';

sealed class ActivitesEvent extends Equatable {
  const ActivitesEvent();

  @override
  List<Object> get props => [];
}
class GetAlActivitesEvent extends ActivitesEvent{}
class RefreshActivitesEvent extends ActivitesEvent{}