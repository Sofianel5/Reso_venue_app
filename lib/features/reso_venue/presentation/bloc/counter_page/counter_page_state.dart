part of '../root_bloc.dart';

class CounterPageState extends HomeState {
  CounterPageState(User user) : super(user);
}

class CounterPageLoading extends CounterPageState {
  CounterPageLoading(User user) : super(user);
}

class CounterPageLoadFailed extends CounterPageState {
  final String message;
  CounterPageLoadFailed(User user, this.message) : super(user);
}

class CounterPageLoaded extends CounterPageState {
  final int count;
  CounterPageLoaded(User user, this.count) : super(user);
}