import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_info.freezed.dart';
part 'device_info.g.dart';

@freezed
class DeviceInfo with _$DeviceInfo {
  const factory DeviceInfo({
    @JsonKey(name: 'device_name') required String deviceName,
    @JsonKey(name: 'device_id') required String deviceId,
    @JsonKey(name: 'webhook_url') required String webhookUrl,
    @JsonKey(name: 'wattage') required num wattage,
  }) = _DeviceInfo;

  factory DeviceInfo.fromJson(Map<String, dynamic> json) =>
      _$DeviceInfoFromJson(json);
}
