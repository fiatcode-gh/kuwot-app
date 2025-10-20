// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'translation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Translation {

 String get id; String get language;
/// Create a copy of Translation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TranslationCopyWith<Translation> get copyWith => _$TranslationCopyWithImpl<Translation>(this as Translation, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Translation&&(identical(other.id, id) || other.id == id)&&(identical(other.language, language) || other.language == language));
}


@override
int get hashCode => Object.hash(runtimeType,id,language);

@override
String toString() {
  return 'Translation(id: $id, language: $language)';
}


}

/// @nodoc
abstract mixin class $TranslationCopyWith<$Res>  {
  factory $TranslationCopyWith(Translation value, $Res Function(Translation) _then) = _$TranslationCopyWithImpl;
@useResult
$Res call({
 String id, String language
});




}
/// @nodoc
class _$TranslationCopyWithImpl<$Res>
    implements $TranslationCopyWith<$Res> {
  _$TranslationCopyWithImpl(this._self, this._then);

  final Translation _self;
  final $Res Function(Translation) _then;

/// Create a copy of Translation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? language = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Translation].
extension TranslationPatterns on Translation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Translation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Translation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Translation value)  $default,){
final _that = this;
switch (_that) {
case _Translation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Translation value)?  $default,){
final _that = this;
switch (_that) {
case _Translation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String language)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Translation() when $default != null:
return $default(_that.id,_that.language);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String language)  $default,) {final _that = this;
switch (_that) {
case _Translation():
return $default(_that.id,_that.language);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String language)?  $default,) {final _that = this;
switch (_that) {
case _Translation() when $default != null:
return $default(_that.id,_that.language);case _:
  return null;

}
}

}

/// @nodoc


class _Translation implements Translation {
  const _Translation({required this.id, required this.language});
  

@override final  String id;
@override final  String language;

/// Create a copy of Translation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TranslationCopyWith<_Translation> get copyWith => __$TranslationCopyWithImpl<_Translation>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Translation&&(identical(other.id, id) || other.id == id)&&(identical(other.language, language) || other.language == language));
}


@override
int get hashCode => Object.hash(runtimeType,id,language);

@override
String toString() {
  return 'Translation(id: $id, language: $language)';
}


}

/// @nodoc
abstract mixin class _$TranslationCopyWith<$Res> implements $TranslationCopyWith<$Res> {
  factory _$TranslationCopyWith(_Translation value, $Res Function(_Translation) _then) = __$TranslationCopyWithImpl;
@override @useResult
$Res call({
 String id, String language
});




}
/// @nodoc
class __$TranslationCopyWithImpl<$Res>
    implements _$TranslationCopyWith<$Res> {
  __$TranslationCopyWithImpl(this._self, this._then);

  final _Translation _self;
  final $Res Function(_Translation) _then;

/// Create a copy of Translation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? language = null,}) {
  return _then(_Translation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
