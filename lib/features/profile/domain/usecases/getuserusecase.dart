import 'package:dartz/dartz.dart';
import 'package:SunShine/core/error/failures.dart';
import 'package:SunShine/features/notification/domain/entites/notification.dart';
import 'package:SunShine/features/notification/domain/repositores/notification_repostory.dart';
import 'package:SunShine/features/profile/domain/entity/user.dart';
import 'package:SunShine/features/profile/domain/repository/user_repository.dart';

class GetUserUsease {
  final UserRepository userRepository;

  GetUserUsease(this.userRepository);
  Future<Either<Failure, User>> call(String id) async {
    return await userRepository.getAllUser(id);
  }
}
