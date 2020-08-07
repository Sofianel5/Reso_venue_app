import 'package:Reso_venue/features/reso_venue/domain/entities/user.dart';
import 'package:equatable/equatable.dart';
import 'venue.dart';

class TimeSlot extends Equatable {
  final DateTime start;
  final DateTime stop;
  final int maxAttendees;
  final int numAttendees;
  final int id;
  final bool current;
  final bool past;
  final String type;
  final List<User> attendees;
  TimeSlot({
    this.start,
    this.stop,
    this.maxAttendees,
    this.numAttendees,
    this.id,
    this.current,
    this.past,
    this.type,
    this.attendees,
  });
  static const List<String> types = ["All", "Elderly", "Frontline"];

  @override
  List<Object> get props =>
      [start, stop, id, maxAttendees, numAttendees, current, past];
}