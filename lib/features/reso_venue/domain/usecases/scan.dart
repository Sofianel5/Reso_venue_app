import 'package:Reso_venue/core/localizations/messages.dart';
import 'package:Reso_venue/core/util/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/params.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/venue.dart';
import '../repositories/root_repository.dart';

class Scan extends UseCase<bool, ScanParams> {
  final RootRepository repository;
  Scan(this.repository);

  @override 
  Future<Either<Failure, bool>> call(ScanParams params) async {
    if (InputConverter().isValidId(params.userId)) {
      return await repository.scan(params.userId, params.venue);
    }
    return Left(InvalidInputFailure(message: Messages.NOT_USER_ID));
  }
}

class ScanParams extends Params {
  final String userId;
  final Venue venue;
  ScanParams({@required this.userId, @required this.venue});
  @override
  List<Object> get props => [userId];
}