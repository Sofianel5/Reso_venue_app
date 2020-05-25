part of '../root_bloc.dart';

class ScanState extends HomeState {
  ScanState(User user) : super(user);
}

class ScanIdleState extends ScanState {
  ScanIdleState(User user) : super(user);
}

class ScanLockedState extends ScanState {
  ScanLockedState(User user) : super(user);
}

class ScanUnsuccessfulState extends ScanLockedState {
  final String message;
  ScanUnsuccessfulState(User user, this.message) : super(user);
}

class ScanSuccessfulState extends ScanLockedState {
  ScanSuccessfulState(User user) : super(user);
}
 