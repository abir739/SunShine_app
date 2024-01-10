import 'package:equatable/equatable.dart';
import 'package:SunShine/modele/activitsmodel/usersmodel.dart';
import 'package:SunShine/modele/creatorUser.dart';

class Notification extends Equatable {
  final String? id;
  final String? title;
  final String? message;
  final String? type;
  final int? fk;
  final String? category;
  final int? badge;
  final String? sound;
  final bool? sending;
  final CreatorUser? creatorUser;
  final DateTime? sendingTime;
  final DateTime? createdAt;
  final String? creatorUserId;
  final String? firstName;
  final String? picture;
  final DateTime? updatedAt;
  final String? updaterUserId;
  final User? user;
  Notification(
      {this.id,
      this.title,
      this.message,
      this.type,
      this.fk,
      this.category,
      this.badge,
      this.sound,
      this.sending,
      this.creatorUser,
      this.sendingTime,
      this.createdAt,
      this.creatorUserId,
      this.firstName,
      this.picture,
      this.updatedAt,
      this.updaterUserId,
      this.user});
  @override
  List<Object?> get props => [
        user,
        updaterUserId,
        updatedAt,
        picture,
        firstName,
        creatorUserId,
        createdAt,
        sendingTime,
        creatorUser,
        sending,
        sound,
        badge,
        category,
        fk,
        type,
        message,
        title,
        id
      ];
}
