part of '../root_bloc.dart';

class NotesBloc extends Bloc<NotesPageEvent, NotesPageState> {
  final User user;
  final TimeSlot timeslot;
  final GetNotes getNotes;
  String notes;
  final EditNotes editNotes;
  NotesBloc(
      {@required this.user,
      @required this.timeslot,
      @required this.getNotes,
      @required this.editNotes}) {
    this.add(NotesPageCreatedEvent());
  }
  @override
  NotesPageState get initialState => NotesPageLoadingState();

  @override
  Stream<NotesPageState> mapEventToState(NotesPageEvent event) async* {
    if (event is NotesPageCreatedEvent) {
      final result =
          await getNotes(GetNotesParams(venue: user.venue, timeSlot: timeslot));
      yield* result.fold(
        (failure) async* {
          yield NotesPageLoadFailedState(failure.message);
        },
        (str) async* {
          print("str: " + str.toString());
          notes = str;
          yield NotesPageLoadedState(notes);
        },
      );
    } else if (event is NotesPageEditEvent) {
      yield NotesPageEditLoadingState(event.newText);
      final result = await editNotes(EditNotesParams(
          newText: event.newText, venue: user.venue, timeSlot: timeslot));
      yield* result.fold(
        (failure) async* {
          yield NotesPageEditFailedState(notes, failure.message);
        },
        (str) async* {
          notes = str;
          yield NotesPageEditSuccessfulState(notes);
        },
      );
    }
  }
}
