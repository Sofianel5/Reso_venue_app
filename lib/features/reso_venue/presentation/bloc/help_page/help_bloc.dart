part of '../root_bloc.dart';

class HelpBloc extends Bloc<HelpEvent, HelpState> {
  final User user;
  final GetHelp getHelp;

  HelpBloc({this.user, this.getHelp});
  
  @override
  HelpState get initialState => InitialHelpState(user);

  @override
  Stream<HelpState> mapEventToState(HelpEvent event) async* {
    if (event is RequestHelp) {
      yield LoadingHelpState(user);
      final result = await getHelp(GetHelpParams(venue: user.venues[user.currentVenue], info: event.message));
      yield* result.fold((failure) async* {
        print(failure.message);
        yield FailedHelpState(user, failure.message);
      }, (success) async* {
        yield SucceededHelpState(user);
      });
    }
  }
  
}