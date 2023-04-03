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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AvatarListPageState {
  Uint8List? get image => throw _privateConstructorUsedError;
  List<Avatar> get avatarList => throw _privateConstructorUsedError;

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
  $Res call({Uint8List? image, List<Avatar> avatarList});
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
    Object? image = freezed,
    Object? avatarList = null,
  }) {
    return _then(_value.copyWith(
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
      avatarList: null == avatarList
          ? _value.avatarList
          : avatarList // ignore: cast_nullable_to_non_nullable
              as List<Avatar>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_AvatarListPageStateCopyWith<$Res>
    implements $AvatarListPageStateCopyWith<$Res> {
  factory _$$_AvatarListPageStateCopyWith(_$_AvatarListPageState value,
          $Res Function(_$_AvatarListPageState) then) =
      __$$_AvatarListPageStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Uint8List? image, List<Avatar> avatarList});
}

/// @nodoc
class __$$_AvatarListPageStateCopyWithImpl<$Res>
    extends _$AvatarListPageStateCopyWithImpl<$Res, _$_AvatarListPageState>
    implements _$$_AvatarListPageStateCopyWith<$Res> {
  __$$_AvatarListPageStateCopyWithImpl(_$_AvatarListPageState _value,
      $Res Function(_$_AvatarListPageState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? image = freezed,
    Object? avatarList = null,
  }) {
    return _then(_$_AvatarListPageState(
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
      avatarList: null == avatarList
          ? _value._avatarList
          : avatarList // ignore: cast_nullable_to_non_nullable
              as List<Avatar>,
    ));
  }
}

/// @nodoc

class _$_AvatarListPageState implements _AvatarListPageState {
  const _$_AvatarListPageState(
      {this.image = null, final List<Avatar> avatarList = const []})
      : _avatarList = avatarList;

  @override
  @JsonKey()
  final Uint8List? image;
  final List<Avatar> _avatarList;
  @override
  @JsonKey()
  List<Avatar> get avatarList {
    if (_avatarList is EqualUnmodifiableListView) return _avatarList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_avatarList);
  }

  @override
  String toString() {
    return 'AvatarListPageState(image: $image, avatarList: $avatarList)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AvatarListPageState &&
            const DeepCollectionEquality().equals(other.image, image) &&
            const DeepCollectionEquality()
                .equals(other._avatarList, _avatarList));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(image),
      const DeepCollectionEquality().hash(_avatarList));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AvatarListPageStateCopyWith<_$_AvatarListPageState> get copyWith =>
      __$$_AvatarListPageStateCopyWithImpl<_$_AvatarListPageState>(
          this, _$identity);
}

abstract class _AvatarListPageState implements AvatarListPageState {
  const factory _AvatarListPageState(
      {final Uint8List? image,
      final List<Avatar> avatarList}) = _$_AvatarListPageState;

  @override
  Uint8List? get image;
  @override
  List<Avatar> get avatarList;
  @override
  @JsonKey(ignore: true)
  _$$_AvatarListPageStateCopyWith<_$_AvatarListPageState> get copyWith =>
      throw _privateConstructorUsedError;
}
