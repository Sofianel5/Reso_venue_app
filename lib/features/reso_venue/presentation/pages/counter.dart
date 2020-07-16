import 'package:Reso_venue/features/reso_venue/presentation/bloc/root_bloc.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CounterPageState();
}

class CounterPageState extends State<CounterPage> {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CounterPageBloc>(context);
    return BlocListener(
      listener: (context, state) {},
      bloc: bloc,
      child: BlocBuilder(
        bloc: bloc,
        builder: (context, state) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Spacer(flex: 4),
            Text('You have', style: Theme.of(context).textTheme.headline4),
            Spacer(),

            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  FloatingActionButton(
                    onPressed: () => bloc.add(CounterPageIncrement(by: -1)),
                    child: Icon(Icons.remove),
                  ),
                  if (state is CounterPageLoaded)
                    Text(
                      state.count.toString(),
                      style: Theme.of(context).textTheme.headline2,
                    )
                  else if (state is CounterPageLoading)
                    CircularProgressIndicator()
                  else
                    Text(
                      'Failed',
                    ),
                  FloatingActionButton(
                    onPressed: () => bloc.add(CounterPageIncrement(by: 1)),
                    child: Icon(Icons.add),
                  ),
                ]),
            Spacer(),

            Text(
              'visitors in',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              state.user.venues[state.user.currentVenue].title,
              style: Theme.of(context).textTheme.headline4,
              overflow: TextOverflow.ellipsis,
            ),
            Spacer(flex: 2),

            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text('Add Custom Amount: ',
                      style: Theme.of(context).textTheme.headline6),
                  RaisedButton(
                    child: Icon(Icons.add_circle),
                    onPressed: _showDialogue,
                  ),
                ]),
            Spacer(flex: 3),
            FlatButton(
              child: Text(
                'Clear',
                style: Theme.of(context).textTheme.headline6,
              ),
              onPressed: () => bloc.add(CounterPageClearConfirm()),
            ),
            Spacer(),

            // This trailing comma makes auto-formatting nicer for build methods.
          ],
        ),
      ),
    );
  }

  void _showDialogue() {
    showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return NumberPickerDialog.integer(
            initialIntegerValue: 1,
            minValue: 1,
            maxValue: 100,
          );
        }).then((int value) {
      BlocProvider.of<CounterPageBloc>(context)
          .add(CounterPageIncrement(by: value));
    });
  }
}
