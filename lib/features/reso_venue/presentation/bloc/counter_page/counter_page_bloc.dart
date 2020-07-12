part of '../root_bloc.dart';

class CounterPageBloc extends Bloc<CounterPageEvent, CounterPageState> {
  CounterPageBloc(
      {@required this.clear, @required this.increment, @required this.user}) {
    add(CounterPageCreated());
  }

  final ClearAttendees clear;
  final Increment increment;
  final User user;

  @override
  CounterPageState get initialState => CounterPageLoading(user);

  @override
  Stream<CounterPageState> mapEventToState(CounterPageEvent event) async* {
    print(event);
    if (event is CounterPageCreated) {
      final result =
          await increment(IncrementParams(increment: 0, venue: user.venues[user.currentVenue]));
      yield* result.fold(
        (failure) async* {
          yield CounterPageLoadFailed(user, failure.message);
        },
        (res) async* {
          yield CounterPageLoaded(user, res);
        },
      );
    } else if (event is CounterPageClearConfirm) {
      yield CounterPageLoading(user);
      final result = await clear(ClearParams(venue: user.venues[user.currentVenue]));
      yield* result.fold(
        (failure) async* {
          yield CounterPageLoadFailed(user, failure.message);
        },
        (res) async* {
          yield CounterPageLoaded(user, 0);
        },
      );
    } else if (event is CounterPageIncrement) {
      yield CounterPageLoading(user);
      final result = await increment(
          IncrementParams(increment: event.by, venue: user.venues[user.currentVenue]));
      yield* result.fold(
        (failure) async* {
          yield CounterPageLoadFailed(user, failure.message);
        },
        (res) async* {
          yield CounterPageLoaded(user, res);
        },
      );
    }
  }
}
