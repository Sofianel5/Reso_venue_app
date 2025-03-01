
part of 'root_bloc.dart';

abstract class RootEvent extends Equatable {
  const RootEvent();
}

class GetExistingUserEvent extends RootEvent {
  @override
  List<Object> get props => [];
}

class SignupSubmitEvent extends RootEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  SignupSubmitEvent({this.email, this.password, this.firstName, this.lastName});
  @override
  List<Object> get props => [email, password, firstName, lastName];
}

class ErrorEvent extends RootEvent {
  final String message;
  ErrorEvent({this.message});
  @override
  List<Object> get props => [message];
}

class LogoutEvent extends RootEvent {
  @override
  List<Object> get props => [];
}

class PopEvent extends RootEvent {
  @override
  List<Object> get props => [];
}

class PushManage extends RootEvent {
  final TimeSlot timeSlot;
  PushManage(this.timeSlot);
  @override
  List<Object> get props => [timeSlot];
}

class PushHelpPage extends RootEvent {
  @override
  List<Object> get props => [];
}

class PushAttendeeList extends RootEvent {
  final TimeSlot timeSlot;
  PushAttendeeList(this.timeSlot);
  @override
  List<Object> get props => [timeSlot];
}

class PushNotesPage extends RootEvent {
  final TimeSlot timeSlot;
  PushNotesPage(this.timeSlot);
  @override
  List<Object> get props => [timeSlot];
}