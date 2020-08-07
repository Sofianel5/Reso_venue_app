import 'package:Reso_venue/core/localizations/localizations.dart';
import 'package:Reso_venue/features/reso_venue/domain/entities/timeslot.dart';
import 'package:Reso_venue/features/reso_venue/domain/entities/user.dart';
import 'package:Reso_venue/features/reso_venue/presentation/bloc/root_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class NotesScreen extends StatefulWidget {
  NotesScreen({@required this.timeSlot});
  TimeSlot timeSlot;

  @override
  State<StatefulWidget> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  Widget build(BuildContext context) {
    final rootBloc = BlocProvider.of<RootBloc>(context);
    return BlocProvider(
        create: (context) => NotesBloc(
              user: rootBloc.user,
              timeslot: widget.timeSlot,
              editNotes: rootBloc.editNotes,
              getNotes: rootBloc.getNotes,
            ),
        child: NotesScreenChild(timeSlot: widget.timeSlot));
  }
}

class NotesScreenChild extends StatefulWidget {
  NotesScreenChild({@required this.timeSlot});
  TimeSlot timeSlot;
  @override
  State<StatefulWidget> createState() => _NotesScreenChildState();
}

class _NotesScreenChildState extends State<NotesScreenChild> {
  bool alreadyPopped = false;
  final _key = GlobalKey<ScaffoldState>();
  TextEditingController _notes = TextEditingController();
  FocusNode notesNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rootBloc = BlocProvider.of<RootBloc>(context);
    return BlocListener(
      bloc: BlocProvider.of<NotesBloc>(context),
      listener: (context, state) {
        if (state is NotesPageEditFailedState ||
            state is NotesPageLoadFailedState) {
          _key.currentState.showSnackBar(SnackBar(
              content: Text(Localizer.of(context).get(state.message))));
        } else if (state is NotesPageEditSuccessfulState) {
          _key.currentState.showSnackBar(
              SnackBar(content: Text(Localizer.of(context).get("Success"))));
        } else if (state is NotesPageLoadedState) {
          _notes = TextEditingController(text: state.notes);
        }
      },
      child: BlocBuilder(
        bloc: BlocProvider.of<NotesBloc>(context),
        builder: (context, state) => GestureDetector(
          onTap: () => notesNode.unfocus(),
          child: Scaffold(
            key: _key,
            backgroundColor: Color(0xFFF3F5F7),
            body: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  buildTop(rootBloc, context),
                  if (state is NotesPageLoadingState)
                    CircularProgressIndicator(),
                  if (!(state is NotesPageLoadFailedState ||
                      state is NotesPageLoadingState))
                    buildTextBox(state),
                  Spacer(),
                  if (!(state is NotesPageLoadFailedState ||
                      state is NotesPageLoadingState))
                    _buildSubmitButton(
                        state, BlocProvider.of<NotesBloc>(context), context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding buildTop(RootBloc rootBloc, BuildContext context) {
    return Padding(
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
          Text(Localizer.of(context).get("Notes"),
              style: Theme.of(context).textTheme.headline6),
          Container(
            width: 40,
          ),
        ],
      ),
    );
  }

  Widget buildTextBox(NotesPageLoadedState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
      child: Container(
        child: TextFormField(
          autofocus: true,
          controller: _notes,
          focusNode: notesNode,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 2,
              ),
            ),
          ),
          keyboardType: TextInputType.multiline,
          textCapitalization: TextCapitalization.sentences,
          maxLines: null,
        ),
      ),
    );
  }

  Widget _buildSubmitButton(
      NotesPageState state, NotesBloc bloc, BuildContext context) {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: RaisedButton(
          onPressed: () {
            notesNode.unfocus();
            bloc.add(
              NotesPageEditEvent(_notes.text),
            );
          },
          elevation: 5,
          padding: EdgeInsets.all(15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          color: Theme.of(context).accentColor,
          child: (state is NotesPageEditLoadingState)
              ? CircularProgressIndicator(backgroundColor: Colors.white,)
              : Text(
                  Localizer.of(context).get("Save"),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
