// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_error_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ServerErrorModel _$ServerErrorModelFromJson(Map<String, dynamic> json) =>
    _ServerErrorModel(
      message: json['message'] as String,
      code: (json['code'] as num).toInt(),
    );

Map<String, dynamic> _$ServerErrorModelToJson(_ServerErrorModel instance) =>
    <String, dynamic>{'message': instance.message, 'code': instance.code};
