import '../../../../core/util/input_converter.dart';
import '../entities/venue.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/params.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/root_repository.dart';

class AddTimeSlot extends UseCase<bool, AddTimeSlotParams> {
  final RootRepository repository;
  AddTimeSlot(this.repository);

  @override 
  Future<Either<Failure,bool>> call(AddTimeSlotParams params) async {
    return InputConverter().validateTimeSlotForm(params.start, params.end).fold((failure) async {
      return Left(failure);
    }, (success) async {
      return await repository.addTimeSlot(venue: params.venue, start: params.start, stop: params.end, numAttendees: params.numAttendees, type: params.type);
    });
  }
}

class AddTimeSlotParams extends Params {
  final DateTime start;
  final DateTime end;
  final Venue venue;
  final String type;
  final int numAttendees;
  AddTimeSlotParams({@required this.type, @required this.venue, @required this.start, @required this.end, @required this.numAttendees});
  @override
  List<Object> get props => [start, end, venue, type, numAttendees];
}