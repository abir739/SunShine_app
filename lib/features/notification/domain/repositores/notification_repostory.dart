import 'package:dartz/dartz.dart';
import 'package:SunShine/core/error/failures.dart';
import 'package:SunShine/features/notification/domain/entites/notification.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<Notification>>> getAllNotification(int index);
  Future<Either<Failure, Unit>> deletNotification(String id);
  Future<Either<Failure, Unit>> updateNotification(Notification notification);
  Future<Either<Failure, Unit>> addNotification(Notification notification);
}
