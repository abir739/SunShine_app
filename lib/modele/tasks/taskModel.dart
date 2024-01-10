import 'package:json_annotation/json_annotation.dart';
import 'package:SunShine/modele/agance.dart';

part 'taskModel.g.dart';

@JsonSerializable()
class Tasks {
  String? id;
  String? agencyId;
  String? touristGuideId;
  DateTime? todoDate;
  String? description;
  String? creatorUserId;
  String? createdAt;
  Agency? agency;

  Tasks({
    this.id,
    this.agencyId,
    this.touristGuideId,
    this.todoDate,
    this.description,
    this.creatorUserId,
    this.createdAt,
    this.agency,
  });

  factory Tasks.fromJson(Map<String, dynamic> json) => _$TasksFromJson(json);
  Map<String, dynamic> toJson() => _$TasksToJson(this);
}
