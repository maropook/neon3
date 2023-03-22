// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recording_page_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$RecordingPageState {
  CameraService? get cameraService => throw _privateConstructorUsedError;
  bool get isRecordingVideo => throw _privateConstructorUsedError;
  String? get videoFilePath => throw _privateConstructorUsedError;
  String? get audioFilePath => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RecordingPageStateCopyWith<RecordingPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecordingPageStateCopyWith<$Res> {
  factory $RecordingPageStateCopyWith(
          RecordingPageState value, $Res Function(RecordingPageState) then) =
      _$RecordingPageStateCopyWithImpl<$Res, RecordingPageState>;
  @useResult
  $Res call(
      {CameraService? cameraService,
      bool isRecordingVideo,
      String? videoFilePath,
      String? audioFilePath});
}

/// @nodoc
class _$RecordingPageStateCopyWithImpl<$Res, $Val extends RecordingPageState>
    implements $RecordingPageStateCopyWith<$Res> {
  _$RecordingPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cameraService = freezed,
    Object? isRecordingVideo = null,
    Object? videoFilePath = freezed,
    Object? audioFilePath = freezed,
  }) {
    return _then(_value.copyWith(
      cameraService: freezed == cameraService
          ? _value.cameraService
          : cameraService // ignore: cast_nullable_to_non_nullable
              as CameraService?,
      isRecordingVideo: null == isRecordingVideo
          ? _value.isRecordingVideo
          : isRecordingVideo // ignore: cast_nullable_to_non_nullable
              as bool,
      videoFilePath: freezed == videoFilePath
          ? _value.videoFilePath
          : videoFilePath // ignore: cast_nullable_to_non_nullable
              as String?,
      audioFilePath: freezed == audioFilePath
          ? _value.audioFilePath
          : audioFilePath // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_CameraStateCopyWith<$Res>
    implements $RecordingPageStateCopyWith<$Res> {
  factory _$$_CameraStateCopyWith(
          _$_CameraState value, $Res Function(_$_CameraState) then) =
      __$$_CameraStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {CameraService? cameraService,
      bool isRecordingVideo,
      String? videoFilePath,
      String? audioFilePath});
}

/// @nodoc
class __$$_CameraStateCopyWithImpl<$Res>
    extends _$RecordingPageStateCopyWithImpl<$Res, _$_CameraState>
    implements _$$_CameraStateCopyWith<$Res> {
  __$$_CameraStateCopyWithImpl(
      _$_CameraState _value, $Res Function(_$_CameraState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cameraService = freezed,
    Object? isRecordingVideo = null,
    Object? videoFilePath = freezed,
    Object? audioFilePath = freezed,
  }) {
    return _then(_$_CameraState(
      cameraService: freezed == cameraService
          ? _value.cameraService
          : cameraService // ignore: cast_nullable_to_non_nullable
              as CameraService?,
      isRecordingVideo: null == isRecordingVideo
          ? _value.isRecordingVideo
          : isRecordingVideo // ignore: cast_nullable_to_non_nullable
              as bool,
      videoFilePath: freezed == videoFilePath
          ? _value.videoFilePath
          : videoFilePath // ignore: cast_nullable_to_non_nullable
              as String?,
      audioFilePath: freezed == audioFilePath
          ? _value.audioFilePath
          : audioFilePath // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_CameraState implements _CameraState {
  const _$_CameraState(
      {this.cameraService = null,
      this.isRecordingVideo = false,
      this.videoFilePath = null,
      this.audioFilePath = null});

  @override
  @JsonKey()
  final CameraService? cameraService;
  @override
  @JsonKey()
  final bool isRecordingVideo;
  @override
  @JsonKey()
  final String? videoFilePath;
  @override
  @JsonKey()
  final String? audioFilePath;

  @override
  String toString() {
    return 'RecordingPageState(cameraService: $cameraService, isRecordingVideo: $isRecordingVideo, videoFilePath: $videoFilePath, audioFilePath: $audioFilePath)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CameraState &&
            (identical(other.cameraService, cameraService) ||
                other.cameraService == cameraService) &&
            (identical(other.isRecordingVideo, isRecordingVideo) ||
                other.isRecordingVideo == isRecordingVideo) &&
            (identical(other.videoFilePath, videoFilePath) ||
                other.videoFilePath == videoFilePath) &&
            (identical(other.audioFilePath, audioFilePath) ||
                other.audioFilePath == audioFilePath));
  }

  @override
  int get hashCode => Object.hash(runtimeType, cameraService, isRecordingVideo,
      videoFilePath, audioFilePath);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CameraStateCopyWith<_$_CameraState> get copyWith =>
      __$$_CameraStateCopyWithImpl<_$_CameraState>(this, _$identity);
}

abstract class _CameraState implements RecordingPageState {
  const factory _CameraState(
      {final CameraService? cameraService,
      final bool isRecordingVideo,
      final String? videoFilePath,
      final String? audioFilePath}) = _$_CameraState;

  @override
  CameraService? get cameraService;
  @override
  bool get isRecordingVideo;
  @override
  String? get videoFilePath;
  @override
  String? get audioFilePath;
  @override
  @JsonKey(ignore: true)
  _$$_CameraStateCopyWith<_$_CameraState> get copyWith =>
      throw _privateConstructorUsedError;
}
