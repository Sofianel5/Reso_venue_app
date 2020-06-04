import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/localizations/localizations.dart';
import 'features/reso_venue/presentation/bloc/root_bloc.dart';
import 'injection_container.dart' as ic;
import 'routes/routes.gr.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ic.init();
  runApp(ResoVenue());
}

class ResoVenue extends StatefulWidget {
  @override
  _ResoVenueState createState() => _ResoVenueState();
}

class _ResoVenueState extends State<ResoVenue> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ic.sl<RootBloc>(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Reso',
        builder: ExtendedNavigator<Router>(router: Router()),
        theme: ThemeData(
          primaryColor: Color(0xFF1b4774),
          accentColor: Color(0xFF03016c),
          scaffoldBackgroundColor: Color(0xFF00c2cc),
          //canvasColor: Color(0xFF5104f8),
          bottomAppBarColor: Color(0xFFF3F5F7),
        ),
        supportedLocales: [
          Locale("en"),
          Locale("fr"),
          Locale("ar"),
          Locale("es"),
          Locale("de"),
          Locale("nl"),
          Locale("it"),
          Locale("pl"),
        ],
        localizationsDelegates: [
          Localizer.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          if (locale == null) {
            return Locale("en");
          }
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
      ),
    );
  }
}
