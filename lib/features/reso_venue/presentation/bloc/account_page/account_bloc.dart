part of '../root_bloc.dart';

class AccountPageBloc extends Bloc<AccountPageEvent, AccountState> {
  User user;
  AccountPageBloc(this.user, this.changeVenue);
  ChangeVenue changeVenue;

  @override
  AccountState get initialState => AccountLoadedState(user);

  @override
  Stream<AccountState> mapEventToState(AccountPageEvent event) async* {
    if (event is AccountPageOpened) {
      yield AccountLoadedState(user);
    } else if (event is AccountVenueChange) {
      yield* (await changeVenue(ChangeVenueParams(user, event.idx))).fold((failure) async* {
        print("failed");
        print(user.currentVenue);
        yield AccountLoadedState(user);
      }, (user) async* {
        print("change succeeded");
        print(user.currentVenue);
        yield AccountLoadedState(user);
      });
    }
  }
}