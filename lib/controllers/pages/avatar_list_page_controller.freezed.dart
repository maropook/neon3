// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'avatar_list_page_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AvatarListPageState {
  Avatar? get newAvatar => throw _privateConstructorUsedError;
  String get newActiveImagePath => throw _privateConstructorUsedError;
  String get newStopImagePath => throw _privateConstructorUsedError;
  List<Avatar> get avatarList => throw _privateConstructorUsedError;
  Avatar? get selectedAvatar => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AvatarListPageStateCopyWith<AvatarListPageState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AvatarListPageStateCopyWith<$Res> {
  factory $AvatarListPageStateCopyWith(
          AvatarListPageState value, $Res Function(AvatarListPageState) then) =
      _$AvatarListPageStateCopyWithImpl<$Res, AvatarListPageState>;
  @useResult
  $Res call(
      {Avatar? newAvatar,
      String newActiveImagePath,
      String newStopImagePath,
      List<Avatar> avatarList,
      Avatar? selectedAvatar});

  $AvatarCopyWith<$Res>? get newAvatar;
  $AvatarCopyWith<$Res>? get selectedAvatar;
}

/// @nodoc
class _$AvatarListPageStateCopyWithImpl<$Res, $Val extends AvatarListPageState>
    implements $AvatarListPageStateCopyWith<$Res> {
  _$AvatarListPageStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? newAvatar = freezed,
    Object? newActiveImagePath = null,
    Object? newStopImagePath = null,
    Object? avatarList = null,
    Object? selectedAvatar = freezed,
  }) {
    return _then(_value.copyWith(
      newAvatar: freezed == newAvatar
          ? _value.newAvatar
          : newAvatar // ignore: cast_nullable_to_non_nullable
              as Avatar?,
      newActiveImagePath: null == newActiveImagePath
          ? _value.newActiveImagePath
          : newActiveImagePath // ignore: cast_nullable_to_non_nullable
              as String,
      newStopImagePath: null == newStopImagePath
          ? _value.newStopImagePath
          : newStopImagePath // ignore: cast_nullable_to_non_nullable
              as String,
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
  $AvatarCopyWith<$Res>? get newAvatar {
    if (_value.newAvatar == null) {
      return null;
    }

    return $AvatarCopyWith<$Res>(_value.newAvatar!, (value) {
      return _then(_value.copyWith(newAvatar: value) as $Val);
    });
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
abstract class _$$AvatarListPageStateImplCopyWith<$Res>
    implements $AvatarListPageStateCopyWith<$Res> {
  factory _$$AvatarListPageStateImplCopyWith(_$AvatarListPageStateImpl value,
          $Res Function(_$AvatarListPageStateImpl) then) =
      __$$AvatarListPageStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Avatar? newAvatar,
      String newActiveImagePath,
      String newStopImagePath,
      List<Avatar> avatarList,
      Avatar? selectedAvatar});

  @override
  $AvatarCopyWith<$Res>? get newAvatar;
  @override
  $AvatarCopyWith<$Res>? get selectedAvatar;
}

/// @nodoc
class __$$AvatarListPageStateImplCopyWithImpl<$Res>
    extends _$AvatarListPageStateCopyWithImpl<$Res, _$AvatarListPageStateImpl>
    implements _$$AvatarListPageStateImplCopyWith<$Res> {
  __$$AvatarListPageStateImplCopyWithImpl(_$AvatarListPageStateImpl _value,
      $Res Function(_$AvatarListPageStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? newAvatar = freezed,
    Object? newActiveImagePath = null,
    Object? newStopImagePath = null,
    Object? avatarList = null,
    Object? selectedAvatar = freezed,
  }) {
    return _then(_$AvatarListPageStateImpl(
      newAvatar: freezed == newAvatar
          ? _value.newAvatar
          : newAvatar // ignore: cast_nullable_to_non_nullable
              as Avatar?,
      newActiveImagePath: null == newActiveImagePath
          ? _value.newActiveImagePath
          : newActiveImagePath // ignore: cast_nullable_to_non_nullable
              as String,
      newStopImagePath: null == newStopImagePath
          ? _value.newStopImagePath
          : newStopImagePath // ignore: cast_nullable_to_non_nullable
              as String,
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

class _$AvatarListPageStateImpl implements _AvatarListPageState {
  const _$AvatarListPageStateImpl(
      {this.newAvatar = null,
      this.newActiveImagePath = "",
      this.newStopImagePath = "",
      final List<Avatar> avatarList = const [],
      this.selectedAvatar = null})
      : _avatarList = avatarList;

  @override
  @JsonKey()
  final Avatar? newAvatar;
  @override
  @JsonKey()
  final String newActiveImagePath;
  @override
  @JsonKey()
  final String newStopImagePath;
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
    return 'AvatarListPageState(newAvatar: $newAvatar, newActiveImagePath: $newActiveImagePath, newStopImagePath: $newStopImagePath, avatarList: $avatarList, selectedAvatar: $selectedAvatar)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AvatarListPageStateImpl &&
            (identical(other.newAvatar, newAvatar) ||
                other.newAvatar == newAvatar) &&
            (identical(other.newActiveImagePath, newActiveImagePath) ||
                other.newActiveImagePath == newActiveImagePath) &&
            (identical(other.newStopImagePath, newStopImagePath) ||
                other.newStopImagePath == newStopImagePath) &&
            const DeepCollectionEquality()
                .equals(other._avatarList, _avatarList) &&
            (identical(other.selectedAvatar, selectedAvatar) ||
                other.selectedAvatar == selectedAvatar));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      newAvatar,
      newActiveImagePath,
      newStopImagePath,
      const DeepCollectionEquality().hash(_avatarList),
      selectedAvatar);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AvatarListPageStateImplCopyWith<_$AvatarListPageStateImpl> get copyWith =>
      __$$AvatarListPageStateImplCopyWithImpl<_$AvatarListPageStateImpl>(
          this, _$identity);
}

abstract class _AvatarListPageState implements AvatarListPageState {
  const factory _AvatarListPageState(
      {final Avatar? newAvatar,
      final String newActiveImagePath,
      final String newStopImagePath,
      final List<Avatar> avatarList,
      final Avatar? selectedAvatar}) = _$AvatarListPageStateImpl;

  @override
  Avatar? get newAvatar;
  @override
  String get newActiveImagePath;
  @override
  String get newStopImagePath;
  @override
  List<Avatar> get avatarList;
  @override
  Avatar? get selectedAvatar;
  @override
  @JsonKey(ignore: true)
  _$$AvatarListPageStateImplCopyWith<_$AvatarListPageStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
