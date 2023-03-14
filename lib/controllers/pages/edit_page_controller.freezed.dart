// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_page_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$EditPageState {
  bool get isPlaying => throw _privateConstructorUsedError;
  VideoPlayerController? get controller => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $EditPageStateCopyWith<EditPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EditPageStateCopyWith<$Res> {
  factory $EditPageStateCopyWith(
          EditPageState value, $Res Function(EditPageState) then) =
      _$EditPageStateCopyWithImpl<$Res, EditPageState>;
  @useResult
  $Res call({bool isPlaying, VideoPlayerController? controller});
}

/// @nodoc
class _$EditPageStateCopyWithImpl<$Res, $Val extends EditPageState>
    implements $EditPageStateCopyWith<$Res> {
  _$EditPageStateCopyWithImpl(this._value, this._then);

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
abstract class _$$_EditPageStateCopyWith<$Res>
    implements $EditPageStateCopyWith<$Res> {
  factory _$$_EditPageStateCopyWith(
          _$_EditPageState value, $Res Function(_$_EditPageState) then) =
      __$$_EditPageStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isPlaying, VideoPlayerController? controller});
}

/// @nodoc
class __$$_EditPageStateCopyWithImpl<$Res>
    extends _$EditPageStateCopyWithImpl<$Res, _$_EditPageState>
    implements _$$_EditPageStateCopyWith<$Res> {
  __$$_EditPageStateCopyWithImpl(
      _$_EditPageState _value, $Res Function(_$_EditPageState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isPlaying = null,
    Object? controller = freezed,
  }) {
    return _then(_$_EditPageState(
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

class _$_EditPageState implements _EditPageState {
  const _$_EditPageState({this.isPlaying = false, this.controller = null});

  @override
  @JsonKey()
  final bool isPlaying;
  @override
  @JsonKey()
  final VideoPlayerController? controller;

  @override
  String toString() {
    return 'EditPageState(isPlaying: $isPlaying, controller: $controller)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_EditPageState &&
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
  _$$_EditPageStateCopyWith<_$_EditPageState> get copyWith =>
      __$$_EditPageStateCopyWithImpl<_$_EditPageState>(this, _$identity);
}

abstract class _EditPageState implements EditPageState {
  const factory _EditPageState(
      {final bool isPlaying,
      final VideoPlayerController? controller}) = _$_EditPageState;

  @override
  bool get isPlaying;
  @override
  VideoPlayerController? get controller;
  @override
  @JsonKey(ignore: true)
  _$$_EditPageStateCopyWith<_$_EditPageState> get copyWith =>
      throw _privateConstructorUsedError;
}
