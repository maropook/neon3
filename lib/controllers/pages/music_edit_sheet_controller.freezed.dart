// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'music_edit_sheet_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$MusicEditSheetState {
  String get musicFilePath => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MusicEditSheetStateCopyWith<MusicEditSheetState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MusicEditSheetStateCopyWith<$Res> {
  factory $MusicEditSheetStateCopyWith(
          MusicEditSheetState value, $Res Function(MusicEditSheetState) then) =
      _$MusicEditSheetStateCopyWithImpl<$Res, MusicEditSheetState>;
  @useResult
  $Res call({String musicFilePath});
}

/// @nodoc
class _$MusicEditSheetStateCopyWithImpl<$Res, $Val extends MusicEditSheetState>
    implements $MusicEditSheetStateCopyWith<$Res> {
  _$MusicEditSheetStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? musicFilePath = null,
  }) {
    return _then(_value.copyWith(
      musicFilePath: null == musicFilePath
          ? _value.musicFilePath
          : musicFilePath // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_MusicEditSheetStateCopyWith<$Res>
    implements $MusicEditSheetStateCopyWith<$Res> {
  factory _$$_MusicEditSheetStateCopyWith(_$_MusicEditSheetState value,
          $Res Function(_$_MusicEditSheetState) then) =
      __$$_MusicEditSheetStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String musicFilePath});
}

/// @nodoc
class __$$_MusicEditSheetStateCopyWithImpl<$Res>
    extends _$MusicEditSheetStateCopyWithImpl<$Res, _$_MusicEditSheetState>
    implements _$$_MusicEditSheetStateCopyWith<$Res> {
  __$$_MusicEditSheetStateCopyWithImpl(_$_MusicEditSheetState _value,
      $Res Function(_$_MusicEditSheetState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? musicFilePath = null,
  }) {
    return _then(_$_MusicEditSheetState(
      musicFilePath: null == musicFilePath
          ? _value.musicFilePath
          : musicFilePath // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_MusicEditSheetState implements _MusicEditSheetState {
  const _$_MusicEditSheetState({this.musicFilePath = ''});

  @override
  @JsonKey()
  final String musicFilePath;

  @override
  String toString() {
    return 'MusicEditSheetState(musicFilePath: $musicFilePath)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MusicEditSheetState &&
            (identical(other.musicFilePath, musicFilePath) ||
                other.musicFilePath == musicFilePath));
  }

  @override
  int get hashCode => Object.hash(runtimeType, musicFilePath);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_MusicEditSheetStateCopyWith<_$_MusicEditSheetState> get copyWith =>
      __$$_MusicEditSheetStateCopyWithImpl<_$_MusicEditSheetState>(
          this, _$identity);
}

abstract class _MusicEditSheetState implements MusicEditSheetState {
  const factory _MusicEditSheetState({final String musicFilePath}) =
      _$_MusicEditSheetState;

  @override
  String get musicFilePath;
  @override
  @JsonKey(ignore: true)
  _$$_MusicEditSheetStateCopyWith<_$_MusicEditSheetState> get copyWith =>
      throw _privateConstructorUsedError;
}
