import 'package:Reso_venue/features/reso_venue/presentation/pages/help.dart';
import 'package:auto_route/auto_route_annotations.dart';

import '../features/reso_venue/presentation/pages/root.dart';
import '../features/reso_venue/presentation/pages/timeslot_manage.dart';


@MaterialAutoRouter()
class $Router {
  @initial
  RootPage rootPage;
  ManageScreen manage;
  HelpScreen help;
}