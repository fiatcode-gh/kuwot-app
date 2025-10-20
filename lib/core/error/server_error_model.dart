import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_error_model.freezed.dart';
part 'server_error_model.g.dart';

@freezed
abstract class ServerErrorModel with _$ServerErrorModel {
  const factory ServerErrorModel({required String message, required int code}) =
      _ServerErrorModel;

  factory ServerErrorModel.fromJson(Map<String, dynamic> json) =>
      _$ServerErrorModelFromJson(json);
}
