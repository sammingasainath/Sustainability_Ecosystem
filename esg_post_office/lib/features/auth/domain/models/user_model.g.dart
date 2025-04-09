// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      mobile: json['mobile'] as String,
      postOfficeId: json['postOfficeId'] as String,
      pincode: json['pincode'] as String,
      isEmployee: json['isEmployee'] as bool? ?? false,
      isProfileComplete: json['isProfileComplete'] as bool? ?? false,
      carbonCredits: (json['carbonCredits'] as num?)?.toDouble() ?? 0,
      employeeRole: json['employeeRole'] as String?,
      gender: json['gender'] as String?,
      isPhysicallyChallenged: json['isPhysicallyChallenged'] as bool?,
      casteCategory: json['casteCategory'] as String?,
      employmentType: json['employmentType'] as String?,
      vendorName: json['vendorName'] as String?,
      responsibilities: (json['responsibilities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      homeLatitude: (json['homeLatitude'] as num?)?.toDouble(),
      homeLongitude: (json['homeLongitude'] as num?)?.toDouble(),
      distanceToOffice: (json['distanceToOffice'] as num?)?.toDouble(),
      vehicleMileage: (json['vehicleMileage'] as num?)?.toDouble(),
      vehicleType: json['vehicleType'] as String?,
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'mobile': instance.mobile,
      'postOfficeId': instance.postOfficeId,
      'pincode': instance.pincode,
      'isEmployee': instance.isEmployee,
      'isProfileComplete': instance.isProfileComplete,
      'carbonCredits': instance.carbonCredits,
      'employeeRole': instance.employeeRole,
      'gender': instance.gender,
      'isPhysicallyChallenged': instance.isPhysicallyChallenged,
      'casteCategory': instance.casteCategory,
      'employmentType': instance.employmentType,
      'vendorName': instance.vendorName,
      'responsibilities': instance.responsibilities,
      'homeLatitude': instance.homeLatitude,
      'homeLongitude': instance.homeLongitude,
      'distanceToOffice': instance.distanceToOffice,
      'vehicleMileage': instance.vehicleMileage,
      'vehicleType': instance.vehicleType,
    };
