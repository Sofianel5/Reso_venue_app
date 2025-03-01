import 'user.dart';
import 'venue.dart';
import 'package:equatable/equatable.dart';

class Thread extends Equatable {
  final String threadId;

  final int id;

  final Venue venue;

  final User user;

  final DateTime time;

  final bool fromConfirmed;

  final bool toConfirmed;

  Thread({this.threadId, this.venue, this.user, this.time, this.toConfirmed, this.fromConfirmed, this.id});

  @override
  List<Object> get props => [threadId, venue, user, id];


}