part of '../root_bloc.dart';

class AddTimeSlotEvent extends HomeEvent {}

class AddTimeSlotAttempt extends AddTimeSlotEvent {
  final String type;
  final DateTime start;
  final DateTime stop;
  int numAttendees;
  AddTimeSlotAttempt({this.type, this.start, this.stop});
}