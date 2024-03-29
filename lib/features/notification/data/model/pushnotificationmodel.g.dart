// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pushnotificationmodel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      id: json['id'] as String?,
      title: json['title'] as String?,
      message: json['message'] as String?,
      type: json['type'] as String?,
      fk: json['fk'] as int?,
      category: json['category'] as String?,
      badge: json['badge'] as int?,
      sound: json['sound'] as String?,
      sending: json['sending'] as bool?,
      sendingTime: json['sendingTime'] == null
          ? null
          : DateTime.parse(json['sendingTime'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      creatorUserId: json['creatorUserId'] as String?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      updaterUserId: json['updaterUserId'] as String?,
            user: json['user'] == null
          ? null
          : User.fromJson(json['creatorUser'] as Map<String, dynamic>),
                    creatorUser: json['creatorUser'] == null
          ? null
          : CreatorUser.fromJson(json['creatorUser'] as Map<String, dynamic>),
          
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'message': instance.message,
      'type': instance.type,
      'fk': instance.fk,
      'category': instance.category,
      'badge': instance.badge,
      'sound': instance.sound,
      'sending': instance.sending,
      'sendingTime': instance.sendingTime?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'creatorUserId': instance.creatorUserId,
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'updaterUserId': instance.updaterUserId,    
      'user': instance.user,
      'creatorUser': instance.creatorUser,
    };
