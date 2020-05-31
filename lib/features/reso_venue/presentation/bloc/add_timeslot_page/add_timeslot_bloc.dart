part of '../root_bloc.dart';

class AddTimeSlotBloc extends Bloc<AddTimeSlotEvent, AddTimeSlotState> {
  final User user;
  final AddTimeSlot addTimeSlot;

  AddTimeSlotBloc({this.user, this.addTimeSlot});
  
  @override
  AddTimeSlotState get initialState => AddTimeSlotInitial(user);

  @override
  Stream<AddTimeSlotState> mapEventToState(AddTimeSlotEvent event) async* {
    if (event is AddTimeSlotAttempt) {
      yield AddTimeSlotLoading(user);
      print(event.start);
      print(event.stop);
      final result = await addTimeSlot(AddTimeSlotParams(venue: user.venue, end: event.stop, start: event.start, numAttendees: event.numAttendees, type: event.type));
      yield* result.fold((failure) async* {
        yield AddTimeSlotFailure(user, failure.message);
      }, (success) async* {
        yield AddTimeSlotSuccess(user);
      });
    }
  }
  
}