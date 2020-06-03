part of '../root_bloc.dart';

class CounterPageEvent extends HomeEvent {}

class CounterPageCreated extends CounterPageEvent {}

class CounterPageClearConfirm extends CounterPageEvent {}

class CounterPageIncrement extends CounterPageEvent {
  final int by;
  CounterPageIncrement({@required this.by});
}
