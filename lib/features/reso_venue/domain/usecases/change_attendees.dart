import 'package:Reso_venue/features/reso_venue/domain/entities/venue.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/params.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/timeslot.dart';
import '../repositories/root_repository.dart';

class ChangeAttendees extends UseCase<TimeSlot, ChangeAttendeesParams> {
  final RootRepository repository;
  ChangeAttendees(this.repository);

  @override 
  Future<Either<Failure, TimeSlot>> call(ChangeAttendeesParams params) async {
    return await repository.changeAttendees(params.add, params.venue, params.timeslot);
  }
}

class ChangeAttendeesParams extends Params {
  final bool add;
  final TimeSlot timeslot;
  final Venue venue;
  ChangeAttendeesParams({@required this.add, @required this.timeslot, @required this.venue});
  @override
  List<Object> get props => [add];
} 