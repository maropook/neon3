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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RecordingPageState {
  CameraService? get cameraService => throw _privateConstructorUsedError;
  bool get isRecordingVideo => throw _privateConstructorUsedError;
  String? get videoFilePath => throw _privateConstructorUsedError;
  String? get audioFilePath => throw _privateConstructorUsedError;
  double get currentSeconds => throw _privateConstructorUsedError;
  bool get isAvatarActive => throw _privateConstructorUsedError;
  Avatar? get selectedAvatar => throw _privateConstructorUsedError;
  List<ActiveFrame> get activeFrames => throw _privateConstructorUsedError;
  RecordingType get recordingType => throw _privateConstructorUsedError;
  String get importedFilePath => throw _privateConstructorUsedError;
  double get recordingBackgroundWidth => throw _privateConstructorUsedError;

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
      String? audioFilePath,
      double currentSeconds,
      bool isAvatarActive,
      Avatar? selectedAvatar,
      List<ActiveFrame> activeFrames,
      RecordingType recordingType,
      String importedFilePath,
      double recordingBackgroundWidth});

  $AvatarCopyWith<$Res>? get selectedAvatar;
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
    Object? currentSeconds = null,
    Object? isAvatarActive = null,
    Object? selectedAvatar = freezed,
    Object? activeFrames = null,
    Object? recordingType = null,
    Object? importedFilePath = null,
    Object? recordingBackgroundWidth = null,
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
      currentSeconds: null == currentSeconds
          ? _value.currentSeconds
          : currentSeconds // ignore: cast_nullable_to_non_nullable
              as double,
      isAvatarActive: null == isAvatarActive
          ? _value.isAvatarActive
          : isAvatarActive // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedAvatar: freezed == selectedAvatar
          ? _value.selectedAvatar
          : selectedAvatar // ignore: cast_nullable_to_non_nullable
              as Avatar?,
      activeFrames: null == activeFrames
          ? _value.activeFrames
          : activeFrames // ignore: cast_nullable_to_non_nullable
              as List<ActiveFrame>,
      recordingType: null == recordingType
          ? _value.recordingType
          : recordingType // ignore: cast_nullable_to_non_nullable
              as RecordingType,
      importedFilePath: null == importedFilePath
          ? _value.importedFilePath
          : importedFilePath // ignore: cast_nullable_to_non_nullable
              as String,
      recordingBackgroundWidth: null == recordingBackgroundWidth
          ? _value.recordingBackgroundWidth
          : recordingBackgroundWidth // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AvatarCopyWith<$Res>? get selectedAvatar {
    if (_value.selectedAvatar == null) {
      return null;
    }

    return $AvatarCopyWith<$Res>(_value.selectedAvatar!, (value) {
      return _then(_value.copyWith(selectedAvatar: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CameraStateImplCopyWith<$Res>
    implements $RecordingPageStateCopyWith<$Res> {
  factory _$$CameraStateImplCopyWith(
          _$CameraStateImpl value, $Res Function(_$CameraStateImpl) then) =
      __$$CameraStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {CameraService? cameraService,
      bool isRecordingVideo,
      String? videoFilePath,
      String? audioFilePath,
      double currentSeconds,
      bool isAvatarActive,
      Avatar? selectedAvatar,
      List<ActiveFrame> activeFrames,
      RecordingType recordingType,
      String importedFilePath,
      double recordingBackgroundWidth});

  @override
  $AvatarCopyWith<$Res>? get selectedAvatar;
}

/// @nodoc
class __$$CameraStateImplCopyWithImpl<$Res>
    extends _$RecordingPageStateCopyWithImpl<$Res, _$CameraStateImpl>
    implements _$$CameraStateImplCopyWith<$Res> {
  __$$CameraStateImplCopyWithImpl(
      _$CameraStateImpl _value, $Res Function(_$CameraStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cameraService = freezed,
    Object? isRecordingVideo = null,
    Object? videoFilePath = freezed,
    Object? audioFilePath = freezed,
    Object? currentSeconds = null,
    Object? isAvatarActive = null,
    Object? selectedAvatar = freezed,
    Object? activeFrames = null,
    Object? recordingType = null,
    Object? importedFilePath = null,
    Object? recordingBackgroundWidth = null,
  }) {
    return _then(_$CameraStateImpl(
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
      currentSeconds: null == currentSeconds
          ? _value.currentSeconds
          : currentSeconds // ignore: cast_nullable_to_non_nullable
              as double,
      isAvatarActive: null == isAvatarActive
          ? _value.isAvatarActive
          : isAvatarActive // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedAvatar: freezed == selectedAvatar
          ? _value.selectedAvatar
          : selectedAvatar // ignore: cast_nullable_to_non_nullable
              as Avatar?,
      activeFrames: null == activeFrames
          ? _value._activeFrames
          : activeFrames // ignore: cast_nullable_to_non_nullable
              as List<ActiveFrame>,
      recordingType: null == recordingType
          ? _value.recordingType
          : recordingType // ignore: cast_nullable_to_non_nullable
              as RecordingType,
      importedFilePath: null == importedFilePath
          ? _value.importedFilePath
          : importedFilePath // ignore: cast_nullable_to_non_nullable
              as String,
      recordingBackgroundWidth: null == recordingBackgroundWidth
          ? _value.recordingBackgroundWidth
          : recordingBackgroundWidth // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$CameraStateImpl implements _CameraState {
  const _$CameraStateImpl(
      {this.cameraService = null,
      this.isRecordingVideo = false,
      this.videoFilePath = null,
      this.audioFilePath = null,
      this.currentSeconds = 0.0,
      this.isAvatarActive = false,
      this.selectedAvatar = null,
      final List<ActiveFrame> activeFrames = const [],
      this.recordingType = RecordingType.camera,
      this.importedFilePath = '',
      this.recordingBackgroundWidth = 1.0})
      : _activeFrames = activeFrames;

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
  @JsonKey()
  final double currentSeconds;
  @override
  @JsonKey()
  final bool isAvatarActive;
  @override
  @JsonKey()
  final Avatar? selectedAvatar;
  final List<ActiveFrame> _activeFrames;
  @override
  @JsonKey()
  List<ActiveFrame> get activeFrames {
    if (_activeFrames is EqualUnmodifiableListView) return _activeFrames;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_activeFrames);
  }

  @override
  @JsonKey()
  final RecordingType recordingType;
  @override
  @JsonKey()
  final String importedFilePath;
  @override
  @JsonKey()
  final double recordingBackgroundWidth;

  @override
  String toString() {
    return 'RecordingPageState(cameraService: $cameraService, isRecordingVideo: $isRecordingVideo, videoFilePath: $videoFilePath, audioFilePath: $audioFilePath, currentSeconds: $currentSeconds, isAvatarActive: $isAvatarActive, selectedAvatar: $selectedAvatar, activeFrames: $activeFrames, recordingType: $recordingType, importedFilePath: $importedFilePath, recordingBackgroundWidth: $recordingBackgroundWidth)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CameraStateImpl &&
            (identical(other.cameraService, cameraService) ||
                other.cameraService == cameraService) &&
            (identical(other.isRecordingVideo, isRecordingVideo) ||
                other.isRecordingVideo == isRecordingVideo) &&
            (identical(other.videoFilePath, videoFilePath) ||
                other.videoFilePath == videoFilePath) &&
            (identical(other.audioFilePath, audioFilePath) ||
                other.audioFilePath == audioFilePath) &&
            (identical(other.currentSeconds, currentSeconds) ||
                other.currentSeconds == currentSeconds) &&
            (identical(other.isAvatarActive, isAvatarActive) ||
                other.isAvatarActive == isAvatarActive) &&
            (identical(other.selectedAvatar, selectedAvatar) ||
                other.selectedAvatar == selectedAvatar) &&
            const DeepCollectionEquality()
                .equals(other._activeFrames, _activeFrames) &&
            (identical(other.recordingType, recordingType) ||
                other.recordingType == recordingType) &&
            (identical(other.importedFilePath, importedFilePath) ||
                other.importedFilePath == importedFilePath) &&
            (identical(
                    other.recordingBackgroundWidth, recordingBackgroundWidth) ||
                other.recordingBackgroundWidth == recordingBackgroundWidth));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      cameraService,
      isRecordingVideo,
      videoFilePath,
      audioFilePath,
      currentSeconds,
      isAvatarActive,
      selectedAvatar,
      const DeepCollectionEquality().hash(_activeFrames),
      recordingType,
      importedFilePath,
      recordingBackgroundWidth);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CameraStateImplCopyWith<_$CameraStateImpl> get copyWith =>
      __$$CameraStateImplCopyWithImpl<_$CameraStateImpl>(this, _$identity);
}

abstract class _CameraState implements RecordingPageState {
  const factory _CameraState(
      {final CameraService? cameraService,
      final bool isRecordingVideo,
      final String? videoFilePath,
      final String? audioFilePath,
      final double currentSeconds,
      final bool isAvatarActive,
      final Avatar? selectedAvatar,
      final List<ActiveFrame> activeFrames,
      final RecordingType recordingType,
      final String importedFilePath,
      final double recordingBackgroundWidth}) = _$CameraStateImpl;

  @override
  CameraService? get cameraService;
  @override
  bool get isRecordingVideo;
  @override
  String? get videoFilePath;
  @override
  String? get audioFilePath;
  @override
  double get currentSeconds;
  @override
  bool get isAvatarActive;
  @override
  Avatar? get selectedAvatar;
  @override
  List<ActiveFrame> get activeFrames;
  @override
  RecordingType get recordingType;
  @override
  String get importedFilePath;
  @override
  double get recordingBackgroundWidth;
  @override
  @JsonKey(ignore: true)
  _$$CameraStateImplCopyWith<_$CameraStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
