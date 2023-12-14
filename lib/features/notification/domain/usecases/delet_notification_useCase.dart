import 'package:dartz/dartz.dart';
import 'package:zenify_app/core/error/failures.dart';
import 'package:zenify_app/features/notification/domain/repositores/notification_repostory.dart';

class DeletNotificationUseCase {
  final NotificationRepository notificationRepository;

  DeletNotificationUseCase( this.notificationRepository);
  Future<Either<Failure, Unit>> call(String notificationid) async {
    return await notificationRepository.deletNotification(notificationid);
  }
}
