import 'package:Reso_venue/core/localizations/messages.dart';
import 'package:Reso_venue/core/util/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/params.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/venue.dart';
import '../repositories/root_repository.dart';

class ClearAttendees extends UseCase<bool, ClearParams> {
  final RootRepository repository;
  ClearAttendees(this.repository);
  @override 
  Future<Either<Failure, bool>> call(ClearParams params) async {
    return await repository.clear(params.venue);
  }
}

class ClearParams extends Params {
  final Venue venue;
  ClearParams({@required this.venue});
  @override
  List<Object> get props => [venue];
}