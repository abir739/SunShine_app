import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? id;
   final String? role;
 final String? username;
 final String? password;
 final String? salt;
 final String? logo;
 final String? phone;
 final String? email;
 final String? gender;
 final String? firstName;
 final String? lastName;
 final DateTime? birthDate;
 final String? picture;
 final String? address;
 final String? zipCode;
 final String? countryId;
 final String? stateId;
 final String? cityId;
 final String? languageId;
 final String? secondLanguageId;
 final String? facebookKey;
 final String? profile;
 final bool? enableOauth;
final  int? sessionTimeout;
 final bool? multipleSession;
 final bool? phoneValidated;
 final String? phoneValidationCode;
 final bool? emailValidated;
 final String? emailValidationCode;
 final String? authenticationMode;
 final bool? enabled;
 final String? confirmationToken;
 final DateTime? passwordRequestedAt;
 final bool? locked;
 final bool? expired;
 final DateTime? expiresAt;
 final bool? credentialsExpired;
 final DateTime? credentialsExpireAt;
 final DateTime? lastLogin;
 final DateTime? lastFailedLogin;
  final int? loginCount;
final  int? failedLoginCount;
 final int? lastFailedLoginCount;
 final DateTime? createdAt;
 final String? creatorUserId;
final  DateTime? updatedAt;
 final String? updaterUserId;

  User({this.id, this.role, this.username, this.password, this.salt, this.logo, this.phone, this.email, this.gender, this.firstName, this.lastName, this.birthDate, this.picture, this.address, this.zipCode, this.countryId, this.stateId, this.cityId, this.languageId, this.secondLanguageId, this.facebookKey, this.profile, this.enableOauth, this.sessionTimeout, this.multipleSession, this.phoneValidated, this.phoneValidationCode, this.emailValidated, this.emailValidationCode, this.authenticationMode, this.enabled, this.confirmationToken, this.passwordRequestedAt, this.locked, this.expired, this.expiresAt, this.credentialsExpired, this.credentialsExpireAt, this.lastLogin, this.lastFailedLogin, this.loginCount, this.failedLoginCount, this.lastFailedLoginCount, this.createdAt, this.creatorUserId, this.updatedAt, this.updaterUserId});
  
  List<Object?> get props => [id,role,username,password,salt,logo,phone,email,gender,firstName,lastName,languageId,birthDate,picture,address,zipCode,countryId,stateId,cityId,facebookKey,profile,enableOauth,confirmationToken,];
}
