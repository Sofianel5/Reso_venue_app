import 'dart:async';

import 'package:Reso_venue/features/reso_venue/domain/usecases/add_timeslot.dart';
import 'package:Reso_venue/features/reso_venue/domain/usecases/change_attendees.dart';
import 'package:Reso_venue/features/reso_venue/domain/usecases/clear_attendees.dart';
import 'package:Reso_venue/features/reso_venue/domain/usecases/delete_timeslot.dart';
import 'package:Reso_venue/features/reso_venue/domain/usecases/get_cached_user.dart';
import 'package:Reso_venue/features/reso_venue/domain/usecases/get_help.dart';
import 'package:Reso_venue/features/reso_venue/domain/usecases/increment.dart';
import 'package:Reso_venue/routes/routes.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/localizations/messages.dart';
import '../../../../core/usecases/params.dart';
import '../../domain/entities/timeslot.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_timeslots.dart';
import '../../domain/usecases/get_user.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/scan.dart';

part 'account_page/account_bloc.dart';
part 'account_page/account_event.dart';
part 'account_page/account_state.dart';
part 'add_timeslot_page/add_timeslot_bloc.dart';
part 'add_timeslot_page/add_timeslot_event.dart';
part 'add_timeslot_page/add_timeslot_state.dart';
part 'timeslot_manage/timeslot_manage_bloc.dart';
part 'timeslot_manage/timeslot_manage_event.dart';
part 'timeslot_manage/timeslot_manage_state.dart';
part 'counter_page/counter_page_bloc.dart';
part 'counter_page/counter_page_event.dart';
part 'counter_page/counter_page_state.dart';
part 'home_page_bloc.dart';
part 'home_page_event.dart';
part 'home_page_state.dart';
part 'login_page_bloc.dart';
part 'login_page_event.dart';
part 'login_page_state.dart';
part 'help_page/help_bloc.dart';
part 'help_page/help_event.dart';
part 'help_page/help_state.dart';
part 'root_event.dart';
part 'root_state.dart';
part 'scan_page/scan_bloc.dart';
part 'scan_page/scan_event.dart';
part 'scan_page/scan_state.dart';
part 'timeslots_page/timeslots_bloc.dart';
part 'timeslots_page/timeslots_event.dart';
part 'timeslots_page/timeslots_state.dart';
class RootBloc extends Bloc<RootEvent, RootState> {
  final GetExistingUser getExistingUser;
  final Login login;
  final Logout logout;
  final LoginBlocRouter loginBloc;
  final GetTimeSlots getTimeSlots;
  final GetCachedUser getCachedUser;
  final Scan scan;
  final DeleteTimeSlot delete;
  final AddTimeSlot addTimeSlot;
  final GetHelp getHelp;
  final ChangeAttendees changeAttendees;
  final ClearAttendees clear;
  final Increment increment;
  User user;
  RootBloc({
    @required this.getExistingUser,
    @required this.getCachedUser,
    @required this.login,
    @required this.logout,
    @required this.getTimeSlots,
    @required this.scan,
    @required this.delete,
    @required this.addTimeSlot,
    @required this.getHelp,
    @required this.changeAttendees,
    @required this.clear,
    @required this.increment
  })  : this.loginBloc = LoginBlocRouter(login)
   {
    this.add(GetExistingUserEvent());
  }
  @override
  RootState get initialState => InitialState();

  @override
  Stream<RootState> mapEventToState(
    RootEvent event,
  ) async* {
    print(event);
    if (event is GetExistingUserEvent) {
      final result = await getExistingUser(NoParams());
      yield* result.fold((failure) async* {
        if (failure is AuthenticationFailure) {
          yield UnauthenticatedState();
        } else if (failure is ConnectionFailure) {
          final getCachedUserOrFailure = await getCachedUser(NoParams());
          yield* getCachedUserOrFailure.fold((failure) async* {
            yield ErrorState(message: Messages.NO_INTERNET);
          }, (_user) async* {
            user = _user;
            yield AuthenticatedState(user);
          });
        } else {
          yield ErrorState(message: failure.message);
        }
      }, (_user) async* {
        user = _user;
        yield AuthenticatedState(user);
      });
      print(user);
    } else if (event is LoginEvent) {
      yield* loginBloc.route(event);
      user = loginBloc.user;
    } else if (event is LogoutEvent) {
      user = null;
      await logout(NoParams());
      yield UnauthenticatedState();
    } else if (event is PopEvent) {
      ExtendedNavigator.rootNavigator.pop();
    } else if (event is PushManage) {
      ExtendedNavigator.ofRouter<Router>().pushNamed(Routes.manage, arguments: ManageScreenArguments(timeSlot: event.timeSlot));
    }
  }
}
