import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gastrome/animations/ScaleRoute.dart';
import 'package:gastrome/animations/SlideRightRoute.dart';
import 'package:gastrome/pages/CheckInAndLoadData.dart';
import 'package:gastrome/settings/globals.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrCodeScan extends StatefulWidget {
  @override
  _QrCodeScanState createState() => _QrCodeScanState();
}

class _QrCodeScanState extends State<QrCodeScan> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController qrViewController;
  String qrText;
  String hintText= 'Bitte scannen sie den QR Code auf ihrem Tisch';

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
          children: [
            QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated
            ),
            Center(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: qrText == null ? Theme.of(context).accentColor : Colors.green,
                        width: 6
                    ),
                  boxShadow: <BoxShadow>[
                    new BoxShadow(
                    color: Colors.black26,
                    blurRadius: 2.0
                    )
                  ],
                ),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),

            Positioned.fill(
              bottom: 150,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 250,
                  decoration: BoxDecoration(
                    color: qrText == null ? Theme.of(context).accentColor : Colors.green,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: <BoxShadow>[
                      new BoxShadow(
                          color: Colors.black26,
                          blurRadius: 2.0
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(hintText,
                      style: Theme.of(context).textTheme.headline3,

                      ),
                  ),
                ),
              ),
            )
          ],
        ),
    );
  }

  String _onQRViewCreated(QRViewController controller) {
    this.qrViewController = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData;
      });
      print(qrText);
      if(qrText.length<= 22 || qrText.substring(0,22)!= 'GastroMe-Wasserzeichen'){
        setState(() {
          print('unzulässiger QR Code gefunden');
          qrText=null;
          hintText='Dieser QR-Code führt leider in kein Restaurant';
        });
        return;
      }
      String restaurantId = qrText.substring(23,59);
      String tischNr = qrText.substring(60,64);
      loggedIn = true;
      Navigator.pushReplacement(context, SlideRightRoute(page: CheckInAndLoadData(restaurantId: restaurantId, tischNr: tischNr,)));
      qrViewController.dispose();
    });
    return qrText;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
