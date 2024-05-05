// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AvatarImpl _$$AvatarImplFromJson(Map<String, dynamic> json) => _$AvatarImpl(
      id: json['id'] as String? ?? '',
      activeImageUrl: json['activeImageUrl'] as String? ?? '',
      stopImageUrl: json['stopImageUrl'] as String? ?? '',
      isDefault: json['isDefault'] as bool? ?? false,
      created: const FireTimestampConverterNonNull().fromJson(json['created']),
      updated: const FireTimestampConverterNonNull().fromJson(json['updated']),
    );

Map<String, dynamic> _$$AvatarImplToJson(_$AvatarImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'activeImageUrl': instance.activeImageUrl,
      'stopImageUrl': instance.stopImageUrl,
      'isDefault': instance.isDefault,
      'created': const FireTimestampConverterNonNull().toJson(instance.created),
      'updated': const FireTimestampConverterNonNull().toJson(instance.updated),
    };
