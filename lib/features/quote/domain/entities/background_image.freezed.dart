// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'background_image.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BackgroundImage {

 String get id; String get description; String get color; String get blurHash; String get url; String get originUrl; String get authorName; String get authorProfileImageUrl; String get authorUrl; String get authorBio; String get authorLocation; int get authorTotalLikes; int get authorTotalPhotos; bool get authorIsForHire;
/// Create a copy of BackgroundImage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackgroundImageCopyWith<BackgroundImage> get copyWith => _$BackgroundImageCopyWithImpl<BackgroundImage>(this as BackgroundImage, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackgroundImage&&(identical(other.id, id) || other.id == id)&&(identical(other.description, description) || other.description == description)&&(identical(other.color, color) || other.color == color)&&(identical(other.blurHash, blurHash) || other.blurHash == blurHash)&&(identical(other.url, url) || other.url == url)&&(identical(other.originUrl, originUrl) || other.originUrl == originUrl)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.authorProfileImageUrl, authorProfileImageUrl) || other.authorProfileImageUrl == authorProfileImageUrl)&&(identical(other.authorUrl, authorUrl) || other.authorUrl == authorUrl)&&(identical(other.authorBio, authorBio) || other.authorBio == authorBio)&&(identical(other.authorLocation, authorLocation) || other.authorLocation == authorLocation)&&(identical(other.authorTotalLikes, authorTotalLikes) || other.authorTotalLikes == authorTotalLikes)&&(identical(other.authorTotalPhotos, authorTotalPhotos) || other.authorTotalPhotos == authorTotalPhotos)&&(identical(other.authorIsForHire, authorIsForHire) || other.authorIsForHire == authorIsForHire));
}


@override
int get hashCode => Object.hash(runtimeType,id,description,color,blurHash,url,originUrl,authorName,authorProfileImageUrl,authorUrl,authorBio,authorLocation,authorTotalLikes,authorTotalPhotos,authorIsForHire);

@override
String toString() {
  return 'BackgroundImage(id: $id, description: $description, color: $color, blurHash: $blurHash, url: $url, originUrl: $originUrl, authorName: $authorName, authorProfileImageUrl: $authorProfileImageUrl, authorUrl: $authorUrl, authorBio: $authorBio, authorLocation: $authorLocation, authorTotalLikes: $authorTotalLikes, authorTotalPhotos: $authorTotalPhotos, authorIsForHire: $authorIsForHire)';
}


}

