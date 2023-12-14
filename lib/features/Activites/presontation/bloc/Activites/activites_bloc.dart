import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:zenify_app/core/error/Strings/Failure.dart';
import 'package:zenify_app/core/error/failures.dart';
import 'package:zenify_app/features/Activites/domain/entites/activite.dart';
import 'package:zenify_app/features/Activites/domain/usecases/getAll_activites_useCase%20.dart';

part 'activites_event.dart';
part 'activites_state.dart';

class ActivitesBloc extends Bloc<ActivitesEvent, ActivitesState> {
  final GetAllActiviteUseCase getAllActiviteUseCase;
  ActivitesBloc({required this.getAllActiviteUseCase})
      : super(ActivitesInitial()) {
    on<ActivitesEvent>((event, emit) async{

     if (event is GetAlActivitesEvent ||
          event is RefreshActivitesEvent) {
        emit(LoadingactivitesState());
        final notificationsOrFailur = await getAllActiviteUseCase();
        // final Notification = await getAllNotificationUsease.call();
        notificationsOrFailur.fold((failure) {
          emit(ErrorActivitesState(Message: _mapfailureMassege(failure)));
        }, (activites) {
          emit(LoadedActivitesState(activite: activites));
        });
      } else if (event is RefreshActivitesEvent) {
        emit(LoadingactivitesState());
        final notificationsOrFailur = await getAllActiviteUseCase();
        // final Notification = await getAllNotificationUsease.call();
        // emit(_mapFailureOrNotificationStaet(notificationsOrFailur));
        notificationsOrFailur.fold((failure) {
          emit(ErrorActivitesState(Message: _mapfailureMassege(failure)));
        }, (activites) {
          emit(LoadedActivitesState(activite: activites));
        });
      }
    });
  }
    ActivitesState _mapFailureOrNotificationStaet(
      Either<Failure, List<Activite>> either) {
    return either.fold((failure)=>
      ErrorActivitesState(Message: _mapfailureMassege(failure)),
    (activites)=>
      LoadedActivitesState(activite: activites)
    );
  }

  String _mapfailureMassege(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return Server_FAILLURE_ExECPTION;
      case EmptyFailure:
        return EMpty_FAILLURE_ExECPTION;
      case OfflineFailure:
        return OFFLINE_FAILLURE_ExECPTION;

      default:
        return " Unexpected Error, Please Try Again Later";
    }
  }
}
