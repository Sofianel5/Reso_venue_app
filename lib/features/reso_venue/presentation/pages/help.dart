import 'package:Reso_venue/core/localizations/localizations.dart';

import '../bloc/root_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HelpScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HelpScreenState();
}

class HelpScreenState extends State<HelpScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HelpBloc(
        getHelp: BlocProvider.of<RootBloc>(context).getHelp,
        user: BlocProvider.of<RootBloc>(context).user,
      ),
      child: HelpScreenChild(),
    );
  }
}

class HelpScreenChild extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HelpScreenChildState();
}

class HelpScreenChildState extends State<HelpScreenChild> {
  String message;
  TextEditingController customMessage = TextEditingController();
  Widget _buildSubmitButton(HelpState state) {
    return Container(
      width: double.infinity,
      child: RaisedButton(
        onPressed: () {
          if (!(state is LoadingHelpState)) {
            if (message == "other") {
              BlocProvider.of<HelpBloc>(context)
                  .add(RequestHelp(customMessage.text));
            } else {
              BlocProvider.of<HelpBloc>(context).add(RequestHelp(message));
            }
          }
        },
        elevation: 5,
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Theme.of(context).accentColor,
        child: (state is LoadingHelpState)
            ? Container(
                child: CircularProgressIndicator(backgroundColor: Colors.white))
            : Text(
                Localizer.of(context).get(
                  "Submit",
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: BlocProvider.of<HelpBloc>(context),
      listener: (context, state) {
        print(state);
        FocusScope.of(context).unfocus();
        if (state is FailedHelpState) {
          _key.currentState
              .showSnackBar(SnackBar(content: Text(state.message)));
        } else {
          _key.currentState.showSnackBar(
              SnackBar(content: Text(Localizer.of(context).get("Success"))));
        }
      },
      child: BlocBuilder(
        bloc: BlocProvider.of<HelpBloc>(context),
        builder: (context, state) {
          return Scaffold(
            key: _key,
            backgroundColor: Color(0xFFF3F5F7),
            body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      _buildTopRow(context),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ListTile(
                            title:
                                Text(Localizer.of(context).get('reschedule')),
                            leading: Radio(
                              value: "Reschedule time slots",
                              groupValue: message,
                              onChanged: (String value) {
                                setState(() {
                                  message = value;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: Text(
                                Localizer.of(context).get("change-details")),
                            leading: Radio(
                              value: "Change your details",
                              groupValue: message,
                              onChanged: (String value) {
                                setState(() {
                                  message = value;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: Text(Localizer.of(context).get('other')),
                            leading: Radio(
                              value: "other",
                              groupValue: message,
                              onChanged: (String value) {
                                setState(() {
                                  message = value;
                                });
                              },
                            ),
                          ),
                          if (message == "other")
                            ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: 100),
                              child: Scrollbar(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  reverse: false,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        gapPadding: 0,
                                      ),
                                    ),
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    controller: customMessage,
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
                      Spacer(),
                      _buildSubmitButton(state)
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Padding _buildTopRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              BlocProvider.of<RootBloc>(context).add(PopEvent());
            },
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              iconSize: 30,
              color: Colors.black,
              onPressed: () {
                BlocProvider.of<RootBloc>(context).add(PopEvent());
              },
            ),
          ),
          Text(
            Localizer.of(context).get("get-help"),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 25,
            ),
          ),
          Container(
            width: 40,
          ),
        ],
      ),
    );
  }
}
