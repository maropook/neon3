// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'avatar_add_sheet_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AvatarAddSheetState {
  String get newActiveImagePath => throw _privateConstructorUsedError;
  String get newStopImagePath => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AvatarAddSheetStateCopyWith<AvatarAddSheetState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AvatarAddSheetStateCopyWith<$Res> {
  factory $AvatarAddSheetStateCopyWith(
          AvatarAddSheetState value, $Res Function(AvatarAddSheetState) then) =
      _$AvatarAddSheetStateCopyWithImpl<$Res, AvatarAddSheetState>;
  @useResult
  $Res call({String newActiveImagePath, String newStopImagePath});
}

/// @nodoc
class _$AvatarAddSheetStateCopyWithImpl<$Res, $Val extends AvatarAddSheetState>
    implements $AvatarAddSheetStateCopyWith<$Res> {
  _$AvatarAddSheetStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? newActiveImagePath = null,
    Object? newStopImagePath = null,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_AvatarAddSheetStateCopyWith<$Res>
    implements $AvatarAddSheetStateCopyWith<$Res> {
  factory _$$_AvatarAddSheetStateCopyWith(_$_AvatarAddSheetState value,
          $Res Function(_$_AvatarAddSheetState) then) =
      __$$_AvatarAddSheetStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String newActiveImagePath, String newStopImagePath});
}

/// @nodoc
class __$$_AvatarAddSheetStateCopyWithImpl<$Res>
    extends _$AvatarAddSheetStateCopyWithImpl<$Res, _$_AvatarAddSheetState>
    implements _$$_AvatarAddSheetStateCopyWith<$Res> {
  __$$_AvatarAddSheetStateCopyWithImpl(_$_AvatarAddSheetState _value,
      $Res Function(_$_AvatarAddSheetState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? newActiveImagePath = null,
    Object? newStopImagePath = null,
  }) {
    return _then(_$_AvatarAddSheetState(
      newActiveImagePath: null == newActiveImagePath
          ? _value.newActiveImagePath
          : newActiveImagePath // ignore: cast_nullable_to_non_nullable
              as String,
      newStopImagePath: null == newStopImagePath
          ? _value.newStopImagePath
          : newStopImagePath // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_AvatarAddSheetState implements _AvatarAddSheetState {
  const _$_AvatarAddSheetState(
      {this.newActiveImagePath = "", this.newStopImagePath = ""});

  @override
  @JsonKey()
  final String newActiveImagePath;
  @override
  @JsonKey()
  final String newStopImagePath;

  @override
  String toString() {
    return 'AvatarAddSheetState(newActiveImagePath: $newActiveImagePath, newStopImagePath: $newStopImagePath)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AvatarAddSheetState &&
            (identical(other.newActiveImagePath, newActiveImagePath) ||
                other.newActiveImagePath == newActiveImagePath) &&
            (identical(other.newStopImagePath, newStopImagePath) ||
                other.newStopImagePath == newStopImagePath));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, newActiveImagePath, newStopImagePath);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AvatarAddSheetStateCopyWith<_$_AvatarAddSheetState> get copyWith =>
      __$$_AvatarAddSheetStateCopyWithImpl<_$_AvatarAddSheetState>(
          this, _$identity);
}

abstract class _AvatarAddSheetState implements AvatarAddSheetState {
  const factory _AvatarAddSheetState(
      {final String newActiveImagePath,
      final String newStopImagePath}) = _$_AvatarAddSheetState;

  @override
  String get newActiveImagePath;
  @override
  String get newStopImagePath;
  @override
  @JsonKey(ignore: true)
  _$$_AvatarAddSheetStateCopyWith<_$_AvatarAddSheetState> get copyWith =>
      throw _privateConstructorUsedError;
}
