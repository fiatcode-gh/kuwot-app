import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kuwot/features/quote/data/models/image_model.dart';

part 'background_image.freezed.dart';

@freezed
abstract class BackgroundImage with _$BackgroundImage {
  const BackgroundImage._();

  const factory BackgroundImage({
    required String id,
    required String description,
    required String color,
    required String blurHash,
    required String url,
    required String originUrl,
    required String authorName,
    required String authorProfileImageUrl,
    required String authorUrl,
    required String authorBio,
    required String authorLocation,
    required int authorTotalLikes,
    required int authorTotalPhotos,
    required bool authorIsForHire,
  }) = _BackgroundImage;

  static List<BackgroundImage> fromModels(List<ImageModel> images) {
    return images
        .map(
          (e) => BackgroundImage(
            id: e.id,
            description: e.description,
            color: e.color,
            blurHash: e.blurHash,
            url: e.url,
            originUrl: e.originUrl,
            authorUrl: e.authorUrl,
            authorName: e.authorName,
            authorProfileImageUrl: e.authorProfileImageUrl,
            authorBio: e.authorBio,
            authorLocation: e.authorLocation,
            authorTotalLikes: e.authorTotalLikes,
            authorTotalPhotos: e.authorTotalPhotos,
            authorIsForHire: e.authorIsForHire,
          ),
        )
        .toList();
  }
}
