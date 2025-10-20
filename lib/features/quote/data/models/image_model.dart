import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_model.freezed.dart';
part 'image_model.g.dart';

@freezed
abstract class ImageModel with _$ImageModel {
  const factory ImageModel({
    required String id,
    required String description,
    required String color,
    required String blurHash,
    required String url,
    required String originUrl,
    required String authorName,
    required String authorBio,
    required String authorLocation,
    required int authorTotalLikes,
    required int authorTotalPhotos,
    required bool authorIsForHire,
    required String authorProfileImageUrl,
    required String authorUrl,
  }) = _ImageModel;

  factory ImageModel.fromJson(Map<String, dynamic> json) =>
      _$ImageModelFromJson(json);
}
