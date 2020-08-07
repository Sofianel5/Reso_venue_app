// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:Reso_venue/features/reso_venue/presentation/pages/root.dart';
import 'package:Reso_venue/features/reso_venue/presentation/pages/timeslot_manage.dart';
import 'package:Reso_venue/features/reso_venue/domain/entities/timeslot.dart';
import 'package:Reso_venue/features/reso_venue/presentation/pages/help.dart';
import 'package:Reso_venue/features/reso_venue/presentation/pages/attendee_list.dart';
import 'package:Reso_venue/features/reso_venue/presentation/pages/notes.dart';

abstract class Routes {
  static const rootPage = '/';
  static const manage = '/manage';
  static const help = '/help';
  static const attendeeListScreen = '/attendee-list-screen';
  static const notesScreen = '/notes-screen';
  static const all = {
    rootPage,
    manage,
    help,
    attendeeListScreen,
    notesScreen,
  };
}

class Router extends RouterBase {
  @override
  Set<String> get allRoutes => Routes.all;

  @Deprecated('call ExtendedNavigator.ofRouter<Router>() directly')
  static ExtendedNavigatorState get navigator =>
      ExtendedNavigator.ofRouter<Router>();

  @override
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.rootPage:
        if (hasInvalidArgs<RootPageArguments>(args)) {
          return misTypedArgsRoute<RootPageArguments>(args);
        }
        final typedArgs = args as RootPageArguments ?? RootPageArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => RootPage(key: typedArgs.key),
          settings: settings,
        );
      case Routes.manage:
        if (hasInvalidArgs<ManageScreenArguments>(args, isRequired: true)) {
          return misTypedArgsRoute<ManageScreenArguments>(args);
        }
        final typedArgs = args as ManageScreenArguments;
        return MaterialPageRoute<dynamic>(
          builder: (context) => ManageScreen(timeSlot: typedArgs.timeSlot),
          settings: settings,
        );
      case Routes.help:
        return MaterialPageRoute<dynamic>(
          builder: (context) => HelpScreen(),
          settings: settings,
        );
      case Routes.attendeeListScreen:
        if (hasInvalidArgs<AttendeeListScreenArguments>(args,
            isRequired: true)) {
          return misTypedArgsRoute<AttendeeListScreenArguments>(args);
        }
        final typedArgs = args as AttendeeListScreenArguments;
        return MaterialPageRoute<dynamic>(
          builder: (context) =>
              AttendeeListScreen(timeSlot: typedArgs.timeSlot),
          settings: settings,
        );
      case Routes.notesScreen:
        if (hasInvalidArgs<NotesScreenArguments>(args, isRequired: true)) {
          return misTypedArgsRoute<NotesScreenArguments>(args);
        }
        final typedArgs = args as NotesScreenArguments;
        return MaterialPageRoute<dynamic>(
          builder: (context) => NotesScreen(timeSlot: typedArgs.timeSlot),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}

// *************************************************************************
// Arguments holder classes
// **************************************************************************

//RootPage arguments holder class
class RootPageArguments {
  final Key key;
  RootPageArguments({this.key});
}

//ManageScreen arguments holder class
class ManageScreenArguments {
  final TimeSlot timeSlot;
  ManageScreenArguments({@required this.timeSlot});
}

//AttendeeListScreen arguments holder class
class AttendeeListScreenArguments {
  final TimeSlot timeSlot;
  AttendeeListScreenArguments({@required this.timeSlot});
}

//NotesScreen arguments holder class
class NotesScreenArguments {
  final TimeSlot timeSlot;
  NotesScreenArguments({@required this.timeSlot});
}
