import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/device_info.dart';

part 'qr_scanner_provider.g.dart';

@riverpod
class QRScannerNotifier extends _$QRScannerNotifier {
  @override
  DeviceInfo? build() => null;

  void updateScannedDevice(DeviceInfo deviceInfo) {
    state = deviceInfo;
  }

  void clearScannedDevice() {
    state = null;
  }
} 