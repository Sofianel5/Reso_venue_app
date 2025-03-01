import 'package:Reso_venue/core/localizations/localizations.dart';
import 'package:Reso_venue/features/reso_venue/presentation/bloc/root_bloc.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var qrText = "";

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (!(BlocProvider.of<ScanBloc>(context) is ScanLockedState)) {
        BlocProvider.of<ScanBloc>(context).add(ScanAttempted(scanData));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final scanBloc = BlocProvider.of<ScanBloc>(context);
    return BlocListener(
      listener: (context, state) {
        if (state is ScanUnsuccessfulState) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(Localizer.of(context).get(state.message)),
                content: Container(
                  height: 100,
                ),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text(
                      Localizer.of(context).get(
                        "Dismiss",
                      ),
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                      scanBloc.add(ScanDissmissed());
                    },
                  ),
                ],
              );
            },
          );
        } else if (state is ScanSuccessfulState) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(Localizer.of(context).get("Success")),
                  content: Container(
                    height: 300,
                    child: Column(
                      children: <Widget>[
                        AspectRatio(
                          aspectRatio: 1,
                          child: FlareActor(
                            "assets/success.flr",
                            animation: "Untitled",
                            fit: BoxFit.contain,
                            alignment: Alignment.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text(
                        Localizer.of(context).get(
                          "Cancel",
                        ),
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                        BlocProvider.of<ScanBloc>(context)
                            .add(ScanDissmissed());
                      },
                    ),
                    new FlatButton(
                      child: new Text(
                        Localizer.of(context).get(
                          "Confirm",
                        ),
                        style: TextStyle(color: Theme.of(context).accentColor),
                      ),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                        BlocProvider.of<ScanBloc>(context)
                            .add(ScanDissmissed());
                      },
                    ),
                  ],
                );
              });
        }
      },
      bloc: BlocProvider.of<ScanBloc>(context),
      child: BlocBuilder(
        bloc: BlocProvider.of<ScanBloc>(context),
        builder: (context, state) => Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
