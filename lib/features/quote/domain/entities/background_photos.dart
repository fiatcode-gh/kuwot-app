import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kuwot/features/quote/data/models/photo_list_model.dart';

part 'background_photos.freezed.dart';

@freezed
abstract class BackgroundPhotos with _$BackgroundPhotos {
  const factory BackgroundPhotos({required List<Photo> photos}) =
      _BackgroundPhotos;

  static BackgroundPhotos fromModel(PhotoListModel model) => BackgroundPhotos(
    photos: model.photos.map<Photo>((e) {
      return Photo(
        url: buildPortraitImageUrl(e.src.original),
        avgColor: e.avgColor,
      );
    }).toList(),
  );

  static String buildPortraitImageUrl(String originalUrl) =>
      '$originalUrl?auto=compress&cs=tinysrgb&fit=crop&h=2400&w=1200';
}

@freezed
abstract class Photo with _$Photo {
  const factory Photo({required String url, required String avgColor}) =
      _BackgroundImage;
}
