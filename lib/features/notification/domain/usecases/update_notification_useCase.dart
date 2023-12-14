import 'package:dartz/dartz.dart';
import 'package:zenify_app/core/error/failures.dart';
import 'package:zenify_app/features/notification/domain/entites/notification.dart';
import 'package:zenify_app/features/notification/domain/repositores/notification_repostory.dart';

class UpdateNotificationUseCase {
  final NotificationRepository notificationRepository;

  UpdateNotificationUseCase( this.notificationRepository);
  Future<Either<Failure, Unit>> call( Notification notification) async {
    return await notificationRepository.updateNotification( notification);
  }
}
