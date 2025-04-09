// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'walk_activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalkActivityImpl _$$WalkActivityImplFromJson(Map<String, dynamic> json) =>
    _$WalkActivityImpl(
      steps: (json['steps'] as num).toInt(),
      distance: (json['distance'] as num).toDouble(),
      carbonCredits: (json['carbonCredits'] as num).toDouble(),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
    );

Map<String, dynamic> _$$WalkActivityImplToJson(_$WalkActivityImpl instance) =>
    <String, dynamic>{
      'steps': instance.steps,
      'distance': instance.distance,
      'carbonCredits': instance.carbonCredits,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
    };
