import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/root_bloc.dart';
import 'account.dart';
import 'help.dart';
import 'scan.dart';
import 'timeslots.dart';
import 'counter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _key = GlobalKey<ScaffoldState>();
  int _selectedPage = 0;
  final List<Widget> _mainPages = [
    BlocProvider(
      create: (context) => TimeSlotsBloc(
          getTimeSlots: BlocProvider.of<RootBloc>(context).getTimeSlots,
          user: BlocProvider.of<RootBloc>(context).user),
      child: TimeSlotsScreen(),
    ),
    /*
    BlocProvider(
      create: (context) => AddTimeSlotBloc(
        addTimeSlot: BlocProvider.of<RootBloc>(context).addTimeSlot,
        user: BlocProvider.of<RootBloc>(context).user,
      ),
      child: AddTimeSlotScreen(),
    ),
    
    BlocProvider(
      create: (context) => HelpBloc(
        getHelp: BlocProvider.of<RootBloc>(context).getHelp,
        user: BlocProvider.of<RootBloc>(context).user,
      ),
      child: HelpScreen(),
    ),
    */
    BlocProvider(
      create: (context) => CounterPageBloc(
        user: BlocProvider.of<RootBloc>(context).user,
        increment: BlocProvider.of<RootBloc>(context).increment,
        clear: BlocProvider.of<RootBloc>(context).clear,
      ),
      child: CounterPage(),
    ),
    BlocProvider(
      create: (context) => ScanBloc(
        BlocProvider.of<RootBloc>(context).user,
        BlocProvider.of<RootBloc>(context).scan,
      ),
      child: ScanScreen(),
    ),
    BlocProvider(
      create: (context) =>
          AccountPageBloc(BlocProvider.of<RootBloc>(context).user),
      child: AccountScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final rootBloc = BlocProvider.of<RootBloc>(context);
    return BlocListener(
      bloc: BlocProvider.of<HomePageBloc>(context),
      listener: (context, state) {},
      child: BlocBuilder(
          bloc: BlocProvider.of<HomePageBloc>(context),
          builder: (context, state) {
            return Scaffold(
              key: _key,
              resizeToAvoidBottomInset: false,
              backgroundColor: Color(0xFFF3F5F7),
              body: _mainPages[_selectedPage],
              bottomNavigationBar: CurvedNavigationBar(
                backgroundColor: Color.fromRGBO(0, 0, 0, 0),
                animationCurve: Curves.easeInOutSine,
                animationDuration: Duration(milliseconds: 400),
                index: _selectedPage,
                onTap: (int value) {
                  BlocProvider.of<RootBloc>(context)
                      .add(PageChangeEvent(index: value));
                  setState(() {
                    _selectedPage = value;
                  });
                },
                items: <Widget>[
                  Icon(
                    Icons.list,
                    size: 30,
                    color: _selectedPage == 0
                        ? Theme.of(context).scaffoldBackgroundColor
                        : Colors.black,
                  ),
                  Icon(
                    Icons.confirmation_number,
                    size: 30,
                    color: _selectedPage == 1
                        ? Theme.of(context).scaffoldBackgroundColor
                        : Colors.black,
                  ),
                  Icon(
                    Icons.camera,
                    color: _selectedPage == 2
                        ? Theme.of(context).scaffoldBackgroundColor
                        : Colors.black,
                  ),
                  Icon(
                    Icons.account_circle,
                    size: 30,
                    color: _selectedPage == 4
                        ? Theme.of(context).scaffoldBackgroundColor
                        : Colors.black,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
