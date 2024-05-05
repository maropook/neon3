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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ImportSheetState {
  String get videoFilePath => throw _privateConstructorUsedError;
  String get imageFilePath => throw _privateConstructorUsedError;
  RecordingType get recordingType => throw _privateConstructorUsedError;

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
  $Res call(
      {String videoFilePath,
      String imageFilePath,
      RecordingType recordingType});
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
    Object? recordingType = null,
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
      recordingType: null == recordingType
          ? _value.recordingType
          : recordingType // ignore: cast_nullable_to_non_nullable
              as RecordingType,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ImportSheetStateImplCopyWith<$Res>
    implements $ImportSheetStateCopyWith<$Res> {
  factory _$$ImportSheetStateImplCopyWith(_$ImportSheetStateImpl value,
          $Res Function(_$ImportSheetStateImpl) then) =
      __$$ImportSheetStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String videoFilePath,
      String imageFilePath,
      RecordingType recordingType});
}

/// @nodoc
class __$$ImportSheetStateImplCopyWithImpl<$Res>
    extends _$ImportSheetStateCopyWithImpl<$Res, _$ImportSheetStateImpl>
    implements _$$ImportSheetStateImplCopyWith<$Res> {
  __$$ImportSheetStateImplCopyWithImpl(_$ImportSheetStateImpl _value,
      $Res Function(_$ImportSheetStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? videoFilePath = null,
    Object? imageFilePath = null,
    Object? recordingType = null,
  }) {
    return _then(_$ImportSheetStateImpl(
      videoFilePath: null == videoFilePath
          ? _value.videoFilePath
          : videoFilePath // ignore: cast_nullable_to_non_nullable
              as String,
      imageFilePath: null == imageFilePath
          ? _value.imageFilePath
          : imageFilePath // ignore: cast_nullable_to_non_nullable
              as String,
      recordingType: null == recordingType
          ? _value.recordingType
          : recordingType // ignore: cast_nullable_to_non_nullable
              as RecordingType,
    ));
  }
}

/// @nodoc

class _$ImportSheetStateImpl implements _ImportSheetState {
  const _$ImportSheetStateImpl(
      {this.videoFilePath = '',
      this.imageFilePath = '',
      this.recordingType = RecordingType.camera});

  @override
  @JsonKey()
  final String videoFilePath;
  @override
  @JsonKey()
  final String imageFilePath;
  @override
  @JsonKey()
  final RecordingType recordingType;

  @override
  String toString() {
    return 'ImportSheetState(videoFilePath: $videoFilePath, imageFilePath: $imageFilePath, recordingType: $recordingType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImportSheetStateImpl &&
            (identical(other.videoFilePath, videoFilePath) ||
                other.videoFilePath == videoFilePath) &&
            (identical(other.imageFilePath, imageFilePath) ||
                other.imageFilePath == imageFilePath) &&
            (identical(other.recordingType, recordingType) ||
                other.recordingType == recordingType));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, videoFilePath, imageFilePath, recordingType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ImportSheetStateImplCopyWith<_$ImportSheetStateImpl> get copyWith =>
      __$$ImportSheetStateImplCopyWithImpl<_$ImportSheetStateImpl>(
          this, _$identity);
}

abstract class _ImportSheetState implements ImportSheetState {
  const factory _ImportSheetState(
      {final String videoFilePath,
      final String imageFilePath,
      final RecordingType recordingType}) = _$ImportSheetStateImpl;

  @override
  String get videoFilePath;
  @override
  String get imageFilePath;
  @override
  RecordingType get recordingType;
  @override
  @JsonKey(ignore: true)
  _$$ImportSheetStateImplCopyWith<_$ImportSheetStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
