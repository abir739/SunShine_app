import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:zenify_app/core/error/Strings/Failure.dart';
import 'package:zenify_app/core/error/failures.dart';
import 'package:zenify_app/features/notification/domain/entites/notification.dart';
import 'package:zenify_app/features/notification/domain/usecases/get_all_notification.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final GetAllNotificationUsease getAllNotificationUsease;
  NotificationsBloc({required this.getAllNotificationUsease})
      : super(NotificationsInitial()) {
    on<NotificationsEvent>((event, emit) async {
      if (event is GetAllNotificationsEvent ) {
        emit(LoadingNotificationsState());
        final notificationsOrFailur = await getAllNotificationUsease(event.index??8);
        // final Notification = await getAllNotificationUsease.call();
        notificationsOrFailur.fold((failure) {
          emit(ErrorNotificationsState(Message: _mapfailureMassege(failure)));
        }, (notifications) {
          emit(LoadedNotificationsState(notifications: notifications));
        });
      } else if (event is RefreshNotificationsEvent) {
        emit(LoadingNotificationsState());
        final notificationsOrFailur = await getAllNotificationUsease(10);
        // final Notification = await getAllNotificationUsease.call();
        // emit(_mapFailureOrNotificationStaet(notificationsOrFailur));
        notificationsOrFailur.fold((failure) {
          emit(ErrorNotificationsState(Message: _mapfailureMassege(failure)));
        }, (notifications) {
          emit(LoadedNotificationsState(notifications: notifications));
        });
      }
    });
  }
  NotificationsState _mapFailureOrNotificationStaet(
      Either<Failure, List<Notification>> either) {
    return either.fold((failure)=>
      ErrorNotificationsState(Message: _mapfailureMassege(failure)),
    (notifications)=>
      LoadedNotificationsState(notifications: notifications)
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
