import 'package:dartz/dartz.dart';
import 'package:SunShine/core/error/failures.dart';
import 'package:SunShine/features/notification/domain/entites/notification.dart';
import 'package:SunShine/features/profile/domain/entity/user.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> getAllUser(String index);
  Future<Either<Failure, Unit>> deletUser(String id);
  Future<Either<Failure, Unit>> updateUser(User user);
  Future<Either<Failure, Unit>> addUser(User user);
}
