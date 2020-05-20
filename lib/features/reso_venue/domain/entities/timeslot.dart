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
  TimeSlot({
    this.start,
    this.stop,
    this.maxAttendees,
    this.numAttendees,
    this.id,
    this.current,
    this.past,
    this.type,
  });
  static const List<String> types = ["All", "Elderly", "Frontline"];

  @override
  List<Object> get props =>
      [start, stop, id, maxAttendees, numAttendees, current, past];
}