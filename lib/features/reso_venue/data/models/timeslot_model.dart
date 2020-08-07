import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/timeslot.dart';
import 'model.dart';
import 'user_model.dart';

part 'timeslot_model.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class TimeSlotModel extends TimeSlot implements Model{
  List<UserModel> attendees;
  TimeSlotModel({
    DateTime start,
    DateTime stop,
    int maxAttendees,
    int numAttendees,
    this.attendees,
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
          attendees: attendees,
          current: current,
          past: past,
          type: type,
        );
  factory TimeSlotModel.fromJson(Map<String, dynamic> json) =>
      _$TimeSlotModelFromJson(json);
  Map<String, dynamic> toJson() => _$TimeSlotModelToJson(this);
}

