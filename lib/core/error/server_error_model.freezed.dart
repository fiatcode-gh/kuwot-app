// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'server_error_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ServerErrorModel {

 String get message; int get code;
/// Create a copy of ServerErrorModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerErrorModelCopyWith<ServerErrorModel> get copyWith => _$ServerErrorModelCopyWithImpl<ServerErrorModel>(this as ServerErrorModel, _$identity);

  /// Serializes this ServerErrorModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerErrorModel&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,code);

@override
String toString() {
  return 'ServerErrorModel(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class $ServerErrorModelCopyWith<$Res>  {
  factory $ServerErrorModelCopyWith(ServerErrorModel value, $Res Function(ServerErrorModel) _then) = _$ServerErrorModelCopyWithImpl;
@useResult
$Res call({
 String message, int code
});




}
/// @nodoc
class _$ServerErrorModelCopyWithImpl<$Res>
    implements $ServerErrorModelCopyWith<$Res> {
  _$ServerErrorModelCopyWithImpl(this._self, this._then);

  final ServerErrorModel _self;
  final $Res Function(ServerErrorModel) _then;

/// Create a copy of ServerErrorModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? code = null,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ServerErrorModel].
extension ServerErrorModelPatterns on ServerErrorModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServerErrorModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServerErrorModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServerErrorModel value)  $default,){
final _that = this;
switch (_that) {
case _ServerErrorModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServerErrorModel value)?  $default,){
final _that = this;
switch (_that) {
case _ServerErrorModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String message,  int code)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServerErrorModel() when $default != null:
return $default(_that.message,_that.code);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String message,  int code)  $default,) {final _that = this;
switch (_that) {
case _ServerErrorModel():
return $default(_that.message,_that.code);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String message,  int code)?  $default,) {final _that = this;
switch (_that) {
case _ServerErrorModel() when $default != null:
return $default(_that.message,_that.code);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ServerErrorModel implements ServerErrorModel {
  const _ServerErrorModel({required this.message, required this.code});
  factory _ServerErrorModel.fromJson(Map<String, dynamic> json) => _$ServerErrorModelFromJson(json);

@override final  String message;
@override final  int code;

/// Create a copy of ServerErrorModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServerErrorModelCopyWith<_ServerErrorModel> get copyWith => __$ServerErrorModelCopyWithImpl<_ServerErrorModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServerErrorModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServerErrorModel&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,code);

@override
String toString() {
  return 'ServerErrorModel(message: $message, code: $code)';
}


}

/// @nodoc
abstract mixin class _$ServerErrorModelCopyWith<$Res> implements $ServerErrorModelCopyWith<$Res> {
  factory _$ServerErrorModelCopyWith(_ServerErrorModel value, $Res Function(_ServerErrorModel) _then) = __$ServerErrorModelCopyWithImpl;
@override @useResult
$Res call({
 String message, int code
});




}
/// @nodoc
class __$ServerErrorModelCopyWithImpl<$Res>
    implements _$ServerErrorModelCopyWith<$Res> {
  __$ServerErrorModelCopyWithImpl(this._self, this._then);

  final _ServerErrorModel _self;
  final $Res Function(_ServerErrorModel) _then;

/// Create a copy of ServerErrorModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? code = null,}) {
  return _then(_ServerErrorModel(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
