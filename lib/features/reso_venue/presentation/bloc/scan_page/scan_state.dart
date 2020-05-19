part of '../root_bloc.dart';

class ScanState extends HomeState {
  ScanState(User user) : super(user);
}

class ScanIdleState extends ScanState {
  ScanIdleState(User user) : super(user);
}

class ScanUnsuccessfulState extends ScanState {
  final String message;
  ScanUnsuccessfulState(User user, this.message) : super(user);
}

class ScanSuccessfulState extends ScanState {
  ScanSuccessfulState(User user) : super(user);
}