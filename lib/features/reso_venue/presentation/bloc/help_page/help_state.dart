part of '../root_bloc.dart';

class HelpState extends HomeState {
  HelpState(User user) : super(user);
}

class InitialHelpState extends HelpState {
  InitialHelpState(User user) : super(user);
}

class LoadingHelpState extends HelpState {
  LoadingHelpState(User user) : super(user); 
}

class FailedHelpState extends HelpState {
  final String message;
  FailedHelpState(User user,this.message) : super(user);
}

class SucceededHelpState extends HelpState {
  SucceededHelpState(User user) : super(user);
}