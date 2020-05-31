part of '../root_bloc.dart';

class HelpEvent extends HomeEvent {}

class RequestHelp extends HelpEvent {
  String message;
  RequestHelp(this.message);
}