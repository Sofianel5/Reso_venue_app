import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/params.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/root_repository.dart';

class ChangeVenue extends UseCase<User, ChangeVenueParams> {
  final RootRepository repository;
  ChangeVenue(this.repository);

  @override 
  Future<Either<Failure, User>> call(ChangeVenueParams params) async {
    return await repository.changeVenue(params.user, params.index);
  }
}
class ChangeVenueParams extends Params {
  User user;
  int index;
  ChangeVenueParams(this.user, this.index);
  @override
  List<Object> get props => [user, index];
} 