import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/timeslot.dart';
import '../entities/user.dart';
import '../entities/venue.dart';

abstract class RootRepository {
  Future<Either<Failure, User>> login({String email, String password});
  Future<Either<Failure, User>> getUser();
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, User>> getCachedUser();
  Future<Either<Failure, Map<String, List<TimeSlot>>>> getTimeSlots(Venue venue);
  Future<Either<Failure, bool>> addTimeSlot({DateTime start, DateTime stop, int numAttendees, String type, Venue venue});
  Future<Either<Failure, bool>> scan(String userId, Venue venue);
  Future<Either<Failure, bool>> deleteTimeSlot({Venue venue, TimeSlot timeslot});
  Future<Either<Failure, bool>> getHelp(String message, Venue venue);
  Future<Either<Failure, TimeSlot>> changeAttendees(bool add, Venue venue, TimeSlot timeslot);
  Future<Either<Failure, int>> increment(int increment, Venue venue);
  Future<Either<Failure, bool>> clear(Venue venue);
  Future<Either<Failure, User>> changeVenue(User user, int index);
  Future<Either<Failure, String>> getNotes(Venue venue, TimeSlot timeslot);
  Future<Either<Failure, String>> editNotes(String newText, Venue venue, TimeSlot timeslot);
}