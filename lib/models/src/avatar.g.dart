// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Avatar _$$_AvatarFromJson(Map<String, dynamic> json) => _$_Avatar(
      activeImagePath: json['activeImagePath'] as String? ?? '',
      stopImagePath: json['stopImagePath'] as String? ?? '',
      uniqueKey: json['uniqueKey'] as String? ?? '',
      created: const FireTimestampConverterNonNull().fromJson(json['created']),
      updated: const FireTimestampConverterNonNull().fromJson(json['updated']),
    );

Map<String, dynamic> _$$_AvatarToJson(_$_Avatar instance) => <String, dynamic>{
      'activeImagePath': instance.activeImagePath,
      'stopImagePath': instance.stopImagePath,
      'uniqueKey': instance.uniqueKey,
      'created': const FireTimestampConverterNonNull().toJson(instance.created),
      'updated': const FireTimestampConverterNonNull().toJson(instance.updated),
    };
