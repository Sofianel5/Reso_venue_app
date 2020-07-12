part of '../root_bloc.dart';

class AccountPageEvent extends HomeEvent {}

class AccountPageOpened extends AccountPageEvent {}

class AccountVenueChange extends AccountPageEvent {
  final int idx;
  AccountVenueChange(this.idx);
}

