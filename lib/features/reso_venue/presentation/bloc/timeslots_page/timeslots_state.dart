part of '../root_bloc.dart';

class TimeSlotsState extends AuthenticatedState {
  TimeSlotsState(User user) : super(user);
}

class TimeSlotsLoadingState extends TimeSlotsState {
  TimeSlotsLoadingState(User user) : super(user);
}

class TimeSlotsLoadFailure extends TimeSlotsState {
  final String message;
  TimeSlotsLoadFailure(User user, this.message) : super(user);
}

class TimeSlotsLoaded extends TimeSlotsState {
  List<TimeSlot> timeSlots;
  TimeSlotsLoaded(User user, this.timeSlots) : super(user);
}

class TimeSlotsHistoryState extends TimeSlotsLoaded {
  TimeSlotsHistoryState(User user, List<TimeSlot> timeSlots) : super(user, timeSlots);
}

class TimeSlotsCurrentState extends TimeSlotsLoaded {
  TimeSlotsCurrentState(User user, List<TimeSlot> timeSlots) : super(user, timeSlots);
}

class NoCurrentTimeSlots extends TimeSlotsCurrentState {
  NoCurrentTimeSlots(User user, List<TimeSlot> timeSlots) : super(user, timeSlots);
}

class NoPreviousTimeSlots extends TimeSlotsHistoryState {
  NoPreviousTimeSlots(User user, List<TimeSlot> timeSlots) : super(user, timeSlots);
} 

class DeleteDialogueState extends TimeSlotsCurrentState {
  final TimeSlot timeslot;
  DeleteDialogueState(User user, List<TimeSlot> timeSlots, this.timeslot) : super(user, timeSlots);
}

class DeleteConfirmState extends DeleteDialogueState {
  DeleteConfirmState(User user, List<TimeSlot> timeSlots, TimeSlot timeslot) : super(user, timeSlots, timeslot);
}