/// @nodoc
abstract mixin class $BackgroundImageCopyWith<$Res>  {
  factory $BackgroundImageCopyWith(BackgroundImage value, $Res Function(BackgroundImage) _then) = _$BackgroundImageCopyWithImpl;
@useResult
$Res call({
 String id, String description, String color, String blurHash, String url, String originUrl, String authorName, String authorProfileImageUrl, String authorUrl, String authorBio, String authorLocation, int authorTotalLikes, int authorTotalPhotos, bool authorIsForHire
});




}
/// @nodoc
class _$BackgroundImageCopyWithImpl<$Res>
    implements $BackgroundImageCopyWith<$Res> {
  _$BackgroundImageCopyWithImpl(this._self, this._then);

  final BackgroundImage _self;
  final $Res Function(BackgroundImage) _then;

/// Create a copy of BackgroundImage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? description = null,Object? color = null,Object? blurHash = null,Object? url = null,Object? originUrl = null,Object? authorName = null,Object? authorProfileImageUrl = null,Object? authorUrl = null,Object? authorBio = null,Object? authorLocation = null,Object? authorTotalLikes = null,Object? authorTotalPhotos = null,Object? authorIsForHire = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,blurHash: null == blurHash ? _self.blurHash : blurHash // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,originUrl: null == originUrl ? _self.originUrl : originUrl // ignore: cast_nullable_to_non_nullable
as String,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,authorProfileImageUrl: null == authorProfileImageUrl ? _self.authorProfileImageUrl : authorProfileImageUrl // ignore: cast_nullable_to_non_nullable
as String,authorUrl: null == authorUrl ? _self.authorUrl : authorUrl // ignore: cast_nullable_to_non_nullable
as String,authorBio: null == authorBio ? _self.authorBio : authorBio // ignore: cast_nullable_to_non_nullable
as String,authorLocation: null == authorLocation ? _self.authorLocation : authorLocation // ignore: cast_nullable_to_non_nullable
as String,authorTotalLikes: null == authorTotalLikes ? _self.authorTotalLikes : authorTotalLikes // ignore: cast_nullable_to_non_nullable
as int,authorTotalPhotos: null == authorTotalPhotos ? _self.authorTotalPhotos : authorTotalPhotos // ignore: cast_nullable_to_non_nullable
as int,authorIsForHire: null == authorIsForHire ? _self.authorIsForHire : authorIsForHire // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [BackgroundImage].
extension BackgroundImagePatterns on BackgroundImage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BackgroundImage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BackgroundImage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BackgroundImage value)  $default,){
final _that = this;
switch (_that) {
case _BackgroundImage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BackgroundImage value)?  $default,){
final _that = this;
switch (_that) {
case _BackgroundImage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String description,  String color,  String blurHash,  String url,  String originUrl,  String authorName,  String authorProfileImageUrl,  String authorUrl,  String authorBio,  String authorLocation,  int authorTotalLikes,  int authorTotalPhotos,  bool authorIsForHire)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BackgroundImage() when $default != null:
return $default(_that.id,_that.description,_that.color,_that.blurHash,_that.url,_that.originUrl,_that.authorName,_that.authorProfileImageUrl,_that.authorUrl,_that.authorBio,_that.authorLocation,_that.authorTotalLikes,_that.authorTotalPhotos,_that.authorIsForHire);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String description,  String color,  String blurHash,  String url,  String originUrl,  String authorName,  String authorProfileImageUrl,  String authorUrl,  String authorBio,  String authorLocation,  int authorTotalLikes,  int authorTotalPhotos,  bool authorIsForHire)  $default,) {final _that = this;
switch (_that) {
case _BackgroundImage():
return $default(_that.id,_that.description,_that.color,_that.blurHash,_that.url,_that.originUrl,_that.authorName,_that.authorProfileImageUrl,_that.authorUrl,_that.authorBio,_that.authorLocation,_that.authorTotalLikes,_that.authorTotalPhotos,_that.authorIsForHire);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String description,  String color,  String blurHash,  String url,  String originUrl,  String authorName,  String authorProfileImageUrl,  String authorUrl,  String authorBio,  String authorLocation,  int authorTotalLikes,  int authorTotalPhotos,  bool authorIsForHire)?  $default,) {final _that = this;
switch (_that) {
case _BackgroundImage() when $default != null:
return $default(_that.id,_that.description,_that.color,_that.blurHash,_that.url,_that.originUrl,_that.authorName,_that.authorProfileImageUrl,_that.authorUrl,_that.authorBio,_that.authorLocation,_that.authorTotalLikes,_that.authorTotalPhotos,_that.authorIsForHire);case _:
  return null;

}
}

}

/// @nodoc


class _BackgroundImage extends BackgroundImage {
  const _BackgroundImage({required this.id, required this.description, required this.color, required this.blurHash, required this.url, required this.originUrl, required this.authorName, required this.authorProfileImageUrl, required this.authorUrl, required this.authorBio, required this.authorLocation, required this.authorTotalLikes, required this.authorTotalPhotos, required this.authorIsForHire}): super._();
  

@override final  String id;
@override final  String description;
@override final  String color;
@override final  String blurHash;
@override final  String url;
@override final  String originUrl;
@override final  String authorName;
@override final  String authorProfileImageUrl;
@override final  String authorUrl;
@override final  String authorBio;
@override final  String authorLocation;
@override final  int authorTotalLikes;
@override final  int authorTotalPhotos;
@override final  bool authorIsForHire;

/// Create a copy of BackgroundImage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BackgroundImageCopyWith<_BackgroundImage> get copyWith => __$BackgroundImageCopyWithImpl<_BackgroundImage>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BackgroundImage&&(identical(other.id, id) || other.id == id)&&(identical(other.description, description) || other.description == description)&&(identical(other.color, color) || other.color == color)&&(identical(other.blurHash, blurHash) || other.blurHash == blurHash)&&(identical(other.url, url) || other.url == url)&&(identical(other.originUrl, originUrl) || other.originUrl == originUrl)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.authorProfileImageUrl, authorProfileImageUrl) || other.authorProfileImageUrl == authorProfileImageUrl)&&(identical(other.authorUrl, authorUrl) || other.authorUrl == authorUrl)&&(identical(other.authorBio, authorBio) || other.authorBio == authorBio)&&(identical(other.authorLocation, authorLocation) || other.authorLocation == authorLocation)&&(identical(other.authorTotalLikes, authorTotalLikes) || other.authorTotalLikes == authorTotalLikes)&&(identical(other.authorTotalPhotos, authorTotalPhotos) || other.authorTotalPhotos == authorTotalPhotos)&&(identical(other.authorIsForHire, authorIsForHire) || other.authorIsForHire == authorIsForHire));
}


