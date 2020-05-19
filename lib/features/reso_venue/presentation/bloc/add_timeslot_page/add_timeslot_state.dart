part of '../root_bloc.dart';

class AddTimeSlotState extends HomeState {
  AddTimeSlotState(User user) : super(user);
}

class AddTimeSlotInitial extends AddTimeSlotState {
  AddTimeSlotInitial(User user) : super(user);
}

class AddTimeSlotFailure extends AddTimeSlotState {
  final String message;
  AddTimeSlotFailure(User user, this.message) : super(user);
}

class AddTimeSlotSuccess extends AddTimeSlotState {
  AddTimeSlotSuccess(User user) : super(user);
}