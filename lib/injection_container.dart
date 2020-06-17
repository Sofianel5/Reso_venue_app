import 'package:flutter/material.dart';

import 'features/reso_venue/domain/usecases/change_attendees.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'core/util/input_converter.dart';
import 'features/reso_venue/data/datasources/local_datasource.dart';
import 'features/reso_venue/data/datasources/remote_datasource.dart';
import 'features/reso_venue/data/repositories/root_repository_imp.dart';
import 'features/reso_venue/domain/repositories/root_repository.dart';
import 'features/reso_venue/domain/usecases/add_timeslot.dart';
import 'features/reso_venue/domain/usecases/clear_attendees.dart';
import 'features/reso_venue/domain/usecases/delete_timeslot.dart';
import 'features/reso_venue/domain/usecases/get_cached_user.dart';
import 'features/reso_venue/domain/usecases/get_help.dart';
import 'features/reso_venue/domain/usecases/get_timeslots.dart';
import 'features/reso_venue/domain/usecases/get_user.dart';
import 'features/reso_venue/domain/usecases/increment.dart';
import 'features/reso_venue/domain/usecases/login.dart';
import 'features/reso_venue/domain/usecases/logout.dart';
import 'features/reso_venue/domain/usecases/scan.dart';
import 'features/reso_venue/presentation/bloc/root_bloc.dart';

final sl = GetIt.instance;
Future<void> init() async {
  sl.registerFactory(() => RootBloc(increment: sl(), clear: sl(), changeAttendees: sl(), getHelp: sl(), delete: sl(), addTimeSlot: sl(), getExistingUser: sl(), getCachedUser: sl(), login: sl(), logout: sl(), getTimeSlots: sl(), scan: sl()));

  // Usecases
  sl.registerLazySingleton<Increment>(() => Increment(sl()));
  sl.registerLazySingleton<ClearAttendees>(() => ClearAttendees(sl()));
  sl.registerLazySingleton<ChangeAttendees>(() =>ChangeAttendees(sl()));
  sl.registerLazySingleton<GetHelp>(() => GetHelp(sl()));
  sl.registerLazySingleton<DeleteTimeSlot>(() => DeleteTimeSlot(sl()));
  sl.registerLazySingleton<AddTimeSlot>(() => AddTimeSlot(sl()));
  sl.registerLazySingleton<GetExistingUser>(() => GetExistingUser(sl()));
  sl.registerLazySingleton<GetCachedUser>(() => GetCachedUser(sl()));
  sl.registerLazySingleton<Login>(() => Login(sl()));
  sl.registerLazySingleton<Logout>(() => Logout(sl()));
  sl.registerLazySingleton<GetTimeSlots>(()=>GetTimeSlots(sl()));
  sl.registerLazySingleton<Scan>(()=>Scan(sl()));
  
  //repositories
  sl.registerLazySingleton<RootRepository>(() => RootRepositoryImpl(remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()));
  // Register data sources 
  sl.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl(sl()));
  sl.registerLazySingleton<RemoteDataSource>(() => RemoteDataSourceImpl(client: sl()));
  //! Core
  sl.registerLazySingleton<InputConverter>(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External dependencies
  sl.registerLazySingleton<DataConnectionChecker>(() => DataConnectionChecker());
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<http.Client>(() => http.Client());
}