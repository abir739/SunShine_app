import 'package:dartz/dartz.dart';
import 'package:flutter/rendering.dart';
import 'package:SunShine/core/error/exceptions.dart';

import 'package:SunShine/core/error/failures.dart';
import 'package:SunShine/core/network/network_info/network_info.dart';
import 'package:SunShine/features/notification/data/datasourses/notification_local_data_sources.dart';
import 'package:SunShine/features/notification/data/datasourses/notification_remote_data_sources.dart';
import 'package:SunShine/features/notification/data/model/pushnotificationmodel.dart';

import 'package:SunShine/features/notification/domain/entites/notification.dart';

import '../../domain/repositores/notification_repostory.dart';

typedef Future<Unit> DeletOrUpdateOrAddNotification();

class NotificationsRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSours notificationRemoteDataSours;
  final NotificationLocalDataSours notificationLocalDataSours;
  final NetworkInfo networkInfo;

  NotificationsRepositoryImpl(
      {required this.notificationRemoteDataSours,
      required this.networkInfo,
      required this.notificationLocalDataSours});
  Future<Either<Failure, List<Notification>>> getAllNotification(
      int? index) async {
    if (await networkInfo.isConnectes) {
      try {
        final RemoteNotificationList =
            await notificationRemoteDataSours.getAllNotification(index);
        await notificationLocalDataSours
            .cachedNotification(RemoteNotificationList);
        return Right(RemoteNotificationList);
      } on ServerExeption {
        return Left(ServerFailure());
      }
    } else {
      try {
        final CachedNotificationList =
            await notificationLocalDataSours.getCachedNotification();
        return Right(CachedNotificationList);
      } on CacheExtentStyle {
        return Left(EmptyFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> addNotification(
      Notification notification) async {
    final NotificationModel notificationModel = NotificationModel(
      // badge: notification.badge,
      // category: notification.category,
      // id: notification.id,
      message: notification.message,
      // createdAt: notification.createdAt,
      // type: notification.type,
      title: notification.title,
      // sending: notification.sending,
      // creatorUser: notification.creatorUser,
      // user: notification.user,
      // creatorUserId: notification.creatorUserId
    );
    if (await networkInfo.isConnectes) {
      try {
        await notificationRemoteDataSours.addNotification(notificationModel);

        return Right(unit);
      } on ServerExeption {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deletNotification(String id) async {
    if (await networkInfo.isConnectes) {
      try {
        await notificationRemoteDataSours.deletNotification(id);

        return Right(unit);
      } on ServerExeption {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateNotification(
      Notification notification) async {
    final NotificationModel notificationModel = NotificationModel(
        badge: notification.badge,
        category: notification.category,
        id: notification.id,
        message: notification.message,
        createdAt: notification.createdAt,
        type: notification.type,
        title: notification.title,
        sending: notification.sending,
        creatorUser: notification.creatorUser,
        user: notification.user,
        creatorUserId: notification.creatorUserId);
    // if (await networkInfo.isConnectes) {
    //   try {
    //     await notificationRemoteDataSours.UpdateNotification(notificationModel);

    //     return Right(unit);
    //   } on ServerExeption {
    //     return Left(ServerFailure());
    //   }
    // } else {
    //   return Left(OfflineFailure());
    // }
    return await _getAllMessage(
      () {
        return notificationRemoteDataSours.UpdateNotification(
            notificationModel);
      },
    );
  }

  Future<Either<Failure, Unit>> _getAllMessage(
      // Future<Unit> Function()
      DeletOrUpdateOrAddNotification deletOrupdateOrAddNotification) async {
    if (await networkInfo.isConnectes) {
      try {
        await deletOrupdateOrAddNotification();

        return Right(unit);
      } on ServerExeption {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
