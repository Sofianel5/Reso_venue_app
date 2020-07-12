part of '../root_bloc.dart';

class TimeSlotManageBloc extends Bloc<TimeSlotManageEvent, TimeSlotManageState> {
  final User user;
  final DeleteTimeSlot delete;
  TimeSlot timeslot;
  final ChangeAttendees changeAttendees;
  TimeSlotManageBloc({@required this.user, @required this.delete, @required this.timeslot, @required this.changeAttendees});
  @override
  TimeSlotManageState get initialState => TimeSlotManageInitialState(user, timeslot);

  @override
  Stream<TimeSlotManageState> mapEventToState(TimeSlotManageEvent event) async* {
    if (event is TimeSlotDeleteRequest) {
      yield DeleteConfirm(user, timeslot);
    } else if (event is TimeSlotDeleteConfirm) {
      yield LoadingTimeSlot(user, timeslot);
      final result = await delete(DeleteTimeSlotParams(timeslot: timeslot, venue: user.venues[user.currentVenue]));
      yield* result.fold((failure) async* {
        yield DeleteFailed(user, failure.message, timeslot);
      }, (res) async* {
        yield DeleteSucceeded(user, timeslot);
      });
    } else if (event is AddAttendeeEvent) {
      yield LoadingTimeSlot(user, timeslot);
      final result = await changeAttendees(ChangeAttendeesParams(add: true, timeslot: timeslot, venue: user.venues[user.currentVenue]));
      yield* result.fold((failure) async* {
        yield ChangeAttendeesFailed(user, timeslot, Messages.CANNOT_ADD);
      }, (_timeslot) async* {
        timeslot = _timeslot;
        yield TimeSlotManageInitialState(user, timeslot);
      });
    } else if (event is RemoveAttendeeEvent) {
      yield LoadingTimeSlot(user, timeslot);
      final result = await changeAttendees(ChangeAttendeesParams(add: false, timeslot: timeslot, venue: user.venues[user.currentVenue]));
      yield* result.fold((failure) async* {
        yield ChangeAttendeesFailed(user, timeslot, Messages.CANNOT_SUBTRACT);
      }, (_timeslot) async* {
        timeslot = _timeslot;
        yield TimeSlotManageInitialState(user, timeslot);
      });
    }
  }
}