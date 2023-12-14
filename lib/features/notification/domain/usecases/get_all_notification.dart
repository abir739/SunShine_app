

import 'package:dartz/dartz.dart';
import 'package:zenify_app/core/error/failures.dart';
import 'package:zenify_app/features/notification/domain/entites/notification.dart';
import 'package:zenify_app/features/notification/domain/repositores/notification_repostory.dart';

class GetAllNotificationUsease {
  final NotificationRepository notificationRepository;

  GetAllNotificationUsease( this.notificationRepository);
  Future<Either<Failure, List<Notification>>> call(int index) async {
    return await notificationRepository.getAllNotification(index);
  }
}
