part of '../root_bloc.dart';

class TimeSlotEvent extends HomeEvent {}

class TimeSlotCreation extends TimeSlotEvent {}

class TimeSlotsRequestHistory extends TimeSlotEvent {}

class TimeSlotsRequestCurrent extends TimeSlotEvent {}

class TimeSlotDeleteRequest extends TimeSlotEvent {
  TimeSlot timeslot;
  TimeSlotDeleteRequest(this.timeslot);
}

class TimeSlotDeleteConfirm extends TimeSlotEvent {
  TimeSlot timeslot;
  TimeSlotDeleteConfirm(this.timeslot);
}
