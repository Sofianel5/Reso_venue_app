part of '../root_bloc.dart';

class ScanEvent extends HomeEvent {}

class ScanPageCreated extends ScanEvent {}

class ScanAttempted extends ScanEvent {
  String uuid;
  ScanAttempted(this.uuid);
}