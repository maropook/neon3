// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'artificial_voice_edit_sheet_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ArtificialVoiceEditSheetState {
  AudioType get audioType => throw _privateConstructorUsedError;
  List<SubtitleText> get subtitleTexts => throw _privateConstructorUsedError;
  bool get isMergeTtsAudio => throw _privateConstructorUsedError;
  String get ttsAudioFilePath => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ArtificialVoiceEditSheetStateCopyWith<ArtificialVoiceEditSheetState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArtificialVoiceEditSheetStateCopyWith<$Res> {
  factory $ArtificialVoiceEditSheetStateCopyWith(
          ArtificialVoiceEditSheetState value,
          $Res Function(ArtificialVoiceEditSheetState) then) =
      _$ArtificialVoiceEditSheetStateCopyWithImpl<$Res,
          ArtificialVoiceEditSheetState>;
  @useResult
  $Res call(
      {AudioType audioType,
      List<SubtitleText> subtitleTexts,
      bool isMergeTtsAudio,
      String ttsAudioFilePath});
}

/// @nodoc
class _$ArtificialVoiceEditSheetStateCopyWithImpl<$Res,
        $Val extends ArtificialVoiceEditSheetState>
    implements $ArtificialVoiceEditSheetStateCopyWith<$Res> {
  _$ArtificialVoiceEditSheetStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? audioType = null,
    Object? subtitleTexts = null,
    Object? isMergeTtsAudio = null,
    Object? ttsAudioFilePath = null,
  }) {
    return _then(_value.copyWith(
      audioType: null == audioType
          ? _value.audioType
          : audioType // ignore: cast_nullable_to_non_nullable
              as AudioType,
      subtitleTexts: null == subtitleTexts
          ? _value.subtitleTexts
          : subtitleTexts // ignore: cast_nullable_to_non_nullable
              as List<SubtitleText>,
      isMergeTtsAudio: null == isMergeTtsAudio
          ? _value.isMergeTtsAudio
          : isMergeTtsAudio // ignore: cast_nullable_to_non_nullable
              as bool,
      ttsAudioFilePath: null == ttsAudioFilePath
          ? _value.ttsAudioFilePath
          : ttsAudioFilePath // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ArtificialVoiceEditSheetStateCopyWith<$Res>
    implements $ArtificialVoiceEditSheetStateCopyWith<$Res> {
  factory _$$_ArtificialVoiceEditSheetStateCopyWith(
          _$_ArtificialVoiceEditSheetState value,
          $Res Function(_$_ArtificialVoiceEditSheetState) then) =
      __$$_ArtificialVoiceEditSheetStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AudioType audioType,
      List<SubtitleText> subtitleTexts,
      bool isMergeTtsAudio,
      String ttsAudioFilePath});
}

/// @nodoc
class __$$_ArtificialVoiceEditSheetStateCopyWithImpl<$Res>
    extends _$ArtificialVoiceEditSheetStateCopyWithImpl<$Res,
        _$_ArtificialVoiceEditSheetState>
    implements _$$_ArtificialVoiceEditSheetStateCopyWith<$Res> {
  __$$_ArtificialVoiceEditSheetStateCopyWithImpl(
      _$_ArtificialVoiceEditSheetState _value,
      $Res Function(_$_ArtificialVoiceEditSheetState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? audioType = null,
    Object? subtitleTexts = null,
    Object? isMergeTtsAudio = null,
    Object? ttsAudioFilePath = null,
  }) {
    return _then(_$_ArtificialVoiceEditSheetState(
      audioType: null == audioType
          ? _value.audioType
          : audioType // ignore: cast_nullable_to_non_nullable
              as AudioType,
      subtitleTexts: null == subtitleTexts
          ? _value._subtitleTexts
          : subtitleTexts // ignore: cast_nullable_to_non_nullable
              as List<SubtitleText>,
      isMergeTtsAudio: null == isMergeTtsAudio
          ? _value.isMergeTtsAudio
          : isMergeTtsAudio // ignore: cast_nullable_to_non_nullable
              as bool,
      ttsAudioFilePath: null == ttsAudioFilePath
          ? _value.ttsAudioFilePath
          : ttsAudioFilePath // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_ArtificialVoiceEditSheetState
    implements _ArtificialVoiceEditSheetState {
  const _$_ArtificialVoiceEditSheetState(
      {this.audioType = AudioType.original,
      final List<SubtitleText> subtitleTexts = const [],
      this.isMergeTtsAudio = false,
      this.ttsAudioFilePath = ''})
      : _subtitleTexts = subtitleTexts;

  @override
  @JsonKey()
  final AudioType audioType;
  final List<SubtitleText> _subtitleTexts;
  @override
  @JsonKey()
  List<SubtitleText> get subtitleTexts {
    if (_subtitleTexts is EqualUnmodifiableListView) return _subtitleTexts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_subtitleTexts);
  }

  @override
  @JsonKey()
  final bool isMergeTtsAudio;
  @override
  @JsonKey()
  final String ttsAudioFilePath;

  @override
  String toString() {
    return 'ArtificialVoiceEditSheetState(audioType: $audioType, subtitleTexts: $subtitleTexts, isMergeTtsAudio: $isMergeTtsAudio, ttsAudioFilePath: $ttsAudioFilePath)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ArtificialVoiceEditSheetState &&
            (identical(other.audioType, audioType) ||
                other.audioType == audioType) &&
            const DeepCollectionEquality()
                .equals(other._subtitleTexts, _subtitleTexts) &&
            (identical(other.isMergeTtsAudio, isMergeTtsAudio) ||
                other.isMergeTtsAudio == isMergeTtsAudio) &&
            (identical(other.ttsAudioFilePath, ttsAudioFilePath) ||
                other.ttsAudioFilePath == ttsAudioFilePath));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      audioType,
      const DeepCollectionEquality().hash(_subtitleTexts),
      isMergeTtsAudio,
      ttsAudioFilePath);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ArtificialVoiceEditSheetStateCopyWith<_$_ArtificialVoiceEditSheetState>
      get copyWith => __$$_ArtificialVoiceEditSheetStateCopyWithImpl<
          _$_ArtificialVoiceEditSheetState>(this, _$identity);
}

abstract class _ArtificialVoiceEditSheetState
    implements ArtificialVoiceEditSheetState {
  const factory _ArtificialVoiceEditSheetState(
      {final AudioType audioType,
      final List<SubtitleText> subtitleTexts,
      final bool isMergeTtsAudio,
      final String ttsAudioFilePath}) = _$_ArtificialVoiceEditSheetState;

  @override
  AudioType get audioType;
  @override
  List<SubtitleText> get subtitleTexts;
  @override
  bool get isMergeTtsAudio;
  @override
  String get ttsAudioFilePath;
  @override
  @JsonKey(ignore: true)
  _$$_ArtificialVoiceEditSheetStateCopyWith<_$_ArtificialVoiceEditSheetState>
      get copyWith => throw _privateConstructorUsedError;
}
