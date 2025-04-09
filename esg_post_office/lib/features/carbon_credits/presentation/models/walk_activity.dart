import 'package:freezed_annotation/freezed_annotation.dart';

part 'walk_activity.freezed.dart';
part 'walk_activity.g.dart';

@freezed
class WalkActivity with _$WalkActivity {
  const factory WalkActivity({
    required int steps,
    required double distance,
    required double carbonCredits,
    required DateTime startTime,
    required DateTime? endTime,
  }) = _WalkActivity;

  factory WalkActivity.fromJson(Map<String, dynamic> json) =>
      _$WalkActivityFromJson(json);
} 