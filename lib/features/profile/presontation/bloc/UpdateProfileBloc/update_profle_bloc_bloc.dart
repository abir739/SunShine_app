import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zenify_app/core/error/Strings/Failure.dart';
import 'package:zenify_app/core/error/failures.dart';
import 'package:zenify_app/features/profile/domain/entity/user.dart';
import 'package:zenify_app/features/profile/domain/usecases/getuserusecase.dart';
import 'package:zenify_app/features/profile/domain/usecases/updateuserusecase.dart';

part 'update_profle_bloc_event.dart';
part 'update_profle_bloc_state.dart';

class UpdateProfleBlocBloc
    extends Bloc<UpdateProfleBlocEvent, UpdateProfleBlocState> {
  final UpdateUserUseCase updateUserUseCase;
  
  UpdateProfleBlocBloc({
    required this.updateUserUseCase,
 
  }) : super(UpdateProfleBlocInitial()) {
    on<UpdateProfleBlocEvent>((event, emit) async{

if (event is UpdateProfileEvent) {
        emit(LoadingUpdateProfileState());
        final FailurOrNotifications =
            await updateUserUseCase(event.user);
          
        FailurOrNotifications.fold((failure) {
          emit(ErrorUpdateProfileState(
              message: _mapfailureMassege(failure)));
        }, (_) {
          emit(MessageUpdateProfileState(
              message: "Success Update Your Profile"));
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
