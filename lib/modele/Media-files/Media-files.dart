
import 'package:json_annotation/json_annotation.dart';

part 'Media-files.g.dart';
  @JsonSerializable()
class Media{

	String? id;
	String? agencyId;
	String? objectType;
	String? objectPrimaryKey;
	String? file;
	String? description;
	int? size;
	int? height;
	int? width;
	int? duration;
	int? position;
	bool? isMain;
	String? mimeType;
	String? type;
	bool? enabled;
	String? changeOptions;
	String? creatorUserId;
	String? createdAt;
	String? updaterUserId;
	String? updatedAt;

 Media({
  this.id,
  this.agencyId, 
  this.objectType, 
  this.objectPrimaryKey, 
  this.file, 
  this.description, 
  this.size, 
  this.height, 
  this.width, 
  this.duration, 
  this.position, 
  this.isMain, 
  this.mimeType, 
  this.type, 
  this.enabled, 
  this.changeOptions, 
  this.creatorUserId, 
  this.createdAt, 
  this.updaterUserId, 
  this.updatedAt});

  factory Media.fromJson(Map<String, dynamic> json) =>
      _$MediaFromJson(json);
  Map<String, dynamic> toJson() => _$MediaToJson(this);
}
