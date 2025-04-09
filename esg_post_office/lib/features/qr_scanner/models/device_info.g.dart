// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DeviceInfoImpl _$$DeviceInfoImplFromJson(Map<String, dynamic> json) =>
    _$DeviceInfoImpl(
      deviceName: json['device_name'] as String,
      deviceId: json['device_id'] as String,
      webhookUrl: json['webhook_url'] as String,
      wattage: json['wattage'] as num,
    );

Map<String, dynamic> _$$DeviceInfoImplToJson(_$DeviceInfoImpl instance) =>
    <String, dynamic>{
      'device_name': instance.deviceName,
      'device_id': instance.deviceId,
      'webhook_url': instance.webhookUrl,
      'wattage': instance.wattage,
    };
