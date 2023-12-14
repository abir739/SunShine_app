import 'package:dartz/dartz.dart';
import 'package:zenify_app/core/error/failures.dart';
import 'package:zenify_app/features/notification/domain/entites/notification.dart';
import 'package:zenify_app/features/notification/domain/repositores/notification_repostory.dart';
import 'package:zenify_app/features/profile/domain/entity/user.dart';
import 'package:zenify_app/features/profile/domain/repository/user_repository.dart';

class UpdateUserUseCase {
  final UserRepository userRepository;

  UpdateUserUseCase( this.userRepository);
  Future<Either<Failure, Unit>> call( User user) async {
    return await userRepository.updateUser(user);
  }
}
