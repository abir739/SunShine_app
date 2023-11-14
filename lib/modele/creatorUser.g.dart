// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'creatorUser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatorUser _$CreatorUserFromJson(Map<String, dynamic> json) => CreatorUser(
      id: json['id'] as String?,
      username: json['username'] as String?,   
       firstName: json['firstName'] as String?,
        picture: json['picture'] as String?,
       user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreatorUserToJson(CreatorUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'firstName': instance.firstName,
      'picture': instance.picture,
        'user': instance.user,
    };
