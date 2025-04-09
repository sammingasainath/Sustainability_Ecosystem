import 'package:esg_post_office/features/auth/domain/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String mobile,
    required String postOfficeId,
    required String pincode,
    required String password,
  });

  Future<UserModel> signIn({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<UserModel?> getCurrentUser();

  Future<void> updateUserProfile({
    required String userId,
    required bool isEmployee,
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
  });
}
