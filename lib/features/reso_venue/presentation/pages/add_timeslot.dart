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
  final formatter = DateFormat('hh:mm aaa EEEE, LLLL d, y');

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
        builder: (context, state) => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildTopPadding(state),
            SizedBox(height: 20.0),
            TextField(
              //! Localize
              decoration: InputDecoration(labelText: "Num attendees"),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //! Localize
                Text("start"),
                DateTimeField(
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
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //! Localize
                Text("stop"),
                DateTimeField(
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
              ],
            ),
            Row(
              children: [
                //! Localize
                Text("type"),
                DropdownButton(
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
          ],
        ),
      ),
    );
  }
  
  Widget _buildSubmitButton(RootBloc bloc) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 55),
      child: GestureDetector(
        onTap: () {
          bloc.add(
              AddTimeSlotAttempt(type: type, start: start, stop: stop, numAttendees: int.parse(_numAttendees.text)));
        },
        child: AnimatedContainer(
            duration: Duration(seconds: 1),
            curve: Curves.fastOutSlowIn,
            decoration: BoxDecoration(
                color: Colors.black12, borderRadius: BorderRadius.circular(15)),
            width: 200,
            height: 70,
            child: Center(
              child: bloc.state is LoginLoadingState
                  ? CircularProgressIndicator()
                  : Text(
                      Localizer.of(context).get("submit") ?? "Submit",
                      style: TextStyle(
                        color: Colors.black,
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
      padding: const EdgeInsets.only(top: 10),
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
