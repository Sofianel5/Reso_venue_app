import 'package:Reso_venue/features/reso_venue/domain/entities/timeslot.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/params.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/venue.dart';
import '../repositories/root_repository.dart';

class EditNotes extends UseCase<String, EditNotesParams> {
  final RootRepository repository;
  EditNotes(this.repository);
  @override 
  Future<Either<Failure, String>> call(EditNotesParams params) async {
    return await repository.editNotes(params.newText, params.venue, params.timeSlot);
  }
}

class EditNotesParams extends Params {
  final TimeSlot timeSlot;
  final Venue venue;
  final String newText;
  EditNotesParams({@required this.timeSlot, @required this.venue, @required this.newText});
  @override
  List<Object> get props => [timeSlot, venue, newText];
}