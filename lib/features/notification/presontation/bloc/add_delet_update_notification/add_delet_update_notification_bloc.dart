import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:zenify_app/core/error/Strings/Failure.dart';
import 'package:zenify_app/core/error/failures.dart';
import 'package:zenify_app/features/notification/domain/entites/notification.dart';
import 'package:zenify_app/features/notification/domain/usecases/add_notification_useCase.dart';
import 'package:zenify_app/features/notification/domain/usecases/delet_notification_useCase.dart';
import 'package:zenify_app/features/notification/domain/usecases/update_notification_useCase.dart';
import 'package:zenify_app/features/notification/presontation/bloc/NotificationsBlocs/notifications_bloc.dart';

part 'add_delet_update_notification_event.dart';
part 'add_delet_update_notification_state.dart';

class AddDeletUpdateNotificationBloc extends Bloc<
    AddDeletUpdateNotificationEvent, AddDeletUpdateNotificationState> {
  final UpdateNotificationUseCase updateNotificationUseCase;
  final DeletNotificationUseCase deletNotificationUseCase;
  final AddNotificationUseCase addNotificationUseCase;

  AddDeletUpdateNotificationBloc(
      {required this.updateNotificationUseCase,
      required this.deletNotificationUseCase,
      required this.addNotificationUseCase})
      : super(AddDeletUpdateNotificationInitial()) {
    on<AddDeletUpdateNotificationEvent>((event, emit) async {
      if (event is AddNotificationEvent) {
        print("LoadingWidget");
        emit(LoadingAddDeletUpdateNotificationState());
        final FailurOrNotifications =
            await addNotificationUseCase(event.notification);
        FailurOrNotifications.fold((failure) {
          emit(ErrorAddDeletUpdateNotificationState(
              message: _mapfailureMassege(failure)));
        }, (_) {
          emit(MessageAddDeletUpdateNotificationState(message: "Success ADD"));
        });
      } else if (event is UpdateNotificationEvent) {
        emit(LoadingAddDeletUpdateNotificationState());
        final FailurOrNotifications =
            await updateNotificationUseCase(event.notification);
        FailurOrNotifications.fold((failure) {
          emit(ErrorAddDeletUpdateNotificationState(
              message: _mapfailureMassege(failure)));
        }, (_) {
          emit(MessageAddDeletUpdateNotificationState(
              message: "Success Update"));
        });
      } else if (event is DeletNotificationEvent) {
        emit(LoadingAddDeletUpdateNotificationState());
        final FailurOrNotifications =
            await deletNotificationUseCase(event.notificationid);
        FailurOrNotifications.fold((failure) {
          emit(ErrorAddDeletUpdateNotificationState(
              message: _mapfailureMassege(failure)));
        }, (_) {
          emit(MessageAddDeletUpdateNotificationState(
              message: "Success delet Notification"));
        });
      }
    });
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
