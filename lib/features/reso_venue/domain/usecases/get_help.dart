import '../../../../core/util/input_converter.dart';
import '../entities/venue.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/params.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/root_repository.dart';

class GetHelp extends UseCase<bool, GetHelpParams> {
  final RootRepository repository;
  GetHelp(this.repository);

  @override 
  Future<Either<Failure,bool>> call(GetHelpParams params) async {
    return InputConverter().validateHelpForm(params.info).fold((failure) async {
      return Left(failure);
    }, (success) async {
      return await repository.getHelp(params.info, params.venue);
    });
  }
}

class GetHelpParams extends Params {
  final String info;
  final Venue venue;
  GetHelpParams({@required this.info, @required this.venue});
  @override
  List<Object> get props => [info];
}