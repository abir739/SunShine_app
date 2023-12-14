

import 'package:dartz/dartz.dart';
import 'package:flutter/rendering.dart';
import 'package:zenify_app/core/error/exceptions.dart';

import 'package:zenify_app/core/error/failures.dart';
import 'package:zenify_app/core/network/network_info/network_info.dart';
import 'package:zenify_app/features/notification/data/datasourses/notification_local_data_sources.dart';
import 'package:zenify_app/features/notification/data/datasourses/notification_remote_data_sources.dart';
import 'package:zenify_app/features/notification/data/model/pushnotificationmodel.dart';

import 'package:zenify_app/features/notification/domain/entites/notification.dart';
import 'package:zenify_app/features/profile/data/datasourses/user_local_data_sources.dart';
import 'package:zenify_app/features/profile/data/datasourses/user_remote_data_sources.dart';
import 'package:zenify_app/features/profile/data/model/usersmodel.dart';
import 'package:zenify_app/features/profile/domain/entity/user.dart';
import 'package:zenify_app/features/profile/domain/repository/user_repository.dart';


typedef Future<Unit> DeletOrUpdateOrAddNotification();

 class UserRepositoryImpl implements UserRepository {
  
  final UserRemoteDataSours userRemoteDataSours;
  final UserLocalDataSours userLocalDataSours;
  final NetworkInfo networkInfo;

  UserRepositoryImpl(
      {required this.userRemoteDataSours,
      required this.networkInfo,
      required this.userLocalDataSours});
  Future<Either<Failure, User>> getAllUser(String? index) async {
    if (await networkInfo.isConnectes) {
      try {
        final RemoteNotificationList =
            await userRemoteDataSours.getUser(index);
        await userLocalDataSours
            .cachedNotification(RemoteNotificationList);
        return Right(RemoteNotificationList);
      } on ServerExeption {
        return Left(ServerFailure());
      }
    } else {
      try {
        final CachedNotificationList =
            await userLocalDataSours.getCachedUser();
        return Right(CachedNotificationList);
      } on CacheExtentStyle {
        return Left(EmptyFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> addUser(
      User user) async {
    final UserModel userModel = UserModel(
        // badge: user.badge,
        // category: user.category,
        // id: user.id,
        lastName: user.lastName,
        // createdAt: user.createdAt,
        // type: user.type,
        firstName: user.firstName,
        // sending: user.sending,
        // creatorUser: user.creatorUser,
        // user: user.user,
        // creatorUserId: user.creatorUserId
        );
    if (await networkInfo.isConnectes) {
      try {
        await userRemoteDataSours.addUser(userModel);

        return Right(unit);
      } on ServerExeption {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deletUser(String id) async {
    if (await networkInfo.isConnectes) {
      try {
        await userRemoteDataSours.deletUser(id);

        return Right(unit);
      } on ServerExeption {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateUser(
      User user) async {
    final UserModel userModel = UserModel(
        firstName: user.firstName,
        lastName: user.lastName,
        id: user.id,
        birthDate: user.birthDate,
        createdAt: user.createdAt,
        picture: user.picture,
        // password: user.password,
        email: user.email,
        expired: user.expired,
        enabled: user.enabled,
        creatorUserId: user.creatorUserId);
    // if (await networkInfo.isConnectes) {
    //   try {
    //     await userRemoteDataSours.UpdateNotification(userModel);

    //     return Right(unit);
    //   } on ServerExeption {
    //     return Left(ServerFailure());
    //   }
    // } else {
    //   return Left(OfflineFailure());
    // }
    return await _getAllMessage(
      () {
        return userRemoteDataSours.UpdateUser(userModel);
      },
    );
  }

  Future<Either<Failure, Unit>> _getAllMessage(
      // Future<Unit> Function()
    DeletOrUpdateOrAddNotification   deletOrupdateOrAddNotification)
       async {
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
