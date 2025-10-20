// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ImageModel {

 String get id; String get description; String get color; String get blurHash; String get url; String get originUrl; String get authorName; String get authorBio; String get authorLocation; int get authorTotalLikes; int get authorTotalPhotos; bool get authorIsForHire; String get authorProfileImageUrl; String get authorUrl;
/// Create a copy of ImageModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImageModelCopyWith<ImageModel> get copyWith => _$ImageModelCopyWithImpl<ImageModel>(this as ImageModel, _$identity);

  /// Serializes this ImageModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImageModel&&(identical(other.id, id) || other.id == id)&&(identical(other.description, description) || other.description == description)&&(identical(other.color, color) || other.color == color)&&(identical(other.blurHash, blurHash) || other.blurHash == blurHash)&&(identical(other.url, url) || other.url == url)&&(identical(other.originUrl, originUrl) || other.originUrl == originUrl)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.authorBio, authorBio) || other.authorBio == authorBio)&&(identical(other.authorLocation, authorLocation) || other.authorLocation == authorLocation)&&(identical(other.authorTotalLikes, authorTotalLikes) || other.authorTotalLikes == authorTotalLikes)&&(identical(other.authorTotalPhotos, authorTotalPhotos) || other.authorTotalPhotos == authorTotalPhotos)&&(identical(other.authorIsForHire, authorIsForHire) || other.authorIsForHire == authorIsForHire)&&(identical(other.authorProfileImageUrl, authorProfileImageUrl) || other.authorProfileImageUrl == authorProfileImageUrl)&&(identical(other.authorUrl, authorUrl) || other.authorUrl == authorUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,description,color,blurHash,url,originUrl,authorName,authorBio,authorLocation,authorTotalLikes,authorTotalPhotos,authorIsForHire,authorProfileImageUrl,authorUrl);

@override
String toString() {
  return 'ImageModel(id: $id, description: $description, color: $color, blurHash: $blurHash, url: $url, originUrl: $originUrl, authorName: $authorName, authorBio: $authorBio, authorLocation: $authorLocation, authorTotalLikes: $authorTotalLikes, authorTotalPhotos: $authorTotalPhotos, authorIsForHire: $authorIsForHire, authorProfileImageUrl: $authorProfileImageUrl, authorUrl: $authorUrl)';
}


}

