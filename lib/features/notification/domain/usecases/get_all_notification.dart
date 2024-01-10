import 'package:dartz/dartz.dart';
import 'package:SunShine/core/error/failures.dart';
import 'package:SunShine/features/notification/domain/entites/notification.dart';
import 'package:SunShine/features/notification/domain/repositores/notification_repostory.dart';

class GetAllNotificationUsease {
  final NotificationRepository notificationRepository;

  GetAllNotificationUsease(this.notificationRepository);
  Future<Either<Failure, List<Notification>>> call(int index) async {
    return await notificationRepository.getAllNotification(index);
  }
}
