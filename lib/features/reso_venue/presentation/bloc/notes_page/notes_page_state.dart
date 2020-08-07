part of '../root_bloc.dart';

class NotesPageState extends HomeEvent {}

class NotesPageLoadingState extends NotesPageState {}

class NotesPageLoadFailedState extends NotesPageState {
  String message;
  NotesPageLoadFailedState(this.message);
}

class NotesPageLoadedState extends NotesPageState {
  String notes;
  NotesPageLoadedState(this.notes);
}

class NotesPageEditLoadingState extends NotesPageLoadedState {
  NotesPageEditLoadingState(String notes) : super(notes);
}

class NotesPageEditFailedState extends NotesPageLoadedState {
  String message;
  NotesPageEditFailedState(String notes, this.message) : super(notes);
}

class NotesPageEditSuccessfulState extends NotesPageLoadedState {
  NotesPageEditSuccessfulState(String notes) : super(notes);
}