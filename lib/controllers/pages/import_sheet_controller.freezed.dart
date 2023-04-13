// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'import_sheet_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ImportSheetState {
  String get videoFilePath => throw _privateConstructorUsedError;
  String get imageFilePath => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ImportSheetStateCopyWith<ImportSheetState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImportSheetStateCopyWith<$Res> {
  factory $ImportSheetStateCopyWith(
          ImportSheetState value, $Res Function(ImportSheetState) then) =
      _$ImportSheetStateCopyWithImpl<$Res, ImportSheetState>;
  @useResult
  $Res call({String videoFilePath, String imageFilePath});
}

/// @nodoc
class _$ImportSheetStateCopyWithImpl<$Res, $Val extends ImportSheetState>
    implements $ImportSheetStateCopyWith<$Res> {
  _$ImportSheetStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? videoFilePath = null,
    Object? imageFilePath = null,
  }) {
    return _then(_value.copyWith(
      videoFilePath: null == videoFilePath
          ? _value.videoFilePath
          : videoFilePath // ignore: cast_nullable_to_non_nullable
              as String,
      imageFilePath: null == imageFilePath
          ? _value.imageFilePath
          : imageFilePath // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ImportSheetStateCopyWith<$Res>
    implements $ImportSheetStateCopyWith<$Res> {
  factory _$$_ImportSheetStateCopyWith(
          _$_ImportSheetState value, $Res Function(_$_ImportSheetState) then) =
      __$$_ImportSheetStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String videoFilePath, String imageFilePath});
}

/// @nodoc
class __$$_ImportSheetStateCopyWithImpl<$Res>
    extends _$ImportSheetStateCopyWithImpl<$Res, _$_ImportSheetState>
    implements _$$_ImportSheetStateCopyWith<$Res> {
  __$$_ImportSheetStateCopyWithImpl(
      _$_ImportSheetState _value, $Res Function(_$_ImportSheetState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? videoFilePath = null,
    Object? imageFilePath = null,
  }) {
    return _then(_$_ImportSheetState(
      videoFilePath: null == videoFilePath
          ? _value.videoFilePath
          : videoFilePath // ignore: cast_nullable_to_non_nullable
              as String,
      imageFilePath: null == imageFilePath
          ? _value.imageFilePath
          : imageFilePath // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_ImportSheetState implements _ImportSheetState {
  const _$_ImportSheetState({this.videoFilePath = '', this.imageFilePath = ''});

  @override
  @JsonKey()
  final String videoFilePath;
  @override
  @JsonKey()
  final String imageFilePath;

  @override
  String toString() {
    return 'ImportSheetState(videoFilePath: $videoFilePath, imageFilePath: $imageFilePath)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ImportSheetState &&
            (identical(other.videoFilePath, videoFilePath) ||
                other.videoFilePath == videoFilePath) &&
            (identical(other.imageFilePath, imageFilePath) ||
                other.imageFilePath == imageFilePath));
  }

  @override
  int get hashCode => Object.hash(runtimeType, videoFilePath, imageFilePath);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ImportSheetStateCopyWith<_$_ImportSheetState> get copyWith =>
      __$$_ImportSheetStateCopyWithImpl<_$_ImportSheetState>(this, _$identity);
}

abstract class _ImportSheetState implements ImportSheetState {
  const factory _ImportSheetState(
      {final String videoFilePath,
      final String imageFilePath}) = _$_ImportSheetState;

  @override
  String get videoFilePath;
  @override
  String get imageFilePath;
  @override
  @JsonKey(ignore: true)
  _$$_ImportSheetStateCopyWith<_$_ImportSheetState> get copyWith =>
      throw _privateConstructorUsedError;
}
