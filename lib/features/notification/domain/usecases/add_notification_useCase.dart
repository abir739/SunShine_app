import 'package:dartz/dartz.dart';
import 'package:SunShine/core/error/failures.dart';
import 'package:SunShine/features/notification/domain/entites/notification.dart';
import 'package:SunShine/features/notification/domain/repositores/notification_repostory.dart';

class AddNotificationUseCase {
  final NotificationRepository notificationRepository;

  AddNotificationUseCase(this.notificationRepository);
  Future<Either<Failure, Unit>> call(Notification notification) async {
    return await notificationRepository.addNotification(notification);
  }
}
