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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Avatar _$AvatarFromJson(Map<String, dynamic> json) {
  return _Avatar.fromJson(json);
}

/// @nodoc
mixin _$Avatar {
  String get id => throw _privateConstructorUsedError;
  String get activeImageUrl => throw _privateConstructorUsedError;
  String get stopImageUrl => throw _privateConstructorUsedError;
  bool get isDefault => throw _privateConstructorUsedError;
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
      {String id,
      String activeImageUrl,
      String stopImageUrl,
      bool isDefault,
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
    Object? id = null,
    Object? activeImageUrl = null,
    Object? stopImageUrl = null,
    Object? isDefault = null,
    Object? created = null,
    Object? updated = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      activeImageUrl: null == activeImageUrl
          ? _value.activeImageUrl
          : activeImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      stopImageUrl: null == stopImageUrl
          ? _value.stopImageUrl
          : stopImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
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
abstract class _$$AvatarImplCopyWith<$Res> implements $AvatarCopyWith<$Res> {
  factory _$$AvatarImplCopyWith(
          _$AvatarImpl value, $Res Function(_$AvatarImpl) then) =
      __$$AvatarImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String activeImageUrl,
      String stopImageUrl,
      bool isDefault,
      @FireTimestampConverterNonNull() DateTime created,
      @FireTimestampConverterNonNull() DateTime updated});
}

/// @nodoc
class __$$AvatarImplCopyWithImpl<$Res>
    extends _$AvatarCopyWithImpl<$Res, _$AvatarImpl>
    implements _$$AvatarImplCopyWith<$Res> {
  __$$AvatarImplCopyWithImpl(
      _$AvatarImpl _value, $Res Function(_$AvatarImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? activeImageUrl = null,
    Object? stopImageUrl = null,
    Object? isDefault = null,
    Object? created = null,
    Object? updated = null,
  }) {
    return _then(_$AvatarImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      activeImageUrl: null == activeImageUrl
          ? _value.activeImageUrl
          : activeImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      stopImageUrl: null == stopImageUrl
          ? _value.stopImageUrl
          : stopImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
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
class _$AvatarImpl implements _Avatar {
  const _$AvatarImpl(
      {this.id = '',
      this.activeImageUrl = '',
      this.stopImageUrl = '',
      this.isDefault = false,
      @FireTimestampConverterNonNull() required this.created,
      @FireTimestampConverterNonNull() required this.updated});

  factory _$AvatarImpl.fromJson(Map<String, dynamic> json) =>
      _$$AvatarImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String activeImageUrl;
  @override
  @JsonKey()
  final String stopImageUrl;
  @override
  @JsonKey()
  final bool isDefault;
  @override
  @FireTimestampConverterNonNull()
  final DateTime created;
  @override
  @FireTimestampConverterNonNull()
  final DateTime updated;

  @override
  String toString() {
    return 'Avatar(id: $id, activeImageUrl: $activeImageUrl, stopImageUrl: $stopImageUrl, isDefault: $isDefault, created: $created, updated: $updated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AvatarImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.activeImageUrl, activeImageUrl) ||
                other.activeImageUrl == activeImageUrl) &&
            (identical(other.stopImageUrl, stopImageUrl) ||
                other.stopImageUrl == stopImageUrl) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.created, created) || other.created == created) &&
            (identical(other.updated, updated) || other.updated == updated));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, activeImageUrl, stopImageUrl,
      isDefault, created, updated);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AvatarImplCopyWith<_$AvatarImpl> get copyWith =>
      __$$AvatarImplCopyWithImpl<_$AvatarImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AvatarImplToJson(
      this,
    );
  }
}

abstract class _Avatar implements Avatar {
  const factory _Avatar(
          {final String id,
          final String activeImageUrl,
          final String stopImageUrl,
          final bool isDefault,
          @FireTimestampConverterNonNull() required final DateTime created,
          @FireTimestampConverterNonNull() required final DateTime updated}) =
      _$AvatarImpl;

  factory _Avatar.fromJson(Map<String, dynamic> json) = _$AvatarImpl.fromJson;

  @override
  String get id;
  @override
  String get activeImageUrl;
  @override
  String get stopImageUrl;
  @override
  bool get isDefault;
  @override
  @FireTimestampConverterNonNull()
  DateTime get created;
  @override
  @FireTimestampConverterNonNull()
  DateTime get updated;
  @override
  @JsonKey(ignore: true)
  _$$AvatarImplCopyWith<_$AvatarImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
