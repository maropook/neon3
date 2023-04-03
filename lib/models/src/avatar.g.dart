// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Avatar _$$_AvatarFromJson(Map<String, dynamic> json) => _$_Avatar(
      id: json['id'] as String? ?? '',
      activeImagePath: json['activeImagePath'] as String? ?? '',
      stopImagePath: json['stopImagePath'] as String? ?? '',
      created: const FireTimestampConverterNonNull().fromJson(json['created']),
      updated: const FireTimestampConverterNonNull().fromJson(json['updated']),
    );

Map<String, dynamic> _$$_AvatarToJson(_$_Avatar instance) => <String, dynamic>{
      'id': instance.id,
      'activeImagePath': instance.activeImagePath,
      'stopImagePath': instance.stopImagePath,
      'created': const FireTimestampConverterNonNull().toJson(instance.created),
      'updated': const FireTimestampConverterNonNull().toJson(instance.updated),
    };
