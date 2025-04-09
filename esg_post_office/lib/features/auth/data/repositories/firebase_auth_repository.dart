import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:esg_post_office/features/auth/domain/models/user_model.dart';
import 'package:esg_post_office/features/auth/domain/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String mobile,
    required String postOfficeId,
    required String pincode,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = UserModel(
        id: userCredential.user!.uid,
        name: name,
        email: email,
        mobile: mobile,
        postOfficeId: postOfficeId,
        pincode: pincode,
      );

      await _firestore.collection('users').doc(user.id).set(user.toJson());
      return user;
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      return UserModel.fromJson(userDoc.data()!);
    } catch (e) {
      throw Exception('Failed to sign in: $e');
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    if (!userDoc.exists) return null;

    return UserModel.fromJson(userDoc.data()!);
  }

  @override
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
  }) async {
    try {
      final updates = {
        'isEmployee': isEmployee,
        'isProfileComplete': true,
        if (employeeRole != null) 'employeeRole': employeeRole,
        if (gender != null) 'gender': gender,
        if (isPhysicallyChallenged != null)
          'isPhysicallyChallenged': isPhysicallyChallenged,
        if (casteCategory != null) 'casteCategory': casteCategory,
        if (employmentType != null) 'employmentType': employmentType,
        if (vendorName != null) 'vendorName': vendorName,
        if (responsibilities != null) 'responsibilities': responsibilities,
        if (homeLatitude != null) 'homeLatitude': homeLatitude,
        if (homeLongitude != null) 'homeLongitude': homeLongitude,
        if (distanceToOffice != null) 'distanceToOffice': distanceToOffice,
        if (vehicleMileage != null) 'vehicleMileage': vehicleMileage,
        if (vehicleType != null) 'vehicleType': vehicleType,
      };

      await _firestore.collection('users').doc(userId).update(updates);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }
}
