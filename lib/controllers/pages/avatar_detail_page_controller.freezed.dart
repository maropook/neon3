// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'avatar_detail_page_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AvatarDetailPageState {
  String get newActiveImagePath => throw _privateConstructorUsedError;
  String get newStopImagePath => throw _privateConstructorUsedError;
  Avatar? get avatar => throw _privateConstructorUsedError;
  String get selectedAvatarId => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AvatarDetailPageStateCopyWith<AvatarDetailPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AvatarDetailPageStateCopyWith<$Res> {
  factory $AvatarDetailPageStateCopyWith(AvatarDetailPageState value,
          $Res Function(AvatarDetailPageState) then) =
      _$AvatarDetailPageStateCopyWithImpl<$Res, AvatarDetailPageState>;
  @useResult
  $Res call(
      {String newActiveImagePath,
      String newStopImagePath,
      Avatar? avatar,
      String selectedAvatarId});

  $AvatarCopyWith<$Res>? get avatar;
}

/// @nodoc
class _$AvatarDetailPageStateCopyWithImpl<$Res,
        $Val extends AvatarDetailPageState>
    implements $AvatarDetailPageStateCopyWith<$Res> {
  _$AvatarDetailPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? newActiveImagePath = null,
    Object? newStopImagePath = null,
    Object? avatar = freezed,
    Object? selectedAvatarId = null,
  }) {
    return _then(_value.copyWith(
      newActiveImagePath: null == newActiveImagePath
          ? _value.newActiveImagePath
          : newActiveImagePath // ignore: cast_nullable_to_non_nullable
              as String,
      newStopImagePath: null == newStopImagePath
          ? _value.newStopImagePath
          : newStopImagePath // ignore: cast_nullable_to_non_nullable
              as String,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as Avatar?,
      selectedAvatarId: null == selectedAvatarId
          ? _value.selectedAvatarId
          : selectedAvatarId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AvatarCopyWith<$Res>? get avatar {
    if (_value.avatar == null) {
      return null;
    }

    return $AvatarCopyWith<$Res>(_value.avatar!, (value) {
      return _then(_value.copyWith(avatar: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_AvatarDetailPageStateCopyWith<$Res>
    implements $AvatarDetailPageStateCopyWith<$Res> {
  factory _$$_AvatarDetailPageStateCopyWith(_$_AvatarDetailPageState value,
          $Res Function(_$_AvatarDetailPageState) then) =
      __$$_AvatarDetailPageStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String newActiveImagePath,
      String newStopImagePath,
      Avatar? avatar,
      String selectedAvatarId});

  @override
  $AvatarCopyWith<$Res>? get avatar;
}

/// @nodoc
class __$$_AvatarDetailPageStateCopyWithImpl<$Res>
    extends _$AvatarDetailPageStateCopyWithImpl<$Res, _$_AvatarDetailPageState>
    implements _$$_AvatarDetailPageStateCopyWith<$Res> {
  __$$_AvatarDetailPageStateCopyWithImpl(_$_AvatarDetailPageState _value,
      $Res Function(_$_AvatarDetailPageState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? newActiveImagePath = null,
    Object? newStopImagePath = null,
    Object? avatar = freezed,
    Object? selectedAvatarId = null,
  }) {
    return _then(_$_AvatarDetailPageState(
      newActiveImagePath: null == newActiveImagePath
          ? _value.newActiveImagePath
          : newActiveImagePath // ignore: cast_nullable_to_non_nullable
              as String,
      newStopImagePath: null == newStopImagePath
          ? _value.newStopImagePath
          : newStopImagePath // ignore: cast_nullable_to_non_nullable
              as String,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as Avatar?,
      selectedAvatarId: null == selectedAvatarId
          ? _value.selectedAvatarId
          : selectedAvatarId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_AvatarDetailPageState implements _AvatarDetailPageState {
  const _$_AvatarDetailPageState(
      {this.newActiveImagePath = "",
      this.newStopImagePath = "",
      this.avatar = null,
      this.selectedAvatarId = ""});

  @override
  @JsonKey()
  final String newActiveImagePath;
  @override
  @JsonKey()
  final String newStopImagePath;
  @override
  @JsonKey()
  final Avatar? avatar;
  @override
  @JsonKey()
  final String selectedAvatarId;

  @override
  String toString() {
    return 'AvatarDetailPageState(newActiveImagePath: $newActiveImagePath, newStopImagePath: $newStopImagePath, avatar: $avatar, selectedAvatarId: $selectedAvatarId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AvatarDetailPageState &&
            (identical(other.newActiveImagePath, newActiveImagePath) ||
                other.newActiveImagePath == newActiveImagePath) &&
            (identical(other.newStopImagePath, newStopImagePath) ||
                other.newStopImagePath == newStopImagePath) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.selectedAvatarId, selectedAvatarId) ||
                other.selectedAvatarId == selectedAvatarId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, newActiveImagePath,
      newStopImagePath, avatar, selectedAvatarId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AvatarDetailPageStateCopyWith<_$_AvatarDetailPageState> get copyWith =>
      __$$_AvatarDetailPageStateCopyWithImpl<_$_AvatarDetailPageState>(
          this, _$identity);
}

abstract class _AvatarDetailPageState implements AvatarDetailPageState {
  const factory _AvatarDetailPageState(
      {final String newActiveImagePath,
      final String newStopImagePath,
      final Avatar? avatar,
      final String selectedAvatarId}) = _$_AvatarDetailPageState;

  @override
  String get newActiveImagePath;
  @override
  String get newStopImagePath;
  @override
  Avatar? get avatar;
  @override
  String get selectedAvatarId;
  @override
  @JsonKey(ignore: true)
  _$$_AvatarDetailPageStateCopyWith<_$_AvatarDetailPageState> get copyWith =>
      throw _privateConstructorUsedError;
}
