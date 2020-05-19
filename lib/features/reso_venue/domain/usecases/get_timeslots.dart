import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/params.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/timeslot.dart';
import '../entities/venue.dart';
import '../repositories/root_repository.dart';

class GetTimeSlots extends UseCase<Map<String, List<TimeSlot>>, GetTimeSlotsParams> {
  final RootRepository repository;
  GetTimeSlots(this.repository);

  @override 
  Future<Either<Failure, Map<String, List<TimeSlot>>>> call(GetTimeSlotsParams params) async {
    return await repository.getTimeSlots(params.venue);
  }
}

class GetTimeSlotsParams extends Params {
  final Venue venue;
  GetTimeSlotsParams({@required this.venue});

  @override
  List<Object> get props => [venue];
  
}