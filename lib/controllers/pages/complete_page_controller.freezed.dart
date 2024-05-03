// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'complete_page_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CompletePageState {
  bool get isPlaying => throw _privateConstructorUsedError;
  VideoPlayerService? get videoPlayerService =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CompletePageStateCopyWith<CompletePageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompletePageStateCopyWith<$Res> {
  factory $CompletePageStateCopyWith(
          CompletePageState value, $Res Function(CompletePageState) then) =
      _$CompletePageStateCopyWithImpl<$Res, CompletePageState>;
  @useResult
  $Res call({bool isPlaying, VideoPlayerService? videoPlayerService});
}

/// @nodoc
class _$CompletePageStateCopyWithImpl<$Res, $Val extends CompletePageState>
    implements $CompletePageStateCopyWith<$Res> {
  _$CompletePageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isPlaying = null,
    Object? videoPlayerService = freezed,
  }) {
    return _then(_value.copyWith(
      isPlaying: null == isPlaying
          ? _value.isPlaying
          : isPlaying // ignore: cast_nullable_to_non_nullable
              as bool,
      videoPlayerService: freezed == videoPlayerService
          ? _value.videoPlayerService
          : videoPlayerService // ignore: cast_nullable_to_non_nullable
              as VideoPlayerService?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CompletePageStateImplCopyWith<$Res>
    implements $CompletePageStateCopyWith<$Res> {
  factory _$$CompletePageStateImplCopyWith(_$CompletePageStateImpl value,
          $Res Function(_$CompletePageStateImpl) then) =
      __$$CompletePageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isPlaying, VideoPlayerService? videoPlayerService});
}

/// @nodoc
class __$$CompletePageStateImplCopyWithImpl<$Res>
    extends _$CompletePageStateCopyWithImpl<$Res, _$CompletePageStateImpl>
    implements _$$CompletePageStateImplCopyWith<$Res> {
  __$$CompletePageStateImplCopyWithImpl(_$CompletePageStateImpl _value,
      $Res Function(_$CompletePageStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isPlaying = null,
    Object? videoPlayerService = freezed,
  }) {
    return _then(_$CompletePageStateImpl(
      isPlaying: null == isPlaying
          ? _value.isPlaying
          : isPlaying // ignore: cast_nullable_to_non_nullable
              as bool,
      videoPlayerService: freezed == videoPlayerService
          ? _value.videoPlayerService
          : videoPlayerService // ignore: cast_nullable_to_non_nullable
              as VideoPlayerService?,
    ));
  }
}

/// @nodoc

class _$CompletePageStateImpl implements _CompletePageState {
  const _$CompletePageStateImpl(
      {this.isPlaying = false, this.videoPlayerService = null});

  @override
  @JsonKey()
  final bool isPlaying;
  @override
  @JsonKey()
  final VideoPlayerService? videoPlayerService;

  @override
  String toString() {
    return 'CompletePageState(isPlaying: $isPlaying, videoPlayerService: $videoPlayerService)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompletePageStateImpl &&
            (identical(other.isPlaying, isPlaying) ||
                other.isPlaying == isPlaying) &&
            (identical(other.videoPlayerService, videoPlayerService) ||
                other.videoPlayerService == videoPlayerService));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isPlaying, videoPlayerService);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CompletePageStateImplCopyWith<_$CompletePageStateImpl> get copyWith =>
      __$$CompletePageStateImplCopyWithImpl<_$CompletePageStateImpl>(
          this, _$identity);
}

abstract class _CompletePageState implements CompletePageState {
  const factory _CompletePageState(
      {final bool isPlaying,
      final VideoPlayerService? videoPlayerService}) = _$CompletePageStateImpl;

  @override
  bool get isPlaying;
  @override
  VideoPlayerService? get videoPlayerService;
  @override
  @JsonKey(ignore: true)
  _$$CompletePageStateImplCopyWith<_$CompletePageStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
