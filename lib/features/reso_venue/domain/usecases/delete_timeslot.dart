import 'package:Reso_venue/features/reso_venue/domain/entities/timeslot.dart';

import '../../../../core/util/input_converter.dart';
import '../entities/venue.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/params.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/root_repository.dart';

class DeleteTimeSlot extends UseCase<bool, DeleteTimeSlotParams> {
  final RootRepository repository;
  DeleteTimeSlot(this.repository);

  @override 
  Future<Either<Failure,bool>> call(DeleteTimeSlotParams params) async {
    return await repository.deleteTimeSlot(venue: params.venue, timeslot: params.timeslot);
  }
}

class DeleteTimeSlotParams extends Params {
  final TimeSlot timeslot;
  final Venue venue;
  DeleteTimeSlotParams({@required this.timeslot, @required this.venue});
  @override
  List<Object> get props => [venue, timeslot];
}