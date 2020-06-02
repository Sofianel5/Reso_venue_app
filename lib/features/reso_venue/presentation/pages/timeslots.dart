import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localizations/localizations.dart';
import '../../domain/entities/timeslot.dart';
import '../bloc/root_bloc.dart';
import '../widgets/timeslot_card.dart';

class TimeSlotsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TimeSlotsScreenState();
}

class _TimeSlotsScreenState extends State<TimeSlotsScreen> {
  Widget _buildList(BuildContext context, List<TimeSlot> list) {
    return Container(
      height: MediaQuery.of(context).size.height - 270,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (BuildContext context, int index) {
          TimeSlot ts = list[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: TimeSlotCard(timeslot: ts),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final RootBloc rootBloc = BlocProvider.of<RootBloc>(context);
    return BlocListener(
      bloc: BlocProvider.of<TimeSlotsBloc>(context),
      listener: (context, state) {
        if (state is TimeSlotsLoadFailure) {
          //! Localize
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        } 
      },
      child: BlocBuilder(
        bloc: BlocProvider.of<TimeSlotsBloc>(context),
        builder: (content, state) => Column(
          children: <Widget>[
            SizedBox(
              height: 70,
            ),
            Text(
              "Your TimeSlots",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
            ),
            buildSwitchButtonRow(
                state, BlocProvider.of<TimeSlotsBloc>(context), context),
            SizedBox(
              height: 20,
            ),
            buildContents(state),
          ],
        ),
      ),
    );
  }

  Widget buildContents(TimeSlotsState state) {
    if (state is TimeSlotsLoaded) {
      if (state is NoCurrentTimeSlots || state is NoPreviousTimeSlots) {
        return Center(
          child: Text(
            Localizer.of(context).get(state is NoCurrentTimeSlots
                ? "NoCurrentTimeSlots"
                : "NoPreviousTimeSlots"),
          ),
        );
      } else {
        return Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 5, 20),
          child: _buildList(context, state.timeSlots),
        );
      }
    } else if (state is TimeSlotsLoadingState) {
      return Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 5, 20),
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (state is TimeSlotsLoadFailure) {
      return Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 5, 20),
        child: Center(
            child: Text(Localizer.of(context).get("failed") +
                ": " +
                Localizer.of(context).get(state.message))),
      );
    } else {
      return Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 5, 20),
        child: Center(child: Text(Localizer.of(context).get("failed"))),
      );
    }
  }

  Row buildSwitchButtonRow(state, TimeSlotsBloc bloc, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            if (state is TimeSlotsHistoryState) {
              bloc.add(TimeSlotsRequestCurrent());
            }
          },
          child: Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 5),
              child: Text(
                "Current",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    width: 3,
                    color: state is TimeSlotsHistoryState
                        ? Color(0xFFF3F5F7)
                        : Theme.of(context).accentColor),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (state is TimeSlotsCurrentState) {
              bloc.add(TimeSlotsRequestHistory());
            }
          },
          child: Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 5),
              child: Text(
                "History",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 3,
                  color: state is TimeSlotsHistoryState
                      ? Theme.of(context).accentColor
                      : Color(0xFFF3F5F7),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
