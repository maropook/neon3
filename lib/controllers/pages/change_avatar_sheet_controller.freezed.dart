// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'change_avatar_sheet_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ChangeAvatarSheetState {
  List<Avatar> get avatarList => throw _privateConstructorUsedError;
  Avatar? get selectedAvatar => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ChangeAvatarSheetStateCopyWith<ChangeAvatarSheetState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChangeAvatarSheetStateCopyWith<$Res> {
  factory $ChangeAvatarSheetStateCopyWith(ChangeAvatarSheetState value,
          $Res Function(ChangeAvatarSheetState) then) =
      _$ChangeAvatarSheetStateCopyWithImpl<$Res, ChangeAvatarSheetState>;
  @useResult
  $Res call({List<Avatar> avatarList, Avatar? selectedAvatar});

  $AvatarCopyWith<$Res>? get selectedAvatar;
}

/// @nodoc
class _$ChangeAvatarSheetStateCopyWithImpl<$Res,
        $Val extends ChangeAvatarSheetState>
    implements $ChangeAvatarSheetStateCopyWith<$Res> {
  _$ChangeAvatarSheetStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? avatarList = null,
    Object? selectedAvatar = freezed,
  }) {
    return _then(_value.copyWith(
      avatarList: null == avatarList
          ? _value.avatarList
          : avatarList // ignore: cast_nullable_to_non_nullable
              as List<Avatar>,
      selectedAvatar: freezed == selectedAvatar
          ? _value.selectedAvatar
          : selectedAvatar // ignore: cast_nullable_to_non_nullable
              as Avatar?,
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
abstract class _$$_ChangeAvatarSheetStateCopyWith<$Res>
    implements $ChangeAvatarSheetStateCopyWith<$Res> {
  factory _$$_ChangeAvatarSheetStateCopyWith(_$_ChangeAvatarSheetState value,
          $Res Function(_$_ChangeAvatarSheetState) then) =
      __$$_ChangeAvatarSheetStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Avatar> avatarList, Avatar? selectedAvatar});

  @override
  $AvatarCopyWith<$Res>? get selectedAvatar;
}

/// @nodoc
class __$$_ChangeAvatarSheetStateCopyWithImpl<$Res>
    extends _$ChangeAvatarSheetStateCopyWithImpl<$Res,
        _$_ChangeAvatarSheetState>
    implements _$$_ChangeAvatarSheetStateCopyWith<$Res> {
  __$$_ChangeAvatarSheetStateCopyWithImpl(_$_ChangeAvatarSheetState _value,
      $Res Function(_$_ChangeAvatarSheetState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? avatarList = null,
    Object? selectedAvatar = freezed,
  }) {
    return _then(_$_ChangeAvatarSheetState(
      avatarList: null == avatarList
          ? _value._avatarList
          : avatarList // ignore: cast_nullable_to_non_nullable
              as List<Avatar>,
      selectedAvatar: freezed == selectedAvatar
          ? _value.selectedAvatar
          : selectedAvatar // ignore: cast_nullable_to_non_nullable
              as Avatar?,
    ));
  }
}

/// @nodoc

class _$_ChangeAvatarSheetState implements _ChangeAvatarSheetState {
  const _$_ChangeAvatarSheetState(
      {final List<Avatar> avatarList = const [], this.selectedAvatar = null})
      : _avatarList = avatarList;

  final List<Avatar> _avatarList;
  @override
  @JsonKey()
  List<Avatar> get avatarList {
    if (_avatarList is EqualUnmodifiableListView) return _avatarList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_avatarList);
  }

  @override
  @JsonKey()
  final Avatar? selectedAvatar;

  @override
  String toString() {
    return 'ChangeAvatarSheetState(avatarList: $avatarList, selectedAvatar: $selectedAvatar)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ChangeAvatarSheetState &&
            const DeepCollectionEquality()
                .equals(other._avatarList, _avatarList) &&
            (identical(other.selectedAvatar, selectedAvatar) ||
                other.selectedAvatar == selectedAvatar));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_avatarList), selectedAvatar);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ChangeAvatarSheetStateCopyWith<_$_ChangeAvatarSheetState> get copyWith =>
      __$$_ChangeAvatarSheetStateCopyWithImpl<_$_ChangeAvatarSheetState>(
          this, _$identity);
}

abstract class _ChangeAvatarSheetState implements ChangeAvatarSheetState {
  const factory _ChangeAvatarSheetState(
      {final List<Avatar> avatarList,
      final Avatar? selectedAvatar}) = _$_ChangeAvatarSheetState;

  @override
  List<Avatar> get avatarList;
  @override
  Avatar? get selectedAvatar;
  @override
  @JsonKey(ignore: true)
  _$$_ChangeAvatarSheetStateCopyWith<_$_ChangeAvatarSheetState> get copyWith =>
      throw _privateConstructorUsedError;
}
