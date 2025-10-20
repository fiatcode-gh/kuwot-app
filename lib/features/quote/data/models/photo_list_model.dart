import 'package:freezed_annotation/freezed_annotation.dart';

part 'photo_list_model.freezed.dart';
part 'photo_list_model.g.dart';

@freezed
abstract class PhotoListModel with _$PhotoListModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory PhotoListModel({
    required int page,
    required int perPage,
    required List<PhotoModel> photos,
    required int totalResults,
    required String nextPage,
  }) = _PhotoListModel;

  factory PhotoListModel.fromJson(Map<String, dynamic> json) =>
      _$PhotoListModelFromJson(json);
}

@freezed
abstract class PhotoModel with _$PhotoModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory PhotoModel({
    required int id,
    required int width,
    required int height,
    required String url,
    required String photographer,
    required String photographerUrl,
    required int photographerId,
    required String avgColor,
    required SrcModel src,
    required bool liked,
    required String alt,
  }) = _PhotoModel;

  factory PhotoModel.fromJson(Map<String, dynamic> json) =>
      _$PhotoModelFromJson(json);
}

@freezed
abstract class SrcModel with _$SrcModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory SrcModel({
    required String original,
    required String large2x,
    required String large,
    required String medium,
    required String small,
    required String portrait,
    required String landscape,
    required String tiny,
  }) = _SrcModel;

  factory SrcModel.fromJson(Map<String, dynamic> json) =>
      _$SrcModelFromJson(json);
}
