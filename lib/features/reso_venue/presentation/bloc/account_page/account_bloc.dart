part of '../root_bloc.dart';

class AccountPageBloc extends Bloc<AccountPageEvent, AccountState> {
  User user;
  AccountPageBloc(this.user);
  Stream<RootState> route(AccountPageEvent event, User user) async* {
    yield AccountLoadedState(user);
  }

  @override
  AccountState get initialState => AccountLoadedState(user);

  @override
  Stream<AccountState> mapEventToState(AccountPageEvent event) async* {
    if (event is AccountPageOpened) {
      yield AccountLoadedState(user);
    } else if (event is AccountVenueChange) {
      user.currentVenue = event.idx;
      yield AccountLoadedState(user);
    }
  }
}