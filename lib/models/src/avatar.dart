import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:neon3/models/libs/fire_timestamp_converter.dart';

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
      "https://firebasestorage.googleapis.com/v0/b/neon3-ac080.appspot.com/o/defaultAvatar%2Favatar_active.png?alt=media&token=b67fb1bf-f37b-4da9-8e3f-7d4a407446c2",
  stopImageUrl:
      "https://firebasestorage.googleapis.com/v0/b/neon3-ac080.appspot.com/o/defaultAvatar%2Favatar_stop.png?alt=media&token=d9d2c88d-01b7-4229-bcf4-da798f146555",
  // activeImageUrl:
  //     "https://firebasestorage.googleapis.com/v0/b/neon3-ac080.appspot.com/o/avatar_active.png?alt=media&token=bb711708-17d6-418a-93e4-9fd62d130ca4",
  // stopImageUrl:
  //     "https://firebasestorage.googleapis.com/v0/b/neon3-ac080.appspot.com/o/avatar_stop.png?alt=media&token=c19880fc-56ab-4ed0-b0ba-4caa8a910ee2",
  id: '',
  isDefault: true,
  created: DateTime.now(),
  updated: DateTime.now(),
);
