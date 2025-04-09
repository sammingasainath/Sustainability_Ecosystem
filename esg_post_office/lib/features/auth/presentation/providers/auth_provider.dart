import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:esg_post_office/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:esg_post_office/features/auth/domain/models/user_model.dart';
import 'package:esg_post_office/features/auth/domain/repositories/auth_repository.dart';
import 'package:esg_post_office/core/providers/navigation_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository();
});

final authStateProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
  return AuthNotifier(ref);
});

class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final Ref _ref;
  late final AuthRepository _authRepository;

  AuthNotifier(this._ref) : super(const AsyncValue.loading()) {
    _authRepository = _ref.read(authRepositoryProvider);
    _init();
  }

  Future<void> _init() async {
    try {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        _ref.read(bottomNavVisibilityProvider.notifier).show();
      } else {
        _ref.read(bottomNavVisibilityProvider.notifier).hide();
        _ref.read(navigationProvider.notifier).reset();
      }
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String mobile,
    required String postOfficeId,
    required String pincode,
    required String password,
  }) async {
    try {
      state = const AsyncValue.loading();
      final user = await _authRepository.signUp(
        name: name,
        email: email,
        mobile: mobile,
        postOfficeId: postOfficeId,
        pincode: pincode,
        password: password,
      );
      _ref.read(bottomNavVisibilityProvider.notifier).show();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      state = const AsyncValue.loading();
      final user = await _authRepository.signIn(
        email: email,
        password: password,
      );
      _ref.read(bottomNavVisibilityProvider.notifier).show();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
      _ref.read(bottomNavVisibilityProvider.notifier).hide();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

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
      state = const AsyncValue.loading();
      await _authRepository.updateUserProfile(
        userId: userId,
        isEmployee: isEmployee,
        employeeRole: employeeRole,
        gender: gender,
        isPhysicallyChallenged: isPhysicallyChallenged,
        casteCategory: casteCategory,
        employmentType: employmentType,
        vendorName: vendorName,
        responsibilities: responsibilities,
        homeLatitude: homeLatitude,
        homeLongitude: homeLongitude,
        distanceToOffice: distanceToOffice,
        vehicleMileage: vehicleMileage,
        vehicleType: vehicleType,
      );
      final user = await _authRepository.getCurrentUser();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}
