part of '../root_bloc.dart';

class NotesPageEvent extends HomeEvent {}

class NotesPageCreatedEvent extends NotesPageEvent {}

class NotesPageEditEvent extends NotesPageEvent {
  final String newText;
  NotesPageEditEvent(this.newText);
}