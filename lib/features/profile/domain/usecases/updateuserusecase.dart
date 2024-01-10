import 'package:dartz/dartz.dart';
import 'package:SunShine/core/error/failures.dart';
import 'package:SunShine/features/notification/domain/entites/notification.dart';
import 'package:SunShine/features/notification/domain/repositores/notification_repostory.dart';
import 'package:SunShine/features/profile/domain/entity/user.dart';
import 'package:SunShine/features/profile/domain/repository/user_repository.dart';

class UpdateUserUseCase {
  final UserRepository userRepository;

  UpdateUserUseCase(this.userRepository);
  Future<Either<Failure, Unit>> call(User user) async {
    return await userRepository.updateUser(user);
  }
}
