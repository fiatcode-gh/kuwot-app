// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quote_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuoteModel {

 int get id; String get text; QuoteGroup get group;
/// Create a copy of QuoteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuoteModelCopyWith<QuoteModel> get copyWith => _$QuoteModelCopyWithImpl<QuoteModel>(this as QuoteModel, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as QuoteModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuoteModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.text, _this.text) || other.text == _this.text)&&(identical(other.group, _this.group) || other.group == _this.group));
}


@override
int get hashCode {
  final _this = this as QuoteModel;
  return Object.hash(runtimeType,_this.id,_this.text,_this.group);
}

@override
String toString() {
  final _this = this as QuoteModel;
  return 'QuoteModel(id: ${_this.id}, text: ${_this.text}, group: ${_this.group})';
}


}

/// @nodoc
abstract mixin class $QuoteModelCopyWith<$Res>  {
  factory $QuoteModelCopyWith(QuoteModel value, $Res Function(QuoteModel) _then) = _$QuoteModelCopyWithImpl;
@useResult
$Res call({
 int id, String text, QuoteGroup group
});




}
/// @nodoc
class _$QuoteModelCopyWithImpl<$Res>
    implements $QuoteModelCopyWith<$Res> {
  _$QuoteModelCopyWithImpl(this._self, this._then);

  final QuoteModel _self;
  final $Res Function(QuoteModel) _then;

/// Create a copy of QuoteModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? text = null,Object? group = null,}) {
  return _then(QuoteModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as QuoteGroup,
  ));
}

}


/// Adds pattern-matching-related methods to [QuoteModel].
extension QuoteModelPatterns on QuoteModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuoteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuoteModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuoteModel value)  $default,){
final _that = this;
switch (_that) {
case _QuoteModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuoteModel value)?  $default,){
final _that = this;
switch (_that) {
case _QuoteModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String text,  QuoteGroup group)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuoteModel() when $default != null:
return $default(_that.id,_that.text,_that.group);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String text,  QuoteGroup group)  $default,) {final _that = this;
switch (_that) {
case _QuoteModel():
return $default(_that.id,_that.text,_that.group);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String text,  QuoteGroup group)?  $default,) {final _that = this;
switch (_that) {
case _QuoteModel() when $default != null:
return $default(_that.id,_that.text,_that.group);case _:
  return null;

}
}

}

/// @nodoc


class _QuoteModel implements QuoteModel {
  const _QuoteModel({required this.id, required this.text, required this.group});
  

@override final  int id;
@override final  String text;
@override final  QuoteGroup group;

/// Create a copy of QuoteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuoteModelCopyWith<_QuoteModel> get copyWith => __$QuoteModelCopyWithImpl<_QuoteModel>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuoteModel&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.group, group) || other.group == group));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,text,group);
}

@override
String toString() {
    return 'QuoteModel(id: $id, text: $text, group: $group)';
}


}

/// @nodoc
abstract mixin class _$QuoteModelCopyWith<$Res> implements $QuoteModelCopyWith<$Res> {
  factory _$QuoteModelCopyWith(_QuoteModel value, $Res Function(_QuoteModel) _then) = __$QuoteModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String text, QuoteGroup group
});




}
/// @nodoc
class __$QuoteModelCopyWithImpl<$Res>
    implements _$QuoteModelCopyWith<$Res> {
  __$QuoteModelCopyWithImpl(this._self, this._then);

  final _QuoteModel _self;
  final $Res Function(_QuoteModel) _then;

/// Create a copy of QuoteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? text = null,Object? group = null,}) {
  return _then(_QuoteModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as QuoteGroup,
  ));
}


}

// dart format on
