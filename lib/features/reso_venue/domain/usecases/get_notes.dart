import 'package:Reso_venue/features/reso_venue/domain/entities/timeslot.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/params.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/venue.dart';
import '../repositories/root_repository.dart';

class GetNotes extends UseCase<String, GetNotesParams> {
  final RootRepository repository;
  GetNotes(this.repository);
  @override 
  Future<Either<Failure, String>> call(GetNotesParams params) async {
    return await repository.getNotes(params.venue, params.timeSlot);
  }
}

class GetNotesParams extends Params {
  final TimeSlot timeSlot;
  final Venue venue;
  GetNotesParams({@required this.timeSlot, @required this.venue});
  @override
  List<Object> get props => [timeSlot, venue];
}