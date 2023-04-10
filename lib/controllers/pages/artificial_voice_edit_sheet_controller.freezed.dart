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
  $Res call({AudioType audioType});
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
  }) {
    return _then(_value.copyWith(
      audioType: null == audioType
          ? _value.audioType
          : audioType // ignore: cast_nullable_to_non_nullable
              as AudioType,
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
  $Res call({AudioType audioType});
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
  }) {
    return _then(_$_ArtificialVoiceEditSheetState(
      audioType: null == audioType
          ? _value.audioType
          : audioType // ignore: cast_nullable_to_non_nullable
              as AudioType,
    ));
  }
}

/// @nodoc

class _$_ArtificialVoiceEditSheetState
    implements _ArtificialVoiceEditSheetState {
  const _$_ArtificialVoiceEditSheetState({this.audioType = AudioType.original});

  @override
  @JsonKey()
  final AudioType audioType;

  @override
  String toString() {
    return 'ArtificialVoiceEditSheetState(audioType: $audioType)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ArtificialVoiceEditSheetState &&
            (identical(other.audioType, audioType) ||
                other.audioType == audioType));
  }

  @override
  int get hashCode => Object.hash(runtimeType, audioType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ArtificialVoiceEditSheetStateCopyWith<_$_ArtificialVoiceEditSheetState>
      get copyWith => __$$_ArtificialVoiceEditSheetStateCopyWithImpl<
          _$_ArtificialVoiceEditSheetState>(this, _$identity);
}

abstract class _ArtificialVoiceEditSheetState
    implements ArtificialVoiceEditSheetState {
  const factory _ArtificialVoiceEditSheetState({final AudioType audioType}) =
      _$_ArtificialVoiceEditSheetState;

  @override
  AudioType get audioType;
  @override
  @JsonKey(ignore: true)
  _$$_ArtificialVoiceEditSheetStateCopyWith<_$_ArtificialVoiceEditSheetState>
      get copyWith => throw _privateConstructorUsedError;
}
