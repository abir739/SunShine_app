
import 'package:json_annotation/json_annotation.dart';

part 'agance.g.dart';
  @JsonSerializable()
class Agency {

  final String? id;
  final String? name;
  final String? fullName;
  final String? logo;
  final String? primaryColor;
  final String? secondaryColor;
  final String? subDomain;
  final bool? enabled;
  final String? email;
  final String? website;
  final String? phone;
  final String? fax;
  final String? managerName;
  final String? mobile;
  final String? address;
  final String? coordinates;
  final String? zipCode;
  final String? countryId;
  final String? stateId;
  final String? cityId;
  final String? creatorUserId;
  final DateTime? createdAt;
  final String? updaterUserId;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  Agency({
     this.id,
     this.name,
     this.fullName,
     this.logo,
     this.primaryColor,
     this.secondaryColor,
     this.subDomain,
     this.enabled,
     this.email,
     this.website,
     this.phone,
     this.fax,
     this.managerName,
     this.mobile,

     this.address,
     this.coordinates,
     this.zipCode,
     this.countryId,
     this.stateId,
     this.cityId,
     this.creatorUserId,
     this.createdAt,
     this.updaterUserId,
     this.updatedAt,
     this.deletedAt,
  });
  factory Agency.fromJson(Map<String, dynamic> json) =>
      _$AgencyFromJson(json);
  Map<String, dynamic> toJson() => _$AgencyToJson(this);
}
