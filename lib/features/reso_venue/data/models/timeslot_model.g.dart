// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeslot_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeSlotModel _$TimeSlotModelFromJson(Map<String, dynamic> json) {
  return TimeSlotModel(
    start:
        json['start'] == null ? null : DateTime.parse(json['start'] as String),
    stop: json['stop'] == null ? null : DateTime.parse(json['stop'] as String),
    maxAttendees: json['max_attendees'] as int,
    numAttendees: json['num_attendees'] as int,
    attendees: (json['attendees'] as List)
        ?.map((e) =>
            e == null ? null : UserModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    id: json['id'] as int,
    current: json['current'] as bool,
    past: json['past'] as bool,
    type: json['type'] as String,
  );
}

Map<String, dynamic> _$TimeSlotModelToJson(TimeSlotModel instance) =>
    <String, dynamic>{
      'start': instance.start?.toIso8601String(),
      'stop': instance.stop?.toIso8601String(),
      'max_attendees': instance.maxAttendees,
      'num_attendees': instance.numAttendees,
      'id': instance.id,
      'current': instance.current,
      'past': instance.past,
      'type': instance.type,
      'attendees': instance.attendees?.map((e) => e?.toJson())?.toList(),
    };
