part of '../root_bloc.dart';

class TimeSlotsBloc extends Bloc<TimeSlotEvent, TimeSlotsState> {
  final GetTimeSlots getTimeSlots;
  final User user;
  final DeleteTimeSlot delete;
  TimeSlotsBloc({@required this.getTimeSlots,@required this.user, @required this.delete}) {
    this.add(TimeSlotCreation());
  }
  Map<String, List<TimeSlot>> timeSlots;
  @override
  TimeSlotsState get initialState => TimeSlotsLoadingState(user);

  @override
  Stream<TimeSlotsState> mapEventToState(TimeSlotEvent event) async* {
    if (event is TimeSlotCreation) {
      final timeSlotsOrFail = await getTimeSlots(GetTimeSlotsParams(venue: user.venue));
      yield* timeSlotsOrFail.fold((failure) async* {
        yield TimeSlotsLoadFailure(user, failure.message);
      }, (result) async* {
        timeSlots = result;
        if (timeSlots["current"].length == 0) {
          yield NoCurrentTimeSlots(user, []);
        } else {
          yield TimeSlotsCurrentState(user, timeSlots["current"]);
        }
      });
    } else if (event is TimeSlotsRequestHistory) {
      if (timeSlots == null) {
        yield TimeSlotsLoadingState(user);
      } else if (timeSlots["history"]?.length == 0) {
        yield NoPreviousTimeSlots(user, timeSlots["history"]);
      } else {
        yield TimeSlotsHistoryState(user, timeSlots["history"]);
      }
    } else if (event is TimeSlotsRequestCurrent) {
      if (timeSlots == null) {
        yield TimeSlotsLoadingState(user);
      } else if (timeSlots["current"]?.length == 0) {
        yield NoCurrentTimeSlots(user, timeSlots["current"]);
      } else {
        yield TimeSlotsCurrentState(user, timeSlots["current"]);
      }
    } else if (event is TimeSlotDeleteRequest) {
      yield DeleteConfirmState(user, timeSlots["current"], event.timeslot);
    } else if (event is TimeSlotDeleteConfirm) {
      yield DeleteLoading(user, timeSlots["current"], event.timeslot);
      final result = await delete(DeleteTimeSlotParams(timeslot: event.timeslot, venue: user.venue));
      yield* result.fold((failure) async* {
        yield DeleteFailed(user, timeSlots['current'], failure.message, event.timeslot);
      }, (res) async* {
        yield DeleteSucceeded(user, timeSlots['current'], event.timeslot);
      });
    }
  }
  
}