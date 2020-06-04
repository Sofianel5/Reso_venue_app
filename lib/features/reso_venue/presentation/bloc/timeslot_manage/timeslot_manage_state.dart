part of '../root_bloc.dart';
class TimeSlotManageState extends HomeState {
  final TimeSlot timeSlot;
  TimeSlotManageState(User user, this.timeSlot) : super(user);
}

class TimeSlotManageInitialState extends TimeSlotManageState {
  TimeSlotManageInitialState(User user, TimeSlot timeslot) : super(user, timeslot);
}

class LoadingTimeSlot extends TimeSlotManageState {
  LoadingTimeSlot(User user, TimeSlot timeslot) : super(user, timeslot);
}

class ManageFailure extends TimeSlotManageState {
  ManageFailure(User user, TimeSlot timeSlot) : super(user, timeSlot);
}

class ManageDialogueState extends TimeSlotManageState {
  ManageDialogueState(User user, TimeSlot timeSlot) : super(user, timeSlot);
}

class DeleteConfirm extends ManageDialogueState {
  DeleteConfirm(User user, TimeSlot timeSlot) : super(user, timeSlot);
}

class ManageSnackBarState extends TimeSlotManageState {
  final String message;
  ManageSnackBarState(User user, TimeSlot timeSlot, this.message) : super(user, timeSlot);
}

class DeleteFailed extends ManageSnackBarState {
  DeleteFailed(User user, String message, TimeSlot timeslot) : super(user, timeslot, message);
}

class DeleteSucceeded extends ManageSnackBarState {
  DeleteSucceeded(User user, TimeSlot timeslot) : super(user, timeslot, Messages.SUCCESS);
}

class ChangeAttendeesFailed extends ManageSnackBarState {
  ChangeAttendeesFailed(User user, TimeSlot timeSlot, String message) : super(user, timeSlot, message);
}