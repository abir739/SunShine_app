import 'package:equatable/equatable.dart';
import 'package:zenify_app/modele/activitsmodel/activityTempModel.dart';
import 'package:zenify_app/modele/agance.dart';

class Activite extends Equatable {
  final String? id;
  final String? name;
  final String? agencyId;
  final String? logo;
  final String? activityTemplateId;
  final String? touristGuideId;
  final DateTime? departureDate;
  final String? departureNote;
  final DateTime? returnDate;

  // bool isFavorite;
  final String? returnNote;
  final String? reference;
  final bool? confirmed;
  final double? adultPrice;
  final double? childPrice;
  final double? babyPrice;
  final String? currency;
  final int? placesCount;
  final String? parentActivityId;
  final String? creatorUserId;
  final DateTime? createdAt;
  final String? updaterUserId;
  final DateTime? updatedAt;
  final String? deletedAt;
  final Agency? agency;
  final ActivityTemplate? activityTemplate;
  // TouristGuide? touristGuide;
//  List<String>? plannings;
  //  List<String>? touristGroups;
  List<String>? images;
  String? primaryColor;
  String? secondaryColor;

  Activite(
      { this.id,
       this.name,
       this.agencyId,
       this.logo,
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
       this.agency,
       this.activityTemplate});
  @override
  // TODO: implement props
  List<Object?> get props => [id, name,activityTemplate,agency,deletedAt
  ,updaterUserId,createdAt,creatorUserId,parentActivityId,placesCount,
 currency,babyPrice,childPrice,confirmed,reference,returnNote,
  returnDate,departureNote,departureDate,touristGuideId,activityTemplateId,logo,agencyId];
}
