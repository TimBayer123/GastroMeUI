import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gastrome/animations/SlideRightRoute.dart';
import 'package:gastrome/pages/CheckInAndLoadData.dart';
import 'package:gastrome/settings/globals.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

//Autor: Tim Bayer
//Diese Klasse stellt die Oberfläche des QR-Code Scanners dar

class QrCodeScan extends StatefulWidget {
  @override
  _QrCodeScanState createState() => _QrCodeScanState();
}

class _QrCodeScanState extends State<QrCodeScan> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController qrViewController;
  String qrText;
  String hintText= 'Bitte scannen sie den QR Code auf ihrem Tisch';
  bool blitzAn = false;

  //Funktionsweise: Diese Methode liefert die Oberfläche des QR-Code Scanners
  //Rückgabewert: Die Methode liefert die gesamte Oberfläche in Form eines Widgets
  //Übergabeparameter: Der BuildContext wird implizit übergeben
  @override
  Widget build(BuildContext context) {
    return Container(
      //Der Stack stapelt verschiedene Widgets übereinander.
        child: Stack(
          children: [
            //Es wird die QRView Full Screen dargestellt
            QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated
            ),
            //Hier wird der Rahmen für den QR Code angezeigt
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
            ),
            //Hier wird das Blitz-An Widget zusammengesetzt
            Positioned.fill(
              bottom: 85,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  //Hier wird der Blitz an oder aus geschaltet
                  onTap: (){
                    if( blitzAn == false ){
                      blitzAn = true;
                      qrViewController.toggleFlash();
                    } else{
                      blitzAn = false;
                      qrViewController.toggleFlash();
                    }
                    setState(() {});
                  },
                  child: Container(
                    //width: 250,
                    decoration: BoxDecoration(
                      color: blitzAn ? Theme.of(context).primaryColor :
                           qrText == null ? Theme.of(context).accentColor : Colors.green,
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
                      child: Icon(
                        Icons.highlight,
                        size: 35,
                        color: blitzAn ? Theme.of(context).accentColor : Theme.of(context).accentIconTheme.color,)
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
    );
  }

  //Funktionsweise: Diese Methode behandelt den Stream der den Scanner erzeugt (infolge einer Zeichenfolge).
  //Wird eine korrekte Zeichenfolge erkannt, werden die Daten verarbeitetn und auf den Lade Screen weitergeleitet
  //Rückgabewert: Die Methode liefert die erkannte Zeichenfolge
  //Übergabeparameter: Es wird ein QrViewController übergeben
  String _onQRViewCreated(QRViewController controller) {
    this.qrViewController = controller;
    //Hier wird die Zeichenfolge ausgelesen
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData;
      });
      print(qrText);
      //Hier wird die Zeichenfolge auf Richtigkeit überprüft. Es ist unter anderem ein Wasserzeichen implementiert, durch das fremde QR Codes abgelehnt werden
      if(qrText.length<= 22 || qrText.substring(0,22)!= 'GastroMe-Wasserzeichen'){
        setState(() {
          print('unzulässiger QR Code gefunden');
          qrText=null;
          hintText='Dieser QR-Code führt leider in kein Restaurant';
        });
        return;
      }
      String restaurantId = qrText.substring(23,59);
      print("restaurant: "+restaurantId);
      String tischId = qrText.substring(60,96);
      print("tischId: "+tischId);
      //Es wird der globale loggedIn Parameter gesetzt
      loggedIn=true;
      // Hier wird auf den Lade Screen weitergeleitet, welcher die benötigten Restaurantdaten lädt
      Navigator.pushReplacement(context, SlideRightRoute(page: CheckInAndLoadData(restaurantId: restaurantId, tischId: tischId,)));
      qrViewController.dispose();
    });
    return qrText;
  }

  //Funktionsweise: Die Dispose Methode beendet die erstellten Controller, um den Speicherplatz freizugeben
  @override
  void dispose() {
    qrViewController.dispose();
    super.dispose();
  }
}
