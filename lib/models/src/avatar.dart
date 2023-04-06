import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:maropook_neon2/models/libs/fire_timestamp_converter.dart';

part 'avatar.freezed.dart';
part 'avatar.g.dart';

@freezed
class Avatar with _$Avatar {
  @JsonSerializable(explicitToJson: true)
  const factory Avatar({
    @Default('') String id,
    @Default('') String activeImageUrl,
    @Default('') String stopImageUrl,
    @Default(false) bool isDefault,
    @FireTimestampConverterNonNull() required DateTime created,
    @FireTimestampConverterNonNull() required DateTime updated,
  }) = _Avatar;

  factory Avatar.fromJson(Map<String, dynamic> json) => _$AvatarFromJson(json);
}

final Avatar defaultAvatar = Avatar(
  activeImageUrl:
      "https://firebasestorage.googleapis.com/v0/b/neon-2-807bf.appspot.com/o/avatars%2Favatar_active.png?alt=media&token=0d57bc2f-2ea8-4ec2-9a32-410a8ec04d67",
  stopImageUrl:
      "https://firebasestorage.googleapis.com/v0/b/neon-2-807bf.appspot.com/o/avatars%2Favatar_stop.png?alt=media&token=0cf59027-0b93-48b0-b96c-876d033c2d3c",
  id: '',
  isDefault: true,
  created: DateTime.now(),
  updated: DateTime.now(),
);
