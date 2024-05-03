// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'avatar_edit_sheet_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AvatarEditSheetState {
  String get newActiveImagePath => throw _privateConstructorUsedError;
  String get newStopImagePath => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AvatarEditSheetStateCopyWith<AvatarEditSheetState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AvatarEditSheetStateCopyWith<$Res> {
  factory $AvatarEditSheetStateCopyWith(AvatarEditSheetState value,
          $Res Function(AvatarEditSheetState) then) =
      _$AvatarEditSheetStateCopyWithImpl<$Res, AvatarEditSheetState>;
  @useResult
  $Res call({String newActiveImagePath, String newStopImagePath});
}

/// @nodoc
class _$AvatarEditSheetStateCopyWithImpl<$Res,
        $Val extends AvatarEditSheetState>
    implements $AvatarEditSheetStateCopyWith<$Res> {
  _$AvatarEditSheetStateCopyWithImpl(this._value, this._then);

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
abstract class _$$AvatarEditSheetStateImplCopyWith<$Res>
    implements $AvatarEditSheetStateCopyWith<$Res> {
  factory _$$AvatarEditSheetStateImplCopyWith(_$AvatarEditSheetStateImpl value,
          $Res Function(_$AvatarEditSheetStateImpl) then) =
      __$$AvatarEditSheetStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String newActiveImagePath, String newStopImagePath});
}

/// @nodoc
class __$$AvatarEditSheetStateImplCopyWithImpl<$Res>
    extends _$AvatarEditSheetStateCopyWithImpl<$Res, _$AvatarEditSheetStateImpl>
    implements _$$AvatarEditSheetStateImplCopyWith<$Res> {
  __$$AvatarEditSheetStateImplCopyWithImpl(_$AvatarEditSheetStateImpl _value,
      $Res Function(_$AvatarEditSheetStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? newActiveImagePath = null,
    Object? newStopImagePath = null,
  }) {
    return _then(_$AvatarEditSheetStateImpl(
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

class _$AvatarEditSheetStateImpl implements _AvatarEditSheetState {
  const _$AvatarEditSheetStateImpl(
      {this.newActiveImagePath = "", this.newStopImagePath = ""});

  @override
  @JsonKey()
  final String newActiveImagePath;
  @override
  @JsonKey()
  final String newStopImagePath;

  @override
  String toString() {
    return 'AvatarEditSheetState(newActiveImagePath: $newActiveImagePath, newStopImagePath: $newStopImagePath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AvatarEditSheetStateImpl &&
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
  _$$AvatarEditSheetStateImplCopyWith<_$AvatarEditSheetStateImpl>
      get copyWith =>
          __$$AvatarEditSheetStateImplCopyWithImpl<_$AvatarEditSheetStateImpl>(
              this, _$identity);
}

abstract class _AvatarEditSheetState implements AvatarEditSheetState {
  const factory _AvatarEditSheetState(
      {final String newActiveImagePath,
      final String newStopImagePath}) = _$AvatarEditSheetStateImpl;

  @override
  String get newActiveImagePath;
  @override
  String get newStopImagePath;
  @override
  @JsonKey(ignore: true)
  _$$AvatarEditSheetStateImplCopyWith<_$AvatarEditSheetStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
