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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$CompletePageState {
  bool get isPlaying => throw _privateConstructorUsedError;
  VideoPlayerController? get controller => throw _privateConstructorUsedError;

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
  $Res call({bool isPlaying, VideoPlayerController? controller});
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
    Object? controller = freezed,
  }) {
    return _then(_value.copyWith(
      isPlaying: null == isPlaying
          ? _value.isPlaying
          : isPlaying // ignore: cast_nullable_to_non_nullable
              as bool,
      controller: freezed == controller
          ? _value.controller
          : controller // ignore: cast_nullable_to_non_nullable
              as VideoPlayerController?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_CompletePageStateCopyWith<$Res>
    implements $CompletePageStateCopyWith<$Res> {
  factory _$$_CompletePageStateCopyWith(_$_CompletePageState value,
          $Res Function(_$_CompletePageState) then) =
      __$$_CompletePageStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isPlaying, VideoPlayerController? controller});
}

/// @nodoc
class __$$_CompletePageStateCopyWithImpl<$Res>
    extends _$CompletePageStateCopyWithImpl<$Res, _$_CompletePageState>
    implements _$$_CompletePageStateCopyWith<$Res> {
  __$$_CompletePageStateCopyWithImpl(
      _$_CompletePageState _value, $Res Function(_$_CompletePageState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isPlaying = null,
    Object? controller = freezed,
  }) {
    return _then(_$_CompletePageState(
      isPlaying: null == isPlaying
          ? _value.isPlaying
          : isPlaying // ignore: cast_nullable_to_non_nullable
              as bool,
      controller: freezed == controller
          ? _value.controller
          : controller // ignore: cast_nullable_to_non_nullable
              as VideoPlayerController?,
    ));
  }
}

/// @nodoc

class _$_CompletePageState implements _CompletePageState {
  const _$_CompletePageState({this.isPlaying = false, this.controller = null});

  @override
  @JsonKey()
  final bool isPlaying;
  @override
  @JsonKey()
  final VideoPlayerController? controller;

  @override
  String toString() {
    return 'CompletePageState(isPlaying: $isPlaying, controller: $controller)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CompletePageState &&
            (identical(other.isPlaying, isPlaying) ||
                other.isPlaying == isPlaying) &&
            (identical(other.controller, controller) ||
                other.controller == controller));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isPlaying, controller);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CompletePageStateCopyWith<_$_CompletePageState> get copyWith =>
      __$$_CompletePageStateCopyWithImpl<_$_CompletePageState>(
          this, _$identity);
}

abstract class _CompletePageState implements CompletePageState {
  const factory _CompletePageState(
      {final bool isPlaying,
      final VideoPlayerController? controller}) = _$_CompletePageState;

  @override
  bool get isPlaying;
  @override
  VideoPlayerController? get controller;
  @override
  @JsonKey(ignore: true)
  _$$_CompletePageStateCopyWith<_$_CompletePageState> get copyWith =>
      throw _privateConstructorUsedError;
}
