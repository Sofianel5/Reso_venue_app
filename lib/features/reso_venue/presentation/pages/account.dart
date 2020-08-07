import 'package:Reso_venue/core/localizations/localizations.dart';
import 'package:Reso_venue/features/reso_venue/domain/entities/venue.dart';
import 'package:Reso_venue/features/reso_venue/presentation/bloc/root_bloc.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AccountScreenState();
}

class AccountScreenState extends State<AccountScreen> {
  void _showLogoutDialog(RootBloc bloc) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(Localizer.of(context).get("logout-warning1")),
          content: Text(Localizer.of(context).get("logout-warning2")),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: Text(Localizer.of(context).get("Cancel")),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text(
                Localizer.of(context).get('logout'),
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                bloc.add(LogoutEvent());
              },
            ),
          ],
        );
      },
    );
  }

  _buildLogoutWidget(RootBloc bloc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () => _showLogoutDialog(bloc),
          child: Text(
            Localizer.of(context).get('logout'),
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final RootBloc rootBloc = BlocProvider.of<RootBloc>(context);
    return BlocListener(
      bloc: BlocProvider.of<AccountPageBloc>(context),
      listener: (context, state) {},
      child: BlocBuilder(
        bloc: BlocProvider.of<AccountPageBloc>(context),
        builder: (context, state) => SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 50, horizontal: 40),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(minHeight: 700),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 20,
                            offset: Offset(0, -10),
                          ),
                        ],
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(50),
                        ),
                        color: Color(0xFFF3F5F7),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 35),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 120,
                            ),
                            Text(
                              Localizer.of(context).get("your-account") ??
                                  "Your account",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 24,
                              ),
                            ),
                            Text(
                              state.user.firstName + " " + state.user.lastName,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 24),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  Localizer.of(context).get("your-venues"),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 24),
                                ),
                              ],
                            ),
                            for (int i = 0; i < state.user.venues.length; i++)
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(state.user.venues[i].title),
                                    Switch(
                                      value: state.user.currentVenue == i,
                                      onChanged: (value) => setState(
                                        () {
                                          BlocProvider.of<AccountPageBloc>(
                                                  context)
                                              .add(AccountVenueChange(i));
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  Localizer.of(context).get("Share"),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 24),
                                ),
                              ],
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("All your venues"),
                                    IconButton(
                                      icon: Icon(Icons.share),
                                      onPressed: () {
                                        String name =
                                            state.user.firstName + " " + state.user.lastName;
                                        Share.share(
                                            "View $name's listings on The Reso App " +
                                                state.user.shareLink);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            for (int i = 0; i < state.user.venues.length; i++)
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(state.user.venues[i].title),
                                    IconButton(
                                      icon: Icon(Icons.share),
                                      onPressed: () {
                                        String title =
                                            state.user.venues[i].title;
                                        Share.share(
                                            'View $title on The Reso App ' +
                                                state.user.venues[i].shareLink);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            SizedBox(
                              height: 30,
                            ),
                            _buildGetHelpButton(rootBloc),
                            SizedBox(
                              height: 30,
                            ),
                            _buildLogoutWidget(rootBloc),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Positioned(
                  top: 70,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Stack(children: [
                      Center(
                        child: Container(
                          width: 210,
                          height: 210,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(105),
                              color: Color(0xFFF3F5F7)),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Text(
                            state.user.firstName.substring(0, 1) +
                                state.user.lastName.substring(0, 1),
                            style: TextStyle(
                                fontSize: 50, fontWeight: FontWeight.w700),
                          ),
                        ),
                      )
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildGetHelpButton(RootBloc bloc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () => bloc.add(PushHelpPage()),
          child: Text(
            Localizer.of(context).get('get-help'),
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
        )
      ],
    );
  }
}
