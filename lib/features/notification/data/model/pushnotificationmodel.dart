import 'package:json_annotation/json_annotation.dart';
import 'package:zenify_app/features/notification/domain/entites/notification.dart';
import 'package:zenify_app/modele/activitsmodel/usersmodel.dart';
import 'package:zenify_app/modele/creatorUser.dart';

// import '../activity_model.dart';
part 'pushnotificationmodel.g.dart';
@JsonSerializable()
class NotificationModel extends Notification{
  
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
NotificationModel({
    this.id,
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
    this.updaterUserId,this.user
   
  });
factory NotificationModel.fromJson(Map<String, dynamic> json) =>

      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

}
