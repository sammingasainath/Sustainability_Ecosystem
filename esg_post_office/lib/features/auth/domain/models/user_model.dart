import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String name,
    required String email,
    required String mobile,
    required String postOfficeId,
    required String pincode,
    @Default(false) bool isEmployee,
    @Default(false) bool isProfileComplete,
    @Default(0) double carbonCredits,
    String? employeeRole,
    String? gender,
    bool? isPhysicallyChallenged,
    String? casteCategory,
    String? employmentType,
    String? vendorName,
    List<String>? responsibilities,
    double? homeLatitude,
    double? homeLongitude,
    double? distanceToOffice,
    double? vehicleMileage,
    String? vehicleType,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
