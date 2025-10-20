// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'photo_list_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PhotoListModel {

 int get page; int get perPage; List<PhotoModel> get photos; int get totalResults; String get nextPage;
/// Create a copy of PhotoListModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PhotoListModelCopyWith<PhotoListModel> get copyWith => _$PhotoListModelCopyWithImpl<PhotoListModel>(this as PhotoListModel, _$identity);

  /// Serializes this PhotoListModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhotoListModel&&(identical(other.page, page) || other.page == page)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&const DeepCollectionEquality().equals(other.photos, photos)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults)&&(identical(other.nextPage, nextPage) || other.nextPage == nextPage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,page,perPage,const DeepCollectionEquality().hash(photos),totalResults,nextPage);

@override
String toString() {
  return 'PhotoListModel(page: $page, perPage: $perPage, photos: $photos, totalResults: $totalResults, nextPage: $nextPage)';
}


}

/// @nodoc
abstract mixin class $PhotoListModelCopyWith<$Res>  {
  factory $PhotoListModelCopyWith(PhotoListModel value, $Res Function(PhotoListModel) _then) = _$PhotoListModelCopyWithImpl;
@useResult
$Res call({
 int page, int perPage, List<PhotoModel> photos, int totalResults, String nextPage
});




}
/// @nodoc
class _$PhotoListModelCopyWithImpl<$Res>
    implements $PhotoListModelCopyWith<$Res> {
  _$PhotoListModelCopyWithImpl(this._self, this._then);

  final PhotoListModel _self;
  final $Res Function(PhotoListModel) _then;

/// Create a copy of PhotoListModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? page = null,Object? perPage = null,Object? photos = null,Object? totalResults = null,Object? nextPage = null,}) {
  return _then(_self.copyWith(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,photos: null == photos ? _self.photos : photos // ignore: cast_nullable_to_non_nullable
as List<PhotoModel>,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,nextPage: null == nextPage ? _self.nextPage : nextPage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PhotoListModel].
extension PhotoListModelPatterns on PhotoListModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PhotoListModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PhotoListModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PhotoListModel value)  $default,){
final _that = this;
switch (_that) {
case _PhotoListModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PhotoListModel value)?  $default,){
final _that = this;
switch (_that) {
case _PhotoListModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int page,  int perPage,  List<PhotoModel> photos,  int totalResults,  String nextPage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PhotoListModel() when $default != null:
return $default(_that.page,_that.perPage,_that.photos,_that.totalResults,_that.nextPage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int page,  int perPage,  List<PhotoModel> photos,  int totalResults,  String nextPage)  $default,) {final _that = this;
switch (_that) {
case _PhotoListModel():
return $default(_that.page,_that.perPage,_that.photos,_that.totalResults,_that.nextPage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int page,  int perPage,  List<PhotoModel> photos,  int totalResults,  String nextPage)?  $default,) {final _that = this;
switch (_that) {
case _PhotoListModel() when $default != null:
return $default(_that.page,_that.perPage,_that.photos,_that.totalResults,_that.nextPage);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _PhotoListModel implements PhotoListModel {
  const _PhotoListModel({required this.page, required this.perPage, required final  List<PhotoModel> photos, required this.totalResults, required this.nextPage}): _photos = photos;
  factory _PhotoListModel.fromJson(Map<String, dynamic> json) => _$PhotoListModelFromJson(json);

@override final  int page;
@override final  int perPage;
 final  List<PhotoModel> _photos;
@override List<PhotoModel> get photos {
  if (_photos is EqualUnmodifiableListView) return _photos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photos);
}

@override final  int totalResults;
@override final  String nextPage;

/// Create a copy of PhotoListModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PhotoListModelCopyWith<_PhotoListModel> get copyWith => __$PhotoListModelCopyWithImpl<_PhotoListModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PhotoListModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PhotoListModel&&(identical(other.page, page) || other.page == page)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&const DeepCollectionEquality().equals(other._photos, _photos)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults)&&(identical(other.nextPage, nextPage) || other.nextPage == nextPage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,page,perPage,const DeepCollectionEquality().hash(_photos),totalResults,nextPage);

@override
String toString() {
  return 'PhotoListModel(page: $page, perPage: $perPage, photos: $photos, totalResults: $totalResults, nextPage: $nextPage)';
}


}

/// @nodoc
abstract mixin class _$PhotoListModelCopyWith<$Res> implements $PhotoListModelCopyWith<$Res> {
  factory _$PhotoListModelCopyWith(_PhotoListModel value, $Res Function(_PhotoListModel) _then) = __$PhotoListModelCopyWithImpl;
@override @useResult
$Res call({
 int page, int perPage, List<PhotoModel> photos, int totalResults, String nextPage
});




}
/// @nodoc
class __$PhotoListModelCopyWithImpl<$Res>
    implements _$PhotoListModelCopyWith<$Res> {
  __$PhotoListModelCopyWithImpl(this._self, this._then);

  final _PhotoListModel _self;
  final $Res Function(_PhotoListModel) _then;

/// Create a copy of PhotoListModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? page = null,Object? perPage = null,Object? photos = null,Object? totalResults = null,Object? nextPage = null,}) {
  return _then(_PhotoListModel(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,photos: null == photos ? _self._photos : photos // ignore: cast_nullable_to_non_nullable
as List<PhotoModel>,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,nextPage: null == nextPage ? _self.nextPage : nextPage // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$PhotoModel {

 int get id; int get width; int get height; String get url; String get photographer; String get photographerUrl; int get photographerId; String get avgColor; SrcModel get src; bool get liked; String get alt;
/// Create a copy of PhotoModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PhotoModelCopyWith<PhotoModel> get copyWith => _$PhotoModelCopyWithImpl<PhotoModel>(this as PhotoModel, _$identity);

  /// Serializes this PhotoModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhotoModel&&(identical(other.id, id) || other.id == id)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.url, url) || other.url == url)&&(identical(other.photographer, photographer) || other.photographer == photographer)&&(identical(other.photographerUrl, photographerUrl) || other.photographerUrl == photographerUrl)&&(identical(other.photographerId, photographerId) || other.photographerId == photographerId)&&(identical(other.avgColor, avgColor) || other.avgColor == avgColor)&&(identical(other.src, src) || other.src == src)&&(identical(other.liked, liked) || other.liked == liked)&&(identical(other.alt, alt) || other.alt == alt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,width,height,url,photographer,photographerUrl,photographerId,avgColor,src,liked,alt);

@override
String toString() {
  return 'PhotoModel(id: $id, width: $width, height: $height, url: $url, photographer: $photographer, photographerUrl: $photographerUrl, photographerId: $photographerId, avgColor: $avgColor, src: $src, liked: $liked, alt: $alt)';
}


}

/// @nodoc
abstract mixin class $PhotoModelCopyWith<$Res>  {
  factory $PhotoModelCopyWith(PhotoModel value, $Res Function(PhotoModel) _then) = _$PhotoModelCopyWithImpl;
@useResult
$Res call({
 int id, int width, int height, String url, String photographer, String photographerUrl, int photographerId, String avgColor, SrcModel src, bool liked, String alt
});


$SrcModelCopyWith<$Res> get src;

}
/// @nodoc
class _$PhotoModelCopyWithImpl<$Res>
    implements $PhotoModelCopyWith<$Res> {
  _$PhotoModelCopyWithImpl(this._self, this._then);

  final PhotoModel _self;
  final $Res Function(PhotoModel) _then;

/// Create a copy of PhotoModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? width = null,Object? height = null,Object? url = null,Object? photographer = null,Object? photographerUrl = null,Object? photographerId = null,Object? avgColor = null,Object? src = null,Object? liked = null,Object? alt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,photographer: null == photographer ? _self.photographer : photographer // ignore: cast_nullable_to_non_nullable
as String,photographerUrl: null == photographerUrl ? _self.photographerUrl : photographerUrl // ignore: cast_nullable_to_non_nullable
as String,photographerId: null == photographerId ? _self.photographerId : photographerId // ignore: cast_nullable_to_non_nullable
as int,avgColor: null == avgColor ? _self.avgColor : avgColor // ignore: cast_nullable_to_non_nullable
as String,src: null == src ? _self.src : src // ignore: cast_nullable_to_non_nullable
as SrcModel,liked: null == liked ? _self.liked : liked // ignore: cast_nullable_to_non_nullable
as bool,alt: null == alt ? _self.alt : alt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of PhotoModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SrcModelCopyWith<$Res> get src {
  
  return $SrcModelCopyWith<$Res>(_self.src, (value) {
    return _then(_self.copyWith(src: value));
  });
}
}


/// Adds pattern-matching-related methods to [PhotoModel].
extension PhotoModelPatterns on PhotoModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PhotoModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PhotoModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PhotoModel value)  $default,){
final _that = this;
switch (_that) {
case _PhotoModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PhotoModel value)?  $default,){
final _that = this;
switch (_that) {
case _PhotoModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int width,  int height,  String url,  String photographer,  String photographerUrl,  int photographerId,  String avgColor,  SrcModel src,  bool liked,  String alt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PhotoModel() when $default != null:
return $default(_that.id,_that.width,_that.height,_that.url,_that.photographer,_that.photographerUrl,_that.photographerId,_that.avgColor,_that.src,_that.liked,_that.alt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int width,  int height,  String url,  String photographer,  String photographerUrl,  int photographerId,  String avgColor,  SrcModel src,  bool liked,  String alt)  $default,) {final _that = this;
switch (_that) {
case _PhotoModel():
return $default(_that.id,_that.width,_that.height,_that.url,_that.photographer,_that.photographerUrl,_that.photographerId,_that.avgColor,_that.src,_that.liked,_that.alt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int width,  int height,  String url,  String photographer,  String photographerUrl,  int photographerId,  String avgColor,  SrcModel src,  bool liked,  String alt)?  $default,) {final _that = this;
switch (_that) {
case _PhotoModel() when $default != null:
return $default(_that.id,_that.width,_that.height,_that.url,_that.photographer,_that.photographerUrl,_that.photographerId,_that.avgColor,_that.src,_that.liked,_that.alt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _PhotoModel implements PhotoModel {
  const _PhotoModel({required this.id, required this.width, required this.height, required this.url, required this.photographer, required this.photographerUrl, required this.photographerId, required this.avgColor, required this.src, required this.liked, required this.alt});
  factory _PhotoModel.fromJson(Map<String, dynamic> json) => _$PhotoModelFromJson(json);

@override final  int id;
@override final  int width;
@override final  int height;
@override final  String url;
@override final  String photographer;
@override final  String photographerUrl;
@override final  int photographerId;
@override final  String avgColor;
@override final  SrcModel src;
@override final  bool liked;
@override final  String alt;

/// Create a copy of PhotoModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PhotoModelCopyWith<_PhotoModel> get copyWith => __$PhotoModelCopyWithImpl<_PhotoModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PhotoModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PhotoModel&&(identical(other.id, id) || other.id == id)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.url, url) || other.url == url)&&(identical(other.photographer, photographer) || other.photographer == photographer)&&(identical(other.photographerUrl, photographerUrl) || other.photographerUrl == photographerUrl)&&(identical(other.photographerId, photographerId) || other.photographerId == photographerId)&&(identical(other.avgColor, avgColor) || other.avgColor == avgColor)&&(identical(other.src, src) || other.src == src)&&(identical(other.liked, liked) || other.liked == liked)&&(identical(other.alt, alt) || other.alt == alt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,width,height,url,photographer,photographerUrl,photographerId,avgColor,src,liked,alt);

@override
String toString() {
  return 'PhotoModel(id: $id, width: $width, height: $height, url: $url, photographer: $photographer, photographerUrl: $photographerUrl, photographerId: $photographerId, avgColor: $avgColor, src: $src, liked: $liked, alt: $alt)';
}


}

/// @nodoc
abstract mixin class _$PhotoModelCopyWith<$Res> implements $PhotoModelCopyWith<$Res> {
  factory _$PhotoModelCopyWith(_PhotoModel value, $Res Function(_PhotoModel) _then) = __$PhotoModelCopyWithImpl;
@override @useResult
$Res call({
 int id, int width, int height, String url, String photographer, String photographerUrl, int photographerId, String avgColor, SrcModel src, bool liked, String alt
});


@override $SrcModelCopyWith<$Res> get src;

}
/// @nodoc
class __$PhotoModelCopyWithImpl<$Res>
    implements _$PhotoModelCopyWith<$Res> {
  __$PhotoModelCopyWithImpl(this._self, this._then);

  final _PhotoModel _self;
  final $Res Function(_PhotoModel) _then;

/// Create a copy of PhotoModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? width = null,Object? height = null,Object? url = null,Object? photographer = null,Object? photographerUrl = null,Object? photographerId = null,Object? avgColor = null,Object? src = null,Object? liked = null,Object? alt = null,}) {
  return _then(_PhotoModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,photographer: null == photographer ? _self.photographer : photographer // ignore: cast_nullable_to_non_nullable
as String,photographerUrl: null == photographerUrl ? _self.photographerUrl : photographerUrl // ignore: cast_nullable_to_non_nullable
as String,photographerId: null == photographerId ? _self.photographerId : photographerId // ignore: cast_nullable_to_non_nullable
as int,avgColor: null == avgColor ? _self.avgColor : avgColor // ignore: cast_nullable_to_non_nullable
as String,src: null == src ? _self.src : src // ignore: cast_nullable_to_non_nullable
as SrcModel,liked: null == liked ? _self.liked : liked // ignore: cast_nullable_to_non_nullable
as bool,alt: null == alt ? _self.alt : alt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of PhotoModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SrcModelCopyWith<$Res> get src {
  
  return $SrcModelCopyWith<$Res>(_self.src, (value) {
    return _then(_self.copyWith(src: value));
  });
}
}


/// @nodoc
mixin _$SrcModel {

 String get original; String get large2x; String get large; String get medium; String get small; String get portrait; String get landscape; String get tiny;
/// Create a copy of SrcModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SrcModelCopyWith<SrcModel> get copyWith => _$SrcModelCopyWithImpl<SrcModel>(this as SrcModel, _$identity);

  /// Serializes this SrcModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SrcModel&&(identical(other.original, original) || other.original == original)&&(identical(other.large2x, large2x) || other.large2x == large2x)&&(identical(other.large, large) || other.large == large)&&(identical(other.medium, medium) || other.medium == medium)&&(identical(other.small, small) || other.small == small)&&(identical(other.portrait, portrait) || other.portrait == portrait)&&(identical(other.landscape, landscape) || other.landscape == landscape)&&(identical(other.tiny, tiny) || other.tiny == tiny));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,original,large2x,large,medium,small,portrait,landscape,tiny);

@override
String toString() {
  return 'SrcModel(original: $original, large2x: $large2x, large: $large, medium: $medium, small: $small, portrait: $portrait, landscape: $landscape, tiny: $tiny)';
}


}

/// @nodoc
abstract mixin class $SrcModelCopyWith<$Res>  {
  factory $SrcModelCopyWith(SrcModel value, $Res Function(SrcModel) _then) = _$SrcModelCopyWithImpl;
@useResult
$Res call({
 String original, String large2x, String large, String medium, String small, String portrait, String landscape, String tiny
});




}
/// @nodoc
class _$SrcModelCopyWithImpl<$Res>
    implements $SrcModelCopyWith<$Res> {
  _$SrcModelCopyWithImpl(this._self, this._then);

  final SrcModel _self;
  final $Res Function(SrcModel) _then;

/// Create a copy of SrcModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? original = null,Object? large2x = null,Object? large = null,Object? medium = null,Object? small = null,Object? portrait = null,Object? landscape = null,Object? tiny = null,}) {
  return _then(_self.copyWith(
original: null == original ? _self.original : original // ignore: cast_nullable_to_non_nullable
as String,large2x: null == large2x ? _self.large2x : large2x // ignore: cast_nullable_to_non_nullable
as String,large: null == large ? _self.large : large // ignore: cast_nullable_to_non_nullable
as String,medium: null == medium ? _self.medium : medium // ignore: cast_nullable_to_non_nullable
as String,small: null == small ? _self.small : small // ignore: cast_nullable_to_non_nullable
as String,portrait: null == portrait ? _self.portrait : portrait // ignore: cast_nullable_to_non_nullable
as String,landscape: null == landscape ? _self.landscape : landscape // ignore: cast_nullable_to_non_nullable
as String,tiny: null == tiny ? _self.tiny : tiny // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SrcModel].
extension SrcModelPatterns on SrcModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SrcModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SrcModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SrcModel value)  $default,){
final _that = this;
switch (_that) {
case _SrcModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SrcModel value)?  $default,){
final _that = this;
switch (_that) {
case _SrcModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String original,  String large2x,  String large,  String medium,  String small,  String portrait,  String landscape,  String tiny)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SrcModel() when $default != null:
return $default(_that.original,_that.large2x,_that.large,_that.medium,_that.small,_that.portrait,_that.landscape,_that.tiny);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String original,  String large2x,  String large,  String medium,  String small,  String portrait,  String landscape,  String tiny)  $default,) {final _that = this;
switch (_that) {
case _SrcModel():
return $default(_that.original,_that.large2x,_that.large,_that.medium,_that.small,_that.portrait,_that.landscape,_that.tiny);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String original,  String large2x,  String large,  String medium,  String small,  String portrait,  String landscape,  String tiny)?  $default,) {final _that = this;
switch (_that) {
case _SrcModel() when $default != null:
return $default(_that.original,_that.large2x,_that.large,_that.medium,_that.small,_that.portrait,_that.landscape,_that.tiny);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _SrcModel implements SrcModel {
  const _SrcModel({required this.original, required this.large2x, required this.large, required this.medium, required this.small, required this.portrait, required this.landscape, required this.tiny});
  factory _SrcModel.fromJson(Map<String, dynamic> json) => _$SrcModelFromJson(json);

@override final  String original;
@override final  String large2x;
@override final  String large;
@override final  String medium;
@override final  String small;
@override final  String portrait;
@override final  String landscape;
@override final  String tiny;

/// Create a copy of SrcModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SrcModelCopyWith<_SrcModel> get copyWith => __$SrcModelCopyWithImpl<_SrcModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SrcModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SrcModel&&(identical(other.original, original) || other.original == original)&&(identical(other.large2x, large2x) || other.large2x == large2x)&&(identical(other.large, large) || other.large == large)&&(identical(other.medium, medium) || other.medium == medium)&&(identical(other.small, small) || other.small == small)&&(identical(other.portrait, portrait) || other.portrait == portrait)&&(identical(other.landscape, landscape) || other.landscape == landscape)&&(identical(other.tiny, tiny) || other.tiny == tiny));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,original,large2x,large,medium,small,portrait,landscape,tiny);

@override
String toString() {
  return 'SrcModel(original: $original, large2x: $large2x, large: $large, medium: $medium, small: $small, portrait: $portrait, landscape: $landscape, tiny: $tiny)';
}


}

/// @nodoc
abstract mixin class _$SrcModelCopyWith<$Res> implements $SrcModelCopyWith<$Res> {
  factory _$SrcModelCopyWith(_SrcModel value, $Res Function(_SrcModel) _then) = __$SrcModelCopyWithImpl;
@override @useResult
$Res call({
 String original, String large2x, String large, String medium, String small, String portrait, String landscape, String tiny
});




}
/// @nodoc
class __$SrcModelCopyWithImpl<$Res>
    implements _$SrcModelCopyWith<$Res> {
  __$SrcModelCopyWithImpl(this._self, this._then);

  final _SrcModel _self;
  final $Res Function(_SrcModel) _then;

/// Create a copy of SrcModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? original = null,Object? large2x = null,Object? large = null,Object? medium = null,Object? small = null,Object? portrait = null,Object? landscape = null,Object? tiny = null,}) {
  return _then(_SrcModel(
original: null == original ? _self.original : original // ignore: cast_nullable_to_non_nullable
as String,large2x: null == large2x ? _self.large2x : large2x // ignore: cast_nullable_to_non_nullable
as String,large: null == large ? _self.large : large // ignore: cast_nullable_to_non_nullable
as String,medium: null == medium ? _self.medium : medium // ignore: cast_nullable_to_non_nullable
as String,small: null == small ? _self.small : small // ignore: cast_nullable_to_non_nullable
as String,portrait: null == portrait ? _self.portrait : portrait // ignore: cast_nullable_to_non_nullable
as String,landscape: null == landscape ? _self.landscape : landscape // ignore: cast_nullable_to_non_nullable
as String,tiny: null == tiny ? _self.tiny : tiny // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
