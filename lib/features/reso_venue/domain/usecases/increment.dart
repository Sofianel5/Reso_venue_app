import 'package:Reso_venue/core/localizations/messages.dart';
import 'package:Reso_venue/core/util/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/params.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/venue.dart';
import '../repositories/root_repository.dart';

class Increment extends UseCase<int, IncrementParams> {
  final RootRepository repository;
  Increment(this.repository);
  @override 
  Future<Either<Failure, int>> call(IncrementParams params) async {
    return await repository.increment(params.increment, params.venue);
  }
}

class IncrementParams extends Params {
  final int increment;
  final Venue venue;
  IncrementParams({@required this.increment, @required this.venue});
  @override
  List<Object> get props => [increment];
}