import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zenify_app/core/error/Strings/Failure.dart';
import 'package:zenify_app/core/error/failures.dart';
import 'package:zenify_app/features/profile/domain/entity/user.dart';

import '../../../domain/usecases/getuserusecase.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final GetUserUsease getuserusescase;
  UserProfileBloc({required this.getuserusescase})
      : super(UserProfileInitial()) {
    on<UserProfileEvent>((event, emit) async {
      if (event is GetUserEvent) {
        emit(LoadingUserState());
        final userFailur = await getuserusescase(event.index ?? "");
     userFailur.fold((failure) {
          emit(ErrorUserState(Message: _mapfailureMassege(failure)));
        }, (user) {
          emit(LoadedUserState(user: user));
        }); }else if(event is RefreshUserEvent){
 final notificationsOrFailur = await getuserusescase("");
        // final Notification = await getAllNotificationUsease.call();
        // emit(_mapFailureOrNotificationStaet(notificationsOrFailur));
        notificationsOrFailur.fold((failure) {
          emit(ErrorUserState(Message: _mapfailureMassege(failure)));
        }, (user) {
          emit(LoadedUserState(user: user));
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
