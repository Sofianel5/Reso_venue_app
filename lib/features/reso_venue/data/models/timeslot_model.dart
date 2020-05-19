import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/timeslot.dart';
import 'model.dart';
import 'venue_model.dart';

part 'timeslot_model.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class TimeSlotModel extends TimeSlot implements Model{
  TimeSlotModel({
    DateTime start,
    DateTime stop,
    int maxAttendees,
    int numAttendees,
    @required int id,
    bool current,
    bool past,
    String type,
  }) : super(
          start: start,
          stop: stop,
          id: id,
          maxAttendees: maxAttendees,
          numAttendees: numAttendees,
          current: current,
          past: past,
          type: type,
        );
  factory TimeSlotModel.fromJson(Map<String, dynamic> json) =>
      _$TimeSlotModelFromJson(json);
  Map<String, dynamic> toJson() => _$TimeSlotModelToJson(this);
}