@override
int get hashCode => Object.hash(runtimeType,id,description,color,blurHash,url,originUrl,authorName,authorProfileImageUrl,authorUrl,authorBio,authorLocation,authorTotalLikes,authorTotalPhotos,authorIsForHire);

@override
String toString() {
  return 'BackgroundImage(id: $id, description: $description, color: $color, blurHash: $blurHash, url: $url, originUrl: $originUrl, authorName: $authorName, authorProfileImageUrl: $authorProfileImageUrl, authorUrl: $authorUrl, authorBio: $authorBio, authorLocation: $authorLocation, authorTotalLikes: $authorTotalLikes, authorTotalPhotos: $authorTotalPhotos, authorIsForHire: $authorIsForHire)';
}


}

/// @nodoc
abstract mixin class _$BackgroundImageCopyWith<$Res> implements $BackgroundImageCopyWith<$Res> {
  factory _$BackgroundImageCopyWith(_BackgroundImage value, $Res Function(_BackgroundImage) _then) = __$BackgroundImageCopyWithImpl;
@override @useResult
$Res call({
 String id, String description, String color, String blurHash, String url, String originUrl, String authorName, String authorProfileImageUrl, String authorUrl, String authorBio, String authorLocation, int authorTotalLikes, int authorTotalPhotos, bool authorIsForHire
});




}
/// @nodoc
class __$BackgroundImageCopyWithImpl<$Res>
    implements _$BackgroundImageCopyWith<$Res> {
  __$BackgroundImageCopyWithImpl(this._self, this._then);

  final _BackgroundImage _self;
  final $Res Function(_BackgroundImage) _then;

/// Create a copy of BackgroundImage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? description = null,Object? color = null,Object? blurHash = null,Object? url = null,Object? originUrl = null,Object? authorName = null,Object? authorProfileImageUrl = null,Object? authorUrl = null,Object? authorBio = null,Object? authorLocation = null,Object? authorTotalLikes = null,Object? authorTotalPhotos = null,Object? authorIsForHire = null,}) {
  return _then(_BackgroundImage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String,blurHash: null == blurHash ? _self.blurHash : blurHash // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,originUrl: null == originUrl ? _self.originUrl : originUrl // ignore: cast_nullable_to_non_nullable
as String,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,authorProfileImageUrl: null == authorProfileImageUrl ? _self.authorProfileImageUrl : authorProfileImageUrl // ignore: cast_nullable_to_non_nullable
as String,authorUrl: null == authorUrl ? _self.authorUrl : authorUrl // ignore: cast_nullable_to_non_nullable
as String,authorBio: null == authorBio ? _self.authorBio : authorBio // ignore: cast_nullable_to_non_nullable
as String,authorLocation: null == authorLocation ? _self.authorLocation : authorLocation // ignore: cast_nullable_to_non_nullable
as String,authorTotalLikes: null == authorTotalLikes ? _self.authorTotalLikes : authorTotalLikes // ignore: cast_nullable_to_non_nullable
as int,authorTotalPhotos: null == authorTotalPhotos ? _self.authorTotalPhotos : authorTotalPhotos // ignore: cast_nullable_to_non_nullable
as int,authorIsForHire: null == authorIsForHire ? _self.authorIsForHire : authorIsForHire // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
