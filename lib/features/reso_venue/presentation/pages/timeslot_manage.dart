import 'package:Reso_venue/features/reso_venue/domain/entities/timeslot.dart';
import 'package:Reso_venue/features/reso_venue/presentation/bloc/root_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ManageScreen extends StatefulWidget {
  ManageScreen({@required this.timeSlot});
  TimeSlot timeSlot;

  @override
  State<StatefulWidget> createState() => _ManageScreenState();
}

class _ManageScreenState extends State<ManageScreen> {
  @override
  Widget build(BuildContext context) {
    final rootBloc = BlocProvider.of<RootBloc>(context);
    return BlocProvider(
      create: (context) => TimeSlotManageBloc(
        user: rootBloc.user,
        delete: rootBloc.delete,
        timeslot: widget.timeSlot,
        changeAttendees: rootBloc.changeAttendees,
      ),
      child: ManageScreenChild(),
    );
  }
}

class ManageScreenChild extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ManageScreenChildState();
}

class _ManageScreenChildState extends State<ManageScreenChild> {
  bool alreadyPopped = false;

  @override
  Widget build(BuildContext context) {
    final rootBloc = BlocProvider.of<RootBloc>(context);
    final bloc = BlocProvider.of<TimeSlotManageBloc>(context);
    return BlocListener(
      listener: (context, state) {
        if (state is ManageDialogueState) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                //! LOCALIZE
                title: _buildDeleteTitle(state),
                content: _buildDeleteContents(state),
                actions: _buildDeleteActions(bloc),
              );
            },
          );
        } else if (state is ManageSnackBarState) {
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      bloc: bloc,
      child: BlocBuilder(
        bloc: bloc,
        builder: (context, state) => Scaffold(
          backgroundColor: Color(0xFFF3F5F7),
          body: SafeArea(
            bottom: false,
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
                      Text("Manage time slot"),
                      Container(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20),
                  child: Container(
                    height: MediaQuery.of(context).size.height - 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Pass for " + state.timeSlot.type,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  )
                                ],
                              ),
                              SizedBox(height: 30),
                              Text(
                                DateFormat("EEEEE, M/d/y ")
                                        .format(state.timeSlot.start) +
                                    DateFormat("jm")
                                        .format(state.timeSlot.start),
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: 30),
                              Text(
                                "to",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: 30),
                              Text(
                                DateFormat("EEEEE, M/d/y ")
                                        .format(state.timeSlot.stop) +
                                    DateFormat("jm")
                                        .format(state.timeSlot.stop),
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        _buildSubtractButton(state, bloc, context),
                        SizedBox(height: 20,),
                        _buildAddButton(state, bloc, context),
                        SizedBox(height: 20,),
                        _buildDeleteButton(state, bloc, context)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

    Widget _buildDeleteTitle(ManageDialogueState state) {
    if (state is DeleteConfirm) {
      //! Localize
      return Text("Delete time slot?");
    }
  }

  Widget _buildDeleteContents(ManageDialogueState state) {
    if (state is DeleteConfirm) {
      //! Localize
      return Text("This action cannot be reverted");
    }
  }

  List<Widget> _buildDeleteActions(TimeSlotManageBloc bloc) {
    if (bloc.state is DeleteConfirm) {
      //! Localize
      return <Widget>[
        new FlatButton(
          child: new Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        new FlatButton(
          child: new Text(
            //! LOCALIZE
            "Confirm",
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            bloc.add(TimeSlotDeleteConfirm());
          },
        ),
      ];
    }
  }

  Widget _buildDeleteButton(TimeSlotManageState state, TimeSlotManageBloc bloc, BuildContext context) {
    return Container(
      width: double.infinity,
      child: RaisedButton(
        onPressed: () {
          if (!(state is LoadingTimeSlot)) {
            bloc.add(
              TimeSlotDeleteRequest(),
            );
          }
        },
        elevation: 5,
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: (state is LoadingTimeSlot)
            ? Colors.grey
            : Colors.red,
        child: Text(
          "Register",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
  Widget _buildAddButton(TimeSlotManageState state, TimeSlotManageBloc bloc, BuildContext context) {
    return Container(
      width: double.infinity,
      child: RaisedButton(
        onPressed: () {
          if (!(state is LoadingTimeSlot)) {
            bloc.add(
              AddAttendeeEvent(),
            );
          }
        },
        elevation: 5,
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: (state is LoadingTimeSlot)
            ? Colors.grey
            : Theme.of(context).accentColor,
        child: Text(
          "Add external attendee",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
  Widget _buildSubtractButton(TimeSlotManageState state, TimeSlotManageBloc bloc, BuildContext context) {
    return Container(
      width: double.infinity,
      child: RaisedButton(
        onPressed: () {
          if (!(state is LoadingTimeSlot)) {
            bloc.add(
              RemoveAttendeeEvent(),
            );
          }
        },
        elevation: 5,
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: (state is LoadingTimeSlot)
            ? Colors.grey
            : Theme.of(context).accentColor,
        child: Text(
          "Remove external attendee",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
