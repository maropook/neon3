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
      "https://firebasestorage.googleapis.com/v0/b/neon-2-807bf.appspot.com/o/users%2FGtBDfvDJNTa2JAmsjFdxIo3eT2f1%2F26a4b050-d227-4acf-9bbf-3be919838329%2FactiveAvatar.jpg?alt=media&token=f3846a47-e221-452f-adc4-4db7c2bcccec",
  stopImageUrl:
      "https://firebasestorage.googleapis.com/v0/b/neon-2-807bf.appspot.com/o/users%2FGtBDfvDJNTa2JAmsjFdxIo3eT2f1%2F26a4b050-d227-4acf-9bbf-3be919838329%2FstopAvatar.jpg?alt=media&token=3b5beacb-8934-4687-952a-04c36604be3e",
  id: 'default',
  created: DateTime.now(),
  updated: DateTime.now(),
);