/// @nodoc
abstract mixin class $ImageModelCopyWith<$Res>  {
  factory $ImageModelCopyWith(ImageModel value, $Res Function(ImageModel) _then) = _$ImageModelCopyWithImpl;
@useResult
$Res call({
 String id, String description, String color, String blurHash, String url, String originUrl, String authorName, String authorBio, String authorLocation, int authorTotalLikes, int authorTotalPhotos, bool authorIsForHire, String authorProfileImageUrl, String authorUrl
});




}
/// @nodoc
class _$ImageModelCopyWithImpl<$Res>
    implements $ImageModelCopyWith<$Res> {
  _$ImageModelCopyWithImpl(this._self, this._then);

  final ImageModel _self;
  final $Res Function(ImageModel) _then;

/// Create a copy of ImageModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? description = null,Object? color = null,Object? blurHash = null,Object? url = null,Object? originUrl = null,Object? authorName = null,Object? authorBio = null,Object? authorLocation = null,Object? authorTotalLikes = null,Object? authorTotalPhotos = null,Object? authorIsForHire = null,Object? authorProfileImageUrl = null,Object? authorUrl = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,blurHash: null == blurHash ? _self.blurHash : blurHash // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,originUrl: null == originUrl ? _self.originUrl : originUrl // ignore: cast_nullable_to_non_nullable
as String,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,authorBio: null == authorBio ? _self.authorBio : authorBio // ignore: cast_nullable_to_non_nullable
as String,authorLocation: null == authorLocation ? _self.authorLocation : authorLocation // ignore: cast_nullable_to_non_nullable
as String,authorTotalLikes: null == authorTotalLikes ? _self.authorTotalLikes : authorTotalLikes // ignore: cast_nullable_to_non_nullable
as int,authorTotalPhotos: null == authorTotalPhotos ? _self.authorTotalPhotos : authorTotalPhotos // ignore: cast_nullable_to_non_nullable
as int,authorIsForHire: null == authorIsForHire ? _self.authorIsForHire : authorIsForHire // ignore: cast_nullable_to_non_nullable
as bool,authorProfileImageUrl: null == authorProfileImageUrl ? _self.authorProfileImageUrl : authorProfileImageUrl // ignore: cast_nullable_to_non_nullable
as String,authorUrl: null == authorUrl ? _self.authorUrl : authorUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ImageModel].
extension ImageModelPatterns on ImageModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImageModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImageModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImageModel value)  $default,){
final _that = this;
switch (_that) {
case _ImageModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImageModel value)?  $default,){
final _that = this;
switch (_that) {
case _ImageModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String description,  String color,  String blurHash,  String url,  String originUrl,  String authorName,  String authorBio,  String authorLocation,  int authorTotalLikes,  int authorTotalPhotos,  bool authorIsForHire,  String authorProfileImageUrl,  String authorUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImageModel() when $default != null:
return $default(_that.id,_that.description,_that.color,_that.blurHash,_that.url,_that.originUrl,_that.authorName,_that.authorBio,_that.authorLocation,_that.authorTotalLikes,_that.authorTotalPhotos,_that.authorIsForHire,_that.authorProfileImageUrl,_that.authorUrl);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String description,  String color,  String blurHash,  String url,  String originUrl,  String authorName,  String authorBio,  String authorLocation,  int authorTotalLikes,  int authorTotalPhotos,  bool authorIsForHire,  String authorProfileImageUrl,  String authorUrl)  $default,) {final _that = this;
switch (_that) {
case _ImageModel():
return $default(_that.id,_that.description,_that.color,_that.blurHash,_that.url,_that.originUrl,_that.authorName,_that.authorBio,_that.authorLocation,_that.authorTotalLikes,_that.authorTotalPhotos,_that.authorIsForHire,_that.authorProfileImageUrl,_that.authorUrl);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String description,  String color,  String blurHash,  String url,  String originUrl,  String authorName,  String authorBio,  String authorLocation,  int authorTotalLikes,  int authorTotalPhotos,  bool authorIsForHire,  String authorProfileImageUrl,  String authorUrl)?  $default,) {final _that = this;
switch (_that) {
case _ImageModel() when $default != null:
return $default(_that.id,_that.description,_that.color,_that.blurHash,_that.url,_that.originUrl,_that.authorName,_that.authorBio,_that.authorLocation,_that.authorTotalLikes,_that.authorTotalPhotos,_that.authorIsForHire,_that.authorProfileImageUrl,_that.authorUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ImageModel implements ImageModel {
  const _ImageModel({required this.id, required this.description, required this.color, required this.blurHash, required this.url, required this.originUrl, required this.authorName, required this.authorBio, required this.authorLocation, required this.authorTotalLikes, required this.authorTotalPhotos, required this.authorIsForHire, required this.authorProfileImageUrl, required this.authorUrl});
  factory _ImageModel.fromJson(Map<String, dynamic> json) => _$ImageModelFromJson(json);

@override final  String id;
@override final  String description;
@override final  String color;
@override final  String blurHash;
@override final  String url;
@override final  String originUrl;
@override final  String authorName;
@override final  String authorBio;
@override final  String authorLocation;
@override final  int authorTotalLikes;
@override final  int authorTotalPhotos;
@override final  bool authorIsForHire;
@override final  String authorProfileImageUrl;
@override final  String authorUrl;

/// Create a copy of ImageModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImageModelCopyWith<_ImageModel> get copyWith => __$ImageModelCopyWithImpl<_ImageModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ImageModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImageModel&&(identical(other.id, id) || other.id == id)&&(identical(other.description, description) || other.description == description)&&(identical(other.color, color) || other.color == color)&&(identical(other.blurHash, blurHash) || other.blurHash == blurHash)&&(identical(other.url, url) || other.url == url)&&(identical(other.originUrl, originUrl) || other.originUrl == originUrl)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.authorBio, authorBio) || other.authorBio == authorBio)&&(identical(other.authorLocation, authorLocation) || other.authorLocation == authorLocation)&&(identical(other.authorTotalLikes, authorTotalLikes) || other.authorTotalLikes == authorTotalLikes)&&(identical(other.authorTotalPhotos, authorTotalPhotos) || other.authorTotalPhotos == authorTotalPhotos)&&(identical(other.authorIsForHire, authorIsForHire) || other.authorIsForHire == authorIsForHire)&&(identical(other.authorProfileImageUrl, authorProfileImageUrl) || other.authorProfileImageUrl == authorProfileImageUrl)&&(identical(other.authorUrl, authorUrl) || other.authorUrl == authorUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,description,color,blurHash,url,originUrl,authorName,authorBio,authorLocation,authorTotalLikes,authorTotalPhotos,authorIsForHire,authorProfileImageUrl,authorUrl);

@override
String toString() {
  return 'ImageModel(id: $id, description: $description, color: $color, blurHash: $blurHash, url: $url, originUrl: $originUrl, authorName: $authorName, authorBio: $authorBio, authorLocation: $authorLocation, authorTotalLikes: $authorTotalLikes, authorTotalPhotos: $authorTotalPhotos, authorIsForHire: $authorIsForHire, authorProfileImageUrl: $authorProfileImageUrl, authorUrl: $authorUrl)';
}


}

/// @nodoc
abstract mixin class _$ImageModelCopyWith<$Res> implements $ImageModelCopyWith<$Res> {
  factory _$ImageModelCopyWith(_ImageModel value, $Res Function(_ImageModel) _then) = __$ImageModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String description, String color, String blurHash, String url, String originUrl, String authorName, String authorBio, String authorLocation, int authorTotalLikes, int authorTotalPhotos, bool authorIsForHire, String authorProfileImageUrl, String authorUrl
});




}
/// @nodoc
class __$ImageModelCopyWithImpl<$Res>
    implements _$ImageModelCopyWith<$Res> {
  __$ImageModelCopyWithImpl(this._self, this._then);

  final _ImageModel _self;
  final $Res Function(_ImageModel) _then;

/// Create a copy of ImageModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? description = null,Object? color = null,Object? blurHash = null,Object? url = null,Object? originUrl = null,Object? authorName = null,Object? authorBio = null,Object? authorLocation = null,Object? authorTotalLikes = null,Object? authorTotalPhotos = null,Object? authorIsForHire = null,Object? authorProfileImageUrl = null,Object? authorUrl = null,}) {
  return _then(_ImageModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,blurHash: null == blurHash ? _self.blurHash : blurHash // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,originUrl: null == originUrl ? _self.originUrl : originUrl // ignore: cast_nullable_to_non_nullable
as String,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,authorBio: null == authorBio ? _self.authorBio : authorBio // ignore: cast_nullable_to_non_nullable
as String,authorLocation: null == authorLocation ? _self.authorLocation : authorLocation // ignore: cast_nullable_to_non_nullable
as String,authorTotalLikes: null == authorTotalLikes ? _self.authorTotalLikes : authorTotalLikes // ignore: cast_nullable_to_non_nullable
as int,authorTotalPhotos: null == authorTotalPhotos ? _self.authorTotalPhotos : authorTotalPhotos // ignore: cast_nullable_to_non_nullable
as int,authorIsForHire: null == authorIsForHire ? _self.authorIsForHire : authorIsForHire // ignore: cast_nullable_to_non_nullable
as bool,authorProfileImageUrl: null == authorProfileImageUrl ? _self.authorProfileImageUrl : authorProfileImageUrl // ignore: cast_nullable_to_non_nullable
as String,authorUrl: null == authorUrl ? _self.authorUrl : authorUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
