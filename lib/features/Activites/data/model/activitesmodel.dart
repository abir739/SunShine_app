import 'package:json_annotation/json_annotation.dart';
import 'package:zenify_app/features/Activites/domain/entites/activite.dart';
import 'package:zenify_app/modele/activitsmodel/activityTempModel.dart';
import 'package:zenify_app/modele/agance.dart';

part 'activitesmodel.g.dart';

@JsonSerializable()
class ActivityModel extends Activite {
  String? id;
  String? name;
  String? agencyId;
  String? logo;
  String? activityTemplateId;
  String? touristGuideId;
  DateTime? departureDate;
  String? departureNote;
  DateTime? returnDate;

  // bool isFavorite;
  String? returnNote;
  String? reference;
  bool? confirmed;
  double? adultPrice;
  double? childPrice;
  double? babyPrice;
  String? currency;
  int? placesCount;
  String? parentActivityId;
  String? creatorUserId;
  DateTime? createdAt;
  String? updaterUserId;
  DateTime? updatedAt;
  String? deletedAt;
  Agency? agency;
  ActivityTemplate? activityTemplate;
  // TouristGuide? touristGuide;
//  List<String>? plannings;
  //  List<String>? touristGroups;
  List<String>? images;
  String? primaryColor;
  String? secondaryColor;
  ActivityModel(
      {this.primaryColor,
      this.secondaryColor,
      this.id,
      this.images,
      this.agencyId,
      this.activityTemplateId,
      this.touristGuideId,
      this.departureDate,
      this.departureNote,
      this.returnDate,
      this.returnNote,
      this.reference,
      this.confirmed,
      this.adultPrice,
      this.childPrice,
      this.babyPrice,
      this.currency,
      this.placesCount,
      this.parentActivityId,
      this.creatorUserId,
      this.createdAt,
      this.updaterUserId,
      this.updatedAt,
      this.deletedAt,
      this.name,
      this.agency,
      this.activityTemplate,
      //  this.touristGuide,
// this.plannings,
      //  this.touristGroups,
      this.logo
// this.isFavorite = false,
      });
  factory ActivityModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityModelFromJson(json);
  Map<String, dynamic> toJson() => _$ActivityModelToJson(this);
}
