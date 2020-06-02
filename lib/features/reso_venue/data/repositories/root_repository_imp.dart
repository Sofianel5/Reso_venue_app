import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/localizations/messages.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/coordinates.dart';
import '../../domain/entities/thread.dart';
import '../../domain/entities/timeslot.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/venue.dart';
import '../../domain/repositories/root_repository.dart';
import '../datasources/local_datasource.dart';
import '../datasources/remote_datasource.dart';
import '../models/user_model.dart';
import '../models/venue_model.dart';

typedef Future<Either<Failure, User>> _GetUser();
typedef Future<Either<Failure, Map<String, dynamic>>> _GetMap();

class RootRepositoryImpl implements RootRepository {
  final RemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final LocalDataSource localDataSource;

  RootRepositoryImpl({
    @required this.remoteDataSource,
    @required this.networkInfo,
    @required this.localDataSource,
  });

  Future<Either<Failure, User>> _getUser(_GetUser body) async {
    if (await networkInfo.isConnected) {
      try {
        return await body();
      } catch (e) {
        if (e is SignUpException) {
          return Left(AuthenticationFailure(message: e.message));
        } else if (e is NotAdminException) {
          return Left(NotAdminFailure());
        } else if (e is NeedsUpdateException) {
          return Left(NeedsUpdateFailure());
        } else if (e is AuthenticationException) {
          return Left(
              AuthenticationFailure(message: Messages.INVALID_PASSWORD));
        } else if (e is ServerException) {
          return Left(ServerFailure(message: Messages.SERVER_FAILURE));
        } else if (e is CacheException) {
          return Left(AuthenticationFailure(message: Messages.NO_USER));
        }
        return Left(AuthenticationFailure(message: Messages.UNKNOWN_ERROR));
      }
    } else {
      // No internet
      return Left(ConnectionFailure(message: Messages.NO_INTERNET));
    }
  }

  @override
  Future<Either<Failure, User>> getUser() async {
    return await _getUser(() async {
      final String authToken = await localDataSource.getAuthToken();
      final String appVersion = Constants.APP_VERSION.toString();
      print(appVersion);
      Map<String, String> header = Map<String, String>.from(<String, String>{
        "Authorization": "Token " + authToken.toString(),
        "APP-VERSION": appVersion
      });
      final UserModel user = await remoteDataSource.getUser(header);
      print("User in get");
      print(user);
      try {
        localDataSource.cacheUser(user);
      } catch (e) {
        print(e);
      }
      return Right(user);
    });
  }

  @override
  Future<Either<Failure, User>> login({String email, String password}) async {
    return await _getUser(() async {
      final String authToken =
          await remoteDataSource.login(email: email, password: password);
      final String appVersion = Constants.APP_VERSION.toString();
      Map<String, String> header = Map<String, String>.from(<String, String>{
        "Authorization": "Token " + authToken.toString(),
        "APP-VERSION": appVersion
      });
      print("getting user");
      final User user = await remoteDataSource.getUser(header);
      print("User in login");
      print(user);
      localDataSource.cacheAuthToken(authToken);
      return Right(user);
    });
  }

  Future<Either<Failure, Map<String, dynamic>>> _getMap(
      _GetMap remote, _GetMap local) async {
    if (await networkInfo.isConnected) {
      try {
        return await remote();
      } on AuthenticationException {
        // Some error like 403
        return Left(AuthenticationFailure(message: Messages.INVALID_PASSWORD));
      } on ServerException {
        // Some server error 500
        return Left(ServerFailure(message: Messages.SERVER_FAILURE));
      } on CacheException {
        // No stored auth token
        return Left(AuthenticationFailure(message: Messages.NO_USER));
      } catch (e) {
        return Left(UnknownFailure());
      }
    } else {
      try {
        return await local();
      } on CacheException {
        return Left(AuthenticationFailure(message: Messages.NO_USER));
      } catch (e) {
        return Left(UnknownFailure());
      }
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearData();
      return Right(null);
    } on CacheException {
      return Left(CacheFailure(message: Messages.CACHE_WRITE_FAILURE));
    }
  }

  @override
  Future<Either<Failure, User>> getCachedUser() async {
    try {
      return Right(await localDataSource.getCachedUser());
    } on CacheException {
      return Left(CacheFailure(message: Messages.NO_USER));
    }
  }

  @override
  Future<Either<Failure, Map<String, List<TimeSlot>>>> getTimeSlots(
      Venue venue) async {
    if (await networkInfo.isConnected) {
      try {
        final String authToken = await localDataSource.getAuthToken();
        Map<String, String> header = Map<String, String>.from(
            <String, String>{"Authorization": "Token " + authToken.toString()});
        Map<String, List<TimeSlot>> res =
            await remoteDataSource.getTimeSlots(venue.id, header);
        return Right(res);
      } on CannotRegisterException {
        return Left(CannotRegisterFailure());
      } on AuthenticationException {
        return Left(
          AuthenticationFailure(message: Messages.AUTHENTICATION_FAILURE),
        );
      } on CacheException {
        return Left(
            AuthenticationFailure(message: Messages.AUTHENTICATION_FAILURE));
      } catch (e) {
        print(e);
        return Left(UnknownFailure());
      }
    } else {
      return Left(ConnectionFailure(message: Messages.NO_INTERNET));
    }
  }

