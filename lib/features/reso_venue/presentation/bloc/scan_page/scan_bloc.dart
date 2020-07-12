part of '../root_bloc.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  final User user;
  final Scan scan;

  ScanBloc(this.user, this.scan);
  @override
  ScanState get initialState => ScanIdleState(user);

  @override
  Stream<ScanState> mapEventToState(ScanEvent event) async* {
    if (event is ScanAttempted) {
      final result = await scan(ScanParams(userId: event.uuid, venue: user.venues[user.currentVenue]));
      yield* result.fold((failure) async* {
        yield ScanUnsuccessfulState(user, failure.message);
      }, (res) async* {
        yield ScanSuccessfulState(user);
      });
    } else if (event is ScanDissmissed) {
      yield ScanIdleState(user);
    }
  }
  
}