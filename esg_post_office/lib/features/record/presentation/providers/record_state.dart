import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'record_state.freezed.dart';
part 'record_state.g.dart';

@freezed
class BillState with _$BillState {
  const factory BillState({
    @Default(false) bool isProcessing,
    @Default(false) bool isUploading,
    @Default(false) bool isSubmitting,
    @Default(null) Map<String, dynamic>? billData,
    @Default(null) String? error,
  }) = _BillState;

  const BillState._();

  factory BillState.fromJson(Map<String, dynamic> json) => 
      _$BillStateFromJson(json);

  bool get canSubmit => 
    billData != null && 
    !isProcessing && 
    !isUploading && 
    !isSubmitting;
}

class BillStateNotifier extends StateNotifier<BillState> {
  BillStateNotifier() : super(const BillState());

  void setLoading(bool loading) {
    state = state.copyWith(isProcessing: loading);
  }

  void setUploading(bool uploading) {
    state = state.copyWith(isUploading: uploading);
  }

  void setSubmitting(bool submitting) {
    state = state.copyWith(isSubmitting: submitting);
  }

  void setBillData(Map<String, dynamic>? data) {
    state = state.copyWith(
      billData: data,
      error: null,
      isProcessing: false,
      isUploading: false,
      isSubmitting: false,
    );
  }

  void setError(String? error) {
    state = state.copyWith(
      error: error,
      billData: null,
      isProcessing: false,
      isUploading: false,
      isSubmitting: false,
    );
  }

  void reset() {
    state = const BillState();
  }
}

final electricityBillProvider =
    StateNotifierProvider<BillStateNotifier, BillState>((ref) {
  return BillStateNotifier();
});

final waterBillProvider =
    StateNotifierProvider<BillStateNotifier, BillState>((ref) {
  return BillStateNotifier();
});

final fuelBillProvider =
    StateNotifierProvider<BillStateNotifier, BillState>((ref) {
  return BillStateNotifier();
});