  @override
  Future<Either<Failure, bool>> addTimeSlot(
      {DateTime start,
      DateTime stop,
      int numAttendees,
      String type,
      Venue venue}) async {
    if (await networkInfo.isConnected) {
      try {
        final String authToken = await localDataSource.getAuthToken();
        Map<String, String> header = Map<String, String>.from(
            <String, String>{"Authorization": "Token " + authToken.toString()});
        bool res = await remoteDataSource.addTimeSlot(
            start: start,
            stop: stop,
            numAttendees: numAttendees,
            type: type,
            venue: venue,
            headers: header);
        return Right(res);
      } on AuthenticationException {
        return Left(
          AuthenticationFailure(message: Messages.AUTHENTICATION_FAILURE),
        );
      } on ServerException {
        return Left(ServerFailure(message: Messages.SERVER_FAILURE));
      } on CacheException {
        return Left(
            AuthenticationFailure(message: Messages.AUTHENTICATION_FAILURE));
      } catch (e) {
        print(e);
        return Left(UnknownFailure());
      }
    } else {
      return Left(ConnectionFailure(message: Messages.NO_INTERNET));
    }
  }

  @override
  Future<Either<Failure, bool>> scan(String userId, Venue venue) async {
    if (await networkInfo.isConnected) {
      try {
        final String authToken = await localDataSource.getAuthToken();
        Map<String, String> header = Map<String, String>.from(
            <String, String>{"Authorization": "Token " + authToken.toString()});
        final res = await remoteDataSource.scan(userId, venue, header);
        return Right(res);
      } on LockedUserException {
        return Left(LockedFailure());
      } on UserNotRegistered {
        return Left(NotRegisteredFailure());
      } on AuthenticationException {
        return Left(
          AuthenticationFailure(message: Messages.AUTHENTICATION_FAILURE),
        );
      } on CacheException {
        return Left(
            AuthenticationFailure(message: Messages.AUTHENTICATION_FAILURE));
      } catch (e) {
        print(e);
        return Left(UnknownFailure());
      }
    } else {
      return Left(ConnectionFailure(message: Messages.NO_INTERNET));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteTimeSlot(
      {Venue venue, TimeSlot timeslot}) async {
    if (await networkInfo.isConnected) {
      try {
        final String authToken = await localDataSource.getAuthToken();
        Map<String, String> header = Map<String, String>.from(<String, String>{
          "Authorization": "Token " + authToken.toString(),
        });
        final res = await remoteDataSource.deleteTimeSlot(timeslot, venue, header);
        return Right(res);
      } on LockedUserException {
        return Left(LockedFailure());
      } on UserNotRegistered {
        return Left(NotRegisteredFailure());
      } on AuthenticationException {
        return Left(
          AuthenticationFailure(message: Messages.AUTHENTICATION_FAILURE),
        );
      } on CacheException {
        return Left(
            AuthenticationFailure(message: Messages.AUTHENTICATION_FAILURE));
      } catch (e) {
        print(e);
        return Left(UnknownFailure());
      }
    } else {
      return Left(ConnectionFailure(message: Messages.NO_INTERNET));
    }
  }

  @override
  Future<Either<Failure, bool>> getHelp(String message, Venue venue) async {
    if (await networkInfo.isConnected) {
      try {
        final String authToken = await localDataSource.getAuthToken();
        Map<String, String> header = Map<String, String>.from(<String, String>{
          "Authorization": "Token " + authToken.toString(),
        });
        final res = await remoteDataSource.getHelp(message, venue, header);
        return Right(res);
      } on LockedUserException {
        return Left(LockedFailure());
      } on UserNotRegistered {
        return Left(NotRegisteredFailure());
      } on AuthenticationException {
        return Left(
          AuthenticationFailure(message: Messages.AUTHENTICATION_FAILURE),
        );
      } on CacheException {
        return Left(
            AuthenticationFailure(message: Messages.AUTHENTICATION_FAILURE));
      } catch (e) {
        print(e);
        return Left(UnknownFailure());
      }
    } else {
      return Left(ConnectionFailure(message: Messages.NO_INTERNET));
    }
  }

  @override
  Future<Either<Failure, TimeSlot>> changeAttendees(bool add, Venue venue, TimeSlot timeslot) async {
    if (await networkInfo.isConnected) {
      try {
        final String authToken = await localDataSource.getAuthToken();
        Map<String, String> header = Map<String, String>.from(<String, String>{
          "Authorization": "Token " + authToken.toString(),
        });
        final res = await remoteDataSource.changeAttendees(add, venue, timeslot, header);
        return Right(res);
      } on CannotChangeException {
        return Left(CannotChangeFailure());
      } on AuthenticationException {
        return Left(
          AuthenticationFailure(message: Messages.AUTHENTICATION_FAILURE),
        );
      } on CacheException {
        return Left(
            AuthenticationFailure(message: Messages.AUTHENTICATION_FAILURE));
      } catch (e, stacktrace) {
        print(e);
        print(stacktrace);
        return Left(UnknownFailure());
      }
    } else {
      return Left(ConnectionFailure(message: Messages.NO_INTERNET));
    }
  }
}
