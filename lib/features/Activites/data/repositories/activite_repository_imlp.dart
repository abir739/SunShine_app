

import 'package:dartz/dartz.dart';
import 'package:flutter/rendering.dart';
import 'package:zenify_app/core/error/exceptions.dart';

import 'package:zenify_app/core/error/failures.dart';
import 'package:zenify_app/core/network/network_info/network_info.dart';
import 'package:zenify_app/features/Activites/data/datasourses/activiteLocalDataSours.dart';
import 'package:zenify_app/features/Activites/data/datasourses/activiteRemoteDataSours.dart';
import 'package:zenify_app/features/Activites/data/model/activitesmodel.dart';
import 'package:zenify_app/features/Activites/domain/entites/activite.dart';
import 'package:zenify_app/features/Activites/domain/repositores/Activite_repository.dart';
import 'package:zenify_app/features/notification/data/datasourses/notification_local_data_sources.dart';
import 'package:zenify_app/features/notification/data/datasourses/notification_remote_data_sources.dart';
import 'package:zenify_app/features/notification/data/model/pushnotificationmodel.dart';

import 'package:zenify_app/features/notification/domain/entites/notification.dart';



typedef Future<Unit> DeletOrUpdateOrAddActivites();

 class ActiviteRepositoryImplement implements ActiviteRepository {
  
  final ActiviteRemoteDataSours activiteRemoteDataSours;
  final ActiviteRLocalDataSours activiteRLocalDataSours;
  final NetworkInfo networkInfo;

  ActiviteRepositoryImplement(
      {required this.activiteRemoteDataSours,
      required this.networkInfo,
      required this.activiteRLocalDataSours});
  Future<Either<Failure, List<Activite>>> getAllActivites() async {
    if (await networkInfo.isConnectes) {
      print("${networkInfo.isConnectes}");
      try {print("networkScsees");
        final RemoteNotificationList =
            await activiteRemoteDataSours.getAllActivities();
        await activiteRLocalDataSours
            .cachedActivity(RemoteNotificationList);
        return Right(RemoteNotificationList);
      } on ServerExeption {
        return Left(ServerFailure());
      }
    } else {
      print("${networkInfo.isConnectes}");
      try {   print("networkInfoerror");
        final CachedActivites =
            await activiteRLocalDataSours.getCachedActivity();
        return Right(CachedActivites);
      } on CacheExtentStyle {
        return Left(EmptyFailure());
      }
    }
  }

  // @override
  // Future<Either<Failure, Unit>> addActivites(
  //      Activite activite) async {
  //   final ActivityModel activityModels = ActivityModel(
    
  //       activityTemplate: activityModels.activityTemplate,
  //       adultPrice: activityModel.adultPrice,
  //       id: activityModel.id,
  //       childPrice: activityModel.childPrice,
  //       createdAt: activityModel.createdAt,
  //       type: activityModel.type,
  //       title: activityModel.title,
  //       sending: activityModel.sending,
  //       creatorUser: activityModel.creatorUser,
  //       user: activityModel.user,
  //       creatorUserId: activityModel.creatorUserId);
  //   if (await networkInfo.isConnectes) {
  //     try {
  //       await activiteRemoteDataSours.addNotification(notificationModel);

  //       return Right(unit);
  //     } on ServerExeption {
  //       return Left(ServerFailure());
  //     }
  //   } else {
  //     return Left(OfflineFailure());
  //   }
  // }

  // @override
  // Future<Either<Failure, Unit>> deletNotification(String id) async {
  //   if (await networkInfo.isConnectes) {
  //     try {
  //       await activiteRemoteDataSours.deletNotification(id);

  //       return Right(unit);
  //     } on ServerExeption {
  //       return Left(ServerFailure());
  //     }
  //   } else {
  //     return Left(OfflineFailure());
  //   }
  // }

  @override
  Future<Either<Failure, Unit>> updateActivites(
      Activite activite) async {
    final ActivityModel activityModel = ActivityModel(
        placesCount: activite.placesCount,
        activityTemplate: activite.activityTemplate,
        id: activite.id,
        babyPrice: activite.babyPrice,
        createdAt: activite.createdAt,
        activityTemplateId: activite.activityTemplateId,
        adultPrice: activite.adultPrice,
        childPrice: activite.childPrice,
        agency: activite.agency,
        currency: activite.currency,
        creatorUserId: activite.creatorUserId);
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
        return activiteRemoteDataSours.UpdateActivities(activityModel);
      },
    );
  }

  Future<Either<Failure, Unit>> _getAllMessage(
      // Future<Unit> Function()
    DeletOrUpdateOrAddActivites   deletOrupdateOrAddActivites)
       async {
    if (await networkInfo.isConnectes) {
      try {
        await deletOrupdateOrAddActivites();

        return Right(unit);
      } on ServerExeption {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
  
  @override
  Future<Either<Failure, Unit>> addActivites(Activite activitie) {
    // TODO: implement addActivites
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, Unit>> deletActivite(String id) {
    // TODO: implement deletActivite
    throw UnimplementedError();
  }
}
