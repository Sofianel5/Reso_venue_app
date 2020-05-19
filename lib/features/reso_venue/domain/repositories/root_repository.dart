import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/thread.dart';
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
}