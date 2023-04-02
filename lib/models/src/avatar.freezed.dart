// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'avatar.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Avatar _$AvatarFromJson(Map<String, dynamic> json) {
  return _Avatar.fromJson(json);
}

/// @nodoc
mixin _$Avatar {
  String get activeImagePath => throw _privateConstructorUsedError;
  String get stopImagePath => throw _privateConstructorUsedError;
  String get uniqueKey => throw _privateConstructorUsedError;
  @FireTimestampConverterNonNull()
  DateTime get created => throw _privateConstructorUsedError;
  @FireTimestampConverterNonNull()
  DateTime get updated => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AvatarCopyWith<Avatar> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AvatarCopyWith<$Res> {
  factory $AvatarCopyWith(Avatar value, $Res Function(Avatar) then) =
      _$AvatarCopyWithImpl<$Res, Avatar>;
  @useResult
  $Res call(
      {String activeImagePath,
      String stopImagePath,
      String uniqueKey,
      @FireTimestampConverterNonNull() DateTime created,
      @FireTimestampConverterNonNull() DateTime updated});
}

/// @nodoc
class _$AvatarCopyWithImpl<$Res, $Val extends Avatar>
    implements $AvatarCopyWith<$Res> {
  _$AvatarCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activeImagePath = null,
    Object? stopImagePath = null,
    Object? uniqueKey = null,
    Object? created = null,
    Object? updated = null,
  }) {
    return _then(_value.copyWith(
      activeImagePath: null == activeImagePath
          ? _value.activeImagePath
          : activeImagePath // ignore: cast_nullable_to_non_nullable
              as String,
      stopImagePath: null == stopImagePath
          ? _value.stopImagePath
          : stopImagePath // ignore: cast_nullable_to_non_nullable
              as String,
      uniqueKey: null == uniqueKey
          ? _value.uniqueKey
          : uniqueKey // ignore: cast_nullable_to_non_nullable
              as String,
      created: null == created
          ? _value.created
          : created // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updated: null == updated
          ? _value.updated
          : updated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_AvatarCopyWith<$Res> implements $AvatarCopyWith<$Res> {
  factory _$$_AvatarCopyWith(_$_Avatar value, $Res Function(_$_Avatar) then) =
      __$$_AvatarCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String activeImagePath,
      String stopImagePath,
      String uniqueKey,
      @FireTimestampConverterNonNull() DateTime created,
      @FireTimestampConverterNonNull() DateTime updated});
}

/// @nodoc
class __$$_AvatarCopyWithImpl<$Res>
    extends _$AvatarCopyWithImpl<$Res, _$_Avatar>
    implements _$$_AvatarCopyWith<$Res> {
  __$$_AvatarCopyWithImpl(_$_Avatar _value, $Res Function(_$_Avatar) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activeImagePath = null,
    Object? stopImagePath = null,
    Object? uniqueKey = null,
    Object? created = null,
    Object? updated = null,
  }) {
    return _then(_$_Avatar(
      activeImagePath: null == activeImagePath
          ? _value.activeImagePath
          : activeImagePath // ignore: cast_nullable_to_non_nullable
              as String,
      stopImagePath: null == stopImagePath
          ? _value.stopImagePath
          : stopImagePath // ignore: cast_nullable_to_non_nullable
              as String,
      uniqueKey: null == uniqueKey
          ? _value.uniqueKey
          : uniqueKey // ignore: cast_nullable_to_non_nullable
              as String,
      created: null == created
          ? _value.created
          : created // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updated: null == updated
          ? _value.updated
          : updated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_Avatar implements _Avatar {
  const _$_Avatar(
      {this.activeImagePath = '',
      this.stopImagePath = '',
      this.uniqueKey = '',
      @FireTimestampConverterNonNull() required this.created,
      @FireTimestampConverterNonNull() required this.updated});

  factory _$_Avatar.fromJson(Map<String, dynamic> json) =>
      _$$_AvatarFromJson(json);

  @override
  @JsonKey()
  final String activeImagePath;
  @override
  @JsonKey()
  final String stopImagePath;
  @override
  @JsonKey()
  final String uniqueKey;
  @override
  @FireTimestampConverterNonNull()
  final DateTime created;
  @override
  @FireTimestampConverterNonNull()
  final DateTime updated;

  @override
  String toString() {
    return 'Avatar(activeImagePath: $activeImagePath, stopImagePath: $stopImagePath, uniqueKey: $uniqueKey, created: $created, updated: $updated)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Avatar &&
            (identical(other.activeImagePath, activeImagePath) ||
                other.activeImagePath == activeImagePath) &&
            (identical(other.stopImagePath, stopImagePath) ||
                other.stopImagePath == stopImagePath) &&
            (identical(other.uniqueKey, uniqueKey) ||
                other.uniqueKey == uniqueKey) &&
            (identical(other.created, created) || other.created == created) &&
            (identical(other.updated, updated) || other.updated == updated));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, activeImagePath, stopImagePath, uniqueKey, created, updated);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AvatarCopyWith<_$_Avatar> get copyWith =>
      __$$_AvatarCopyWithImpl<_$_Avatar>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_AvatarToJson(
      this,
    );
  }
}

abstract class _Avatar implements Avatar {
  const factory _Avatar(
          {final String activeImagePath,
          final String stopImagePath,
          final String uniqueKey,
          @FireTimestampConverterNonNull() required final DateTime created,
          @FireTimestampConverterNonNull() required final DateTime updated}) =
      _$_Avatar;

  factory _Avatar.fromJson(Map<String, dynamic> json) = _$_Avatar.fromJson;

  @override
  String get activeImagePath;
  @override
  String get stopImagePath;
  @override
  String get uniqueKey;
  @override
  @FireTimestampConverterNonNull()
  DateTime get created;
  @override
  @FireTimestampConverterNonNull()
  DateTime get updated;
  @override
  @JsonKey(ignore: true)
  _$$_AvatarCopyWith<_$_Avatar> get copyWith =>
      throw _privateConstructorUsedError;
}
