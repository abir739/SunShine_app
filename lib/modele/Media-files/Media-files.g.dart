// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Media-files.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Media _$MediaFromJson(Map<String, dynamic> json) => Media(
      id: json['id'] as String?,
      agencyId: json['agencyId'] as String?,
      objectType: json['objectType'] as String?,
      objectPrimaryKey: json['objectPrimaryKey'] as String?,
      file: json['file'] as String?,
      description: json['description'] as String?,
      size: json['size'] as int?,
      enabled: json['enabled'] as bool?,
      height: json['height'] as int?,
      width: json['width'] as int?,
      duration: json['duration'] as int?,
      position: json['position'] as int?,
      isMain: json['isMain'] as bool?,
      mimeType: json['mimeType'] as String?,
      type: json['type'] as String?,
      changeOptions: json['changeOptions'] as String?,
      creatorUserId: json['creatorUserId'] as String?,
    );

Map<String, dynamic> _$MediaToJson(Media instance) => <String, dynamic>{
      'id': instance.id,
      'agencyId': instance.agencyId,
      'objectType': instance.objectType,
      'objectPrimaryKey': instance.objectPrimaryKey,
      'file': instance.file,
      'description': instance.description,
      'size': instance.size,
      'enabled': instance.enabled,
      'height': instance.height,
      'width': instance.width,
      'duration': instance.duration,
      'position': instance.position,
      'isMain': instance.isMain,
      'mimeType': instance.mimeType,
      'type': instance.type,
      'changeOptions': instance.changeOptions,
      'creatorUserId': instance.creatorUserId,
      'updaterUserId': instance.updaterUserId,
    };
