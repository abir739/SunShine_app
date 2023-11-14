import 'package:json_annotation/json_annotation.dart';
import 'package:zenify_app/modele/activitsmodel/usersmodel.dart';

part 'creatorUser.g.dart';

@JsonSerializable()
class CreatorUser {
  String? id;
  String? username;
  String? firstName;
  String? picture;
  User? user;
  CreatorUser({
    this.id,
    this.username,this.user, this.picture,this.firstName,
  });

  factory CreatorUser.fromJson(Map<String, dynamic> json) =>
      _$CreatorUserFromJson(json);
  Map<String, dynamic> toJson() => _$CreatorUserToJson(this);
}
