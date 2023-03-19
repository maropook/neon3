// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'encode_page_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$EncodePageState {
  double get progressRate => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $EncodePageStateCopyWith<EncodePageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EncodePageStateCopyWith<$Res> {
  factory $EncodePageStateCopyWith(
          EncodePageState value, $Res Function(EncodePageState) then) =
      _$EncodePageStateCopyWithImpl<$Res, EncodePageState>;
  @useResult
  $Res call({double progressRate});
}

/// @nodoc
class _$EncodePageStateCopyWithImpl<$Res, $Val extends EncodePageState>
    implements $EncodePageStateCopyWith<$Res> {
  _$EncodePageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? progressRate = null,
  }) {
    return _then(_value.copyWith(
      progressRate: null == progressRate
          ? _value.progressRate
          : progressRate // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_EncodePageStateCopyWith<$Res>
    implements $EncodePageStateCopyWith<$Res> {
  factory _$$_EncodePageStateCopyWith(
          _$_EncodePageState value, $Res Function(_$_EncodePageState) then) =
      __$$_EncodePageStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double progressRate});
}

/// @nodoc
class __$$_EncodePageStateCopyWithImpl<$Res>
    extends _$EncodePageStateCopyWithImpl<$Res, _$_EncodePageState>
    implements _$$_EncodePageStateCopyWith<$Res> {
  __$$_EncodePageStateCopyWithImpl(
      _$_EncodePageState _value, $Res Function(_$_EncodePageState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? progressRate = null,
  }) {
    return _then(_$_EncodePageState(
      progressRate: null == progressRate
          ? _value.progressRate
          : progressRate // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$_EncodePageState implements _EncodePageState {
  const _$_EncodePageState({this.progressRate = 0.0});

  @override
  @JsonKey()
  final double progressRate;

  @override
  String toString() {
    return 'EncodePageState(progressRate: $progressRate)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_EncodePageState &&
            (identical(other.progressRate, progressRate) ||
                other.progressRate == progressRate));
  }

  @override
  int get hashCode => Object.hash(runtimeType, progressRate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_EncodePageStateCopyWith<_$_EncodePageState> get copyWith =>
      __$$_EncodePageStateCopyWithImpl<_$_EncodePageState>(this, _$identity);
}

abstract class _EncodePageState implements EncodePageState {
  const factory _EncodePageState({final double progressRate}) =
      _$_EncodePageState;

  @override
  double get progressRate;
  @override
  @JsonKey(ignore: true)
  _$$_EncodePageStateCopyWith<_$_EncodePageState> get copyWith =>
      throw _privateConstructorUsedError;
}
