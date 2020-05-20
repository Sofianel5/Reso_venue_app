import 'package:Reso_venue/core/localizations/localizations.dart';

import '../../domain/entities/timeslot.dart';
import '../bloc/root_bloc.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AddTimeSlotScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddTimeSlotScreenState();
}

class _AddTimeSlotScreenState extends State<AddTimeSlotScreen> {
  TextEditingController _numAttendees = TextEditingController();
  DateTime start;
  DateTime stop;
  String type;
  final formatter = DateFormat('MM/dd/ hh:mm aaa');

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      listener: (context, state) {
        if (state is AddTimeSlotFailure) {
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      bloc: BlocProvider.of<AddTimeSlotBloc>(context),
      child: BlocBuilder(
        bloc: BlocProvider.of<AddTimeSlotBloc>(context),
        builder: (context, state) => Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildTopPadding(state),
              SizedBox(height: 20.0),
              Container(
                width: MediaQuery.of(context).size.width / 3,
                child: TextField(
                  //! Localize
                  decoration: InputDecoration(labelText: "Num attendees"),
                  controller: _numAttendees,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  //! Localize
                  Text("start",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: DateTimeField(
                      format: formatter,
                      onShowPicker: (context, currentValue) async {
                        final date = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            initialDate: currentValue ??
                                DateTime.now().add(Duration(days: 7)),
                            lastDate: DateTime(2100));
                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                                currentValue ?? DateTime.now()),
                          );
                          return DateTimeField.combine(date, time);
                        } else {
                          return currentValue;
                        }
                      },
                      onChanged: (date) => start = date,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  //! Localize
                  Text("stop",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: DateTimeField(
                      format: formatter,
                      onShowPicker: (context, currentValue) async {
                        final date = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            initialDate: currentValue ??
                                DateTime.now().add(Duration(days: 7)),
                            lastDate: DateTime(2100));
                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                                currentValue ?? DateTime.now()),
                          );
                          return DateTimeField.combine(date, time);
                        } else {
                          return currentValue;
                        }
                      },
                      onChanged: (date) => stop = date,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  //! Localize
                  Text("type",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                  DropdownButton(
                    dropdownColor: Colors.white,
                    iconSize: 24,
                    elevation: 16,
                    //! Localize
                    items: TimeSlot.types
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      type = value;
                    },
                    icon: Icon(Icons.arrow_downward),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              _buildSubmitButton(BlocProvider.of<AddTimeSlotBloc>(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton(AddTimeSlotBloc bloc) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: GestureDetector(
        onTap: () {
          bloc.add(
            AddTimeSlotAttempt(
              type: type,
              start: start,
              stop: stop,
              numAttendees: int.parse(_numAttendees.text),
            ),
          );
        },
        child: AnimatedContainer(
            duration: Duration(seconds: 1),
            curve: Curves.fastOutSlowIn,
            decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.circular(15)),
            width: MediaQuery.of(context).size.width / 3,
            height: MediaQuery.of(context).size.height / 10,
            child: Center(
              child: bloc.state is AddTimeSlotLoading
                  ? CircularProgressIndicator(backgroundColor: Colors.white,)
                  : Text(
                      Localizer.of(context).get("submit") ?? "Submit",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            )),
      ),
    );
  }

  Padding buildTopPadding(AuthenticatedState state) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Text(
        //! LOCALIZE
        "Add Time Slots",
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
