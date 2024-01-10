import 'package:json_annotation/json_annotation.dart';
import 'package:SunShine/modele/creatorUser.dart';
import 'package:SunShine/modele/touristGroup.dart';

import '../activitsmodel/usersmodel.dart';

part 'TravellerModel.g.dart';

@JsonSerializable()
class Traveller {
  String? id;
  String? title;
  String? code;
  String? userId;
  String? touristGroupId;
  User? user;

  bool? hasPartner;
  TouristGroup? touristGroup;
  Traveller(
      {this.id,
      this.code,
      this.title,
      this.userId,
      this.hasPartner,
      this.touristGroupId,
      this.user,
      this.touristGroup});

  factory Traveller.fromJson(Map<String, dynamic> json) =>
      _$TravellerFromJson(json);
  Map<String, dynamic> toJson() => _$TravellerToJson(this);
}
