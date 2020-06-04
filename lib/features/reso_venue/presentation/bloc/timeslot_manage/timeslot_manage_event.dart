part of '../root_bloc.dart';

class TimeSlotManageEvent extends HomeEvent {}

class TimeSlotDeleteRequest extends TimeSlotManageEvent {}

class TimeSlotDeleteConfirm extends TimeSlotManageEvent {}

class AddAttendeeEvent extends TimeSlotManageEvent {}

class RemoveAttendeeEvent extends TimeSlotManageEvent {}