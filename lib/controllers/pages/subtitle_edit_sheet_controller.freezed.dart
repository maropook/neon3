// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subtitle_edit_sheet_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$SubtitleEditSheetState {
  SubtitleText? get subtitleText => throw _privateConstructorUsedError;
  Color get customFontColor => throw _privateConstructorUsedError;
  Color get customBorderColor => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SubtitleEditSheetStateCopyWith<SubtitleEditSheetState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubtitleEditSheetStateCopyWith<$Res> {
  factory $SubtitleEditSheetStateCopyWith(SubtitleEditSheetState value,
          $Res Function(SubtitleEditSheetState) then) =
      _$SubtitleEditSheetStateCopyWithImpl<$Res, SubtitleEditSheetState>;
  @useResult
  $Res call(
      {SubtitleText? subtitleText,
      Color customFontColor,
      Color customBorderColor});
}

/// @nodoc
class _$SubtitleEditSheetStateCopyWithImpl<$Res,
        $Val extends SubtitleEditSheetState>
    implements $SubtitleEditSheetStateCopyWith<$Res> {
  _$SubtitleEditSheetStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subtitleText = freezed,
    Object? customFontColor = null,
    Object? customBorderColor = null,
  }) {
    return _then(_value.copyWith(
      subtitleText: freezed == subtitleText
          ? _value.subtitleText
          : subtitleText // ignore: cast_nullable_to_non_nullable
              as SubtitleText?,
      customFontColor: null == customFontColor
          ? _value.customFontColor
          : customFontColor // ignore: cast_nullable_to_non_nullable
              as Color,
      customBorderColor: null == customBorderColor
          ? _value.customBorderColor
          : customBorderColor // ignore: cast_nullable_to_non_nullable
              as Color,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SubtitleEditSheetStateCopyWith<$Res>
    implements $SubtitleEditSheetStateCopyWith<$Res> {
  factory _$$_SubtitleEditSheetStateCopyWith(_$_SubtitleEditSheetState value,
          $Res Function(_$_SubtitleEditSheetState) then) =
      __$$_SubtitleEditSheetStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {SubtitleText? subtitleText,
      Color customFontColor,
      Color customBorderColor});
}

/// @nodoc
class __$$_SubtitleEditSheetStateCopyWithImpl<$Res>
    extends _$SubtitleEditSheetStateCopyWithImpl<$Res,
        _$_SubtitleEditSheetState>
    implements _$$_SubtitleEditSheetStateCopyWith<$Res> {
  __$$_SubtitleEditSheetStateCopyWithImpl(_$_SubtitleEditSheetState _value,
      $Res Function(_$_SubtitleEditSheetState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subtitleText = freezed,
    Object? customFontColor = null,
    Object? customBorderColor = null,
  }) {
    return _then(_$_SubtitleEditSheetState(
      subtitleText: freezed == subtitleText
          ? _value.subtitleText
          : subtitleText // ignore: cast_nullable_to_non_nullable
              as SubtitleText?,
      customFontColor: null == customFontColor
          ? _value.customFontColor
          : customFontColor // ignore: cast_nullable_to_non_nullable
              as Color,
      customBorderColor: null == customBorderColor
          ? _value.customBorderColor
          : customBorderColor // ignore: cast_nullable_to_non_nullable
              as Color,
    ));
  }
}

/// @nodoc

class _$_SubtitleEditSheetState implements _SubtitleEditSheetState {
  const _$_SubtitleEditSheetState(
      {this.subtitleText = null,
      this.customFontColor = Colors.white,
      this.customBorderColor = Colors.white});

  @override
  @JsonKey()
  final SubtitleText? subtitleText;
  @override
  @JsonKey()
  final Color customFontColor;
  @override
  @JsonKey()
  final Color customBorderColor;

  @override
  String toString() {
    return 'SubtitleEditSheetState(subtitleText: $subtitleText, customFontColor: $customFontColor, customBorderColor: $customBorderColor)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SubtitleEditSheetState &&
            (identical(other.subtitleText, subtitleText) ||
                other.subtitleText == subtitleText) &&
            (identical(other.customFontColor, customFontColor) ||
                other.customFontColor == customFontColor) &&
            (identical(other.customBorderColor, customBorderColor) ||
                other.customBorderColor == customBorderColor));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, subtitleText, customFontColor, customBorderColor);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SubtitleEditSheetStateCopyWith<_$_SubtitleEditSheetState> get copyWith =>
      __$$_SubtitleEditSheetStateCopyWithImpl<_$_SubtitleEditSheetState>(
          this, _$identity);
}

abstract class _SubtitleEditSheetState implements SubtitleEditSheetState {
  const factory _SubtitleEditSheetState(
      {final SubtitleText? subtitleText,
      final Color customFontColor,
      final Color customBorderColor}) = _$_SubtitleEditSheetState;

  @override
  SubtitleText? get subtitleText;
  @override
  Color get customFontColor;
  @override
  Color get customBorderColor;
  @override
  @JsonKey(ignore: true)
  _$$_SubtitleEditSheetStateCopyWith<_$_SubtitleEditSheetState> get copyWith =>
      throw _privateConstructorUsedError;
}
