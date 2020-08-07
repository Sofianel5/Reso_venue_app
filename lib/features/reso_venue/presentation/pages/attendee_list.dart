import 'package:Reso_venue/core/localizations/localizations.dart';
import 'package:Reso_venue/features/reso_venue/domain/entities/timeslot.dart';
import 'package:Reso_venue/features/reso_venue/domain/entities/user.dart';
import 'package:Reso_venue/features/reso_venue/presentation/bloc/root_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AttendeeListScreen extends StatefulWidget {
  AttendeeListScreen({@required this.timeSlot});
  TimeSlot timeSlot;

  @override
  State<StatefulWidget> createState() => _AttendeeListScreenState();
}

class _AttendeeListScreenState extends State<AttendeeListScreen> {
  @override
  Widget build(BuildContext context) {
    return AttendeeListScreenChild(timeSlot: widget.timeSlot);
  }
}

class AttendeeListScreenChild extends StatefulWidget {
  AttendeeListScreenChild({@required this.timeSlot});
  TimeSlot timeSlot;
  @override
  State<StatefulWidget> createState() => _AttendeeListScreenChildState();
}

class _AttendeeListScreenChildState extends State<AttendeeListScreenChild> {
  bool alreadyPopped = false;
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final rootBloc = BlocProvider.of<RootBloc>(context);
    return Scaffold(
      key: _key,
      backgroundColor: Color(0xFFF3F5F7),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (!alreadyPopped) {
                          rootBloc.add(PopEvent());
                          alreadyPopped = true;
                        }
                      },
                      child: IconButton(
                        icon: Icon(Icons.arrow_back),
                        iconSize: 30,
                        color: Colors.black,
                        onPressed: () {
                          if (!alreadyPopped) {
                            rootBloc.add(PopEvent());
                            alreadyPopped = true;
                          }
                        },
                      ),
                    ),
                    Text(Localizer.of(context).get("Attendees"),
                        style: Theme.of(context).textTheme.headline6),
                    Container(
                      width: 40,
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                child: Column(
                  children: [
                    for (User user in widget.timeSlot.attendees)
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 30,
                        child: Text(
                          user.firstName + " " + user.lastName,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    if (widget.timeSlot.numAttendees >
                        widget.timeSlot.attendees.length)
                      for (int i = 0;
                          i <
                              widget.timeSlot.numAttendees -
                                  widget.timeSlot.attendees.length;
                          i++)
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 30,
                          child: Text(
                            "External Attendee",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
