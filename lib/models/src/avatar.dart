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
