import 'package:Reso_venue/features/reso_venue/presentation/widgets/datetime_picker.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/localizations/localizations.dart';
import '../../domain/entities/timeslot.dart';
import '../bloc/root_bloc.dart';

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
              .showSnackBar(SnackBar(content: Text(Localizer.of(context).get(state.message))));
        } else if (state is AddTimeSlotSuccess) {
          setState(() {
            start = null;
            stop = null;
            _numAttendees = TextEditingController();
            type = null;
          });
          Scaffold.of(context).showSnackBar(SnackBar(content: Text(Localizer.of(context).get("Success"))));
        }
      },
      bloc: BlocProvider.of<AddTimeSlotBloc>(context),
      child: BlocBuilder(
        bloc: BlocProvider.of<AddTimeSlotBloc>(context),
        builder: (context, state) => Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  buildTopPadding(state),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(Localizer.of(context).get("num-attendees"),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextField(
                      decoration: InputDecoration(
                          labelText:
                              Localizer.of(context).get("num-attendees")),
                      controller: _numAttendees,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                          Localizer.of(context).get("start") +
                              ": " +
                              (start != null ? formatter.format(start ?? DateTime.now()) : Localizer.of(context).get("Choose")),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  FlatButton(
                    onPressed: () {
                      DatePicker.showPicker(context,
                          showTitleActions: true, onChanged: (date) {
                        setState(() {
                          start = date;
                        });
                      }, onConfirm: (date) {
                        print('confirm $date');
                        setState(() {
                          start = date;
                        });
                      }, pickerModel: CustomPicker(currentTime: DateTime.now(),locale: LocaleType.en),
                      );
                    },
                    child: Text(
                      'Choose',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                          Localizer.of(context).get("stop") +
                              ": " +
                              (stop != null ? formatter.format(stop) : Localizer.of(context).get("Choose")),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  FlatButton(
                    onPressed: () {
                      DatePicker.showPicker(context,
                          showTitleActions: true, onChanged: (date) {
                        setState(() {
                          stop = date;
                        });
                      }, onConfirm: (date) {
                        print('confirm $date');
                        setState(() {
                          stop = date;
                        });
                      }, pickerModel: CustomPicker(currentTime: DateTime.now(),locale: LocaleType.en),
                      );
                    },
                    child: Text(
                      'Choose',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(Localizer.of(context).get("type"),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  DropdownButton(
                    iconEnabledColor: Colors.white,
                    value: type,
                    hint: Text(Localizer.of(context).get("Choose")),
                    iconSize: 24,
                    elevation: 16,
                    items: TimeSlot.types
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(Localizer.of(context).get(value)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        type = value;
                      });
                    },
                    icon: Icon(Icons.arrow_downward, color: Theme.of(context).accentColor),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  _buildSubmitButton(BlocProvider.of<AddTimeSlotBloc>(context)),
                ],
              ),
            ),
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
                ? CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  )
                : Text(
                    Localizer.of(context).get("submit") ?? "Submit",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Padding buildTopPadding(AuthenticatedState state) {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Text(
        //! LOCALIZE
        Localizer.of(context).get("add-timeslots"),
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
