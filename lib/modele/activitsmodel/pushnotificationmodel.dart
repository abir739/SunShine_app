import 'package:json_annotation/json_annotation.dart';
import 'package:SunShine/modele/activitsmodel/usersmodel.dart';
import 'package:SunShine/modele/creatorUser.dart';

// import '../activity_model.dart';
part 'pushnotificationmodel.g.dart';

@JsonSerializable()
class PushNotification {
  PushNotification(
      {this.id,
      this.title,
      this.message,
      this.type,
      this.fk,
      this.category,
      this.badge,
      this.sound,
      this.sending,
      this.sendingTime,
      this.createdAt,
      this.creatorUserId,
      this.creatorUser,
      this.updatedAt,
      this.updaterUserId,
      this.user});

  String? id;

  String? title;

  String? message;

  String? type;

  int? fk;

  String? category;

  int? badge;

  String? sound;

  bool? sending;
  CreatorUser? creatorUser;

  DateTime? sendingTime;

  DateTime? createdAt;

  String? creatorUserId;
  String? firstName;
  String? picture;

  DateTime? updatedAt;

  String? updaterUserId;
  User? user;

  factory PushNotification.fromJson(Map<String, dynamic> json) =>
      _$PushNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$PushNotificationToJson(this);
}
