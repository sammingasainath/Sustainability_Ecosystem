// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BillStateImpl _$$BillStateImplFromJson(Map<String, dynamic> json) =>
    _$BillStateImpl(
      isProcessing: json['isProcessing'] as bool? ?? false,
      isUploading: json['isUploading'] as bool? ?? false,
      isSubmitting: json['isSubmitting'] as bool? ?? false,
      billData: json['billData'] as Map<String, dynamic>? ?? null,
      error: json['error'] as String? ?? null,
    );

Map<String, dynamic> _$$BillStateImplToJson(_$BillStateImpl instance) =>
    <String, dynamic>{
      'isProcessing': instance.isProcessing,
      'isUploading': instance.isUploading,
      'isSubmitting': instance.isSubmitting,
      'billData': instance.billData,
      'error': instance.error,
    };
